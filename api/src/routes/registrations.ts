import fp from 'fastify-plugin'
import { Static, Type } from '@sinclair/typebox'
import removeAccents from 'remove-accents'

function generateUniqueUsername (name: string) {
  return removeAccents(name).split(' ').join('')
}

export default fp(async fastify => {
  // POST /registrations

  const createSchema = {
    body: Type.Object({
      name: Type.String({ maxLength: 50 }),
      email: Type.String({ format: 'email' }),
      birthDate: Type.String({ format: 'date-time' })
    })
  }

  fastify.post<{ Body: Static<typeof createSchema.body> }>(
    '/registrations',
    { schema: createSchema },
    async (req, reply) => {
      const { name, email, birthDate } = req.body

      if (await fastify.prisma.user.findUnique({ where: { email } })) {
        return reply.conflict(`Email "${email}" is already associated to an existing user`)
      }

      if (await fastify.prisma.registration.findUnique({ where: { email } })) {
        return reply.conflict(`Email "${email}" is already associated to a pending registration`)
      }

      await fastify.prisma.registration.create({
        data: {
          email,
          name,
          birthDate: new Date(birthDate),
          verificationCode: Math.floor(100000 + Math.random() * 900000)
        }
      })

      reply.status(201)
      reply.send(`Registration for email '${email}' has been created`)
    })

  // GET /registrations/check_email

  const checkEmailSchema = {
    querystring: Type.Object({
      email: Type.String({ format: 'email' })
    })
  }

  fastify.get<{ Querystring: Static<typeof checkEmailSchema.querystring> }>(
    '/registrations/check_email',
    { schema: checkEmailSchema },
    async (req) => {
      const { email } = req.query

      if (await fastify.prisma.user.count({ where: { email } }) > 0) {
        return false
      }

      if (await fastify.prisma.registration.count({ where: { email } }) > 0) {
        return false
      }

      return true
    })


  // POST /registrations/:id/verify

  const verifySchema = {
    params: Type.Object({
      id: Type.Number()
    }),
    body: Type.Object({
      verificationCode: Type.Number({ pattern: '^\\d{6}$' })
    })
  }

  fastify.post<{ Params: Static<typeof verifySchema.params>, Body: Static<typeof verifySchema.body> }>(
    '/registrations/:id/verify',
    { schema: verifySchema },
    async (req, reply) => {
      const { id } = req.params
      const { verificationCode } = req.body

      const registration = await fastify.prisma.registration.findUnique({ where: { id }})

      if (!registration) {
        return reply.notFound('Registration not found')
      }

      if (verificationCode !== registration.verificationCode) {
        return reply.forbidden('Incorrect verification code')
      }

      return registration
    })

  // POST /registrations/:id/complete

  const completeSchema = {
    params: Type.Object({
      id: Type.Number()
    }),
    body: Type.Object({
      password: Type.String({ minLength: 8 }),
      verificationCode: Type.Number({ pattern: '^\\d{6}$' })
    })
  }

  fastify.post<{ Params: Static<typeof completeSchema.params>, Body: Static<typeof completeSchema.body> }>(
    '/registrations/:id/complete',
    { schema: completeSchema },
    async (req, reply) => {
      const { id } = req.params
      const { password, verificationCode } = req.body

      const registration = await fastify.prisma.registration.findUnique({ where: { id }})

      if (!registration) {
        return reply.notFound('Registration not found')
      }

      if (verificationCode !== registration.verificationCode) {
        return reply.forbidden('Incorrect verification code')
      }

      const { email, name, birthDate } = registration

      const user = await fastify.prisma.user.create({
        data: {
          email,
          name,
          birthDate,
          password,
          username: generateUniqueUsername(name)
        }
      })

      await fastify.prisma.registration.delete({ where: { id: registration.id } })

      return user
    })
})
