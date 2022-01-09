import fp from 'fastify-plugin'
import { Static, Type } from '@sinclair/typebox'
import { createVerifier } from 'fast-jwt'
import removeAccents from 'remove-accents'

function generateUniqueUsername (name: string) {
  return removeAccents(name).split(' ').join('')
}

export default fp(async fastify => {
  // POST /users

  const createSchema = {
    headers: Type.Object({
      authorization: Type.String()
    }),
    body: Type.Object({
      email: Type.String({ format: 'email' }),
      password: Type.String({ minLength: 8 }),
      name: Type.String({ minLength: 1, maxLength: 50 }),
      birthDate: Type.String({ format: 'date-time' })
    })
  }

  fastify.post<{ Headers: Static<typeof createSchema.headers>, Body: Static<typeof createSchema.body> }>(
    '/users',
    { schema: createSchema },
    async (req, reply) => {
      const { email, password, name, birthDate } = req.body

      try {
        const decoded = createVerifier({ key: process.env.EMAIL_VERIFICATION_JWT_SECRET || 'supersecret' })(req.headers.authorization) as { email: string }
        if (decoded.email !== email) {
          return reply.forbidden()
        }
      } catch (e) {
        return reply.unauthorized()
      }

      if (await fastify.prisma.user.findUnique({ where: { email }})) {
        return reply.conflict('Email "${email}" is already associated to an existing user')
      }

      const { password: _, ...user } = await fastify.prisma.user.create({
        data: {
          email,
          password,
          name,
          birthDate: new Date(birthDate),
          username: generateUniqueUsername(name)
        }
      })

      if (await fastify.prisma.emailVerification.count({ where: { email }})) {
        await fastify.prisma.emailVerification.delete({ where: { email } })
      }

      return {
        token: fastify.jwt.sign({ id: user.id }),
        user
      }
    })

  // GET /users/email_availability

  const checkEmailSchema = {
    querystring: Type.Object({
      email: Type.String({ format: 'email' })
    })
  }

  fastify.get<{ Querystring: Static<typeof checkEmailSchema.querystring> }>(
    '/users/check_email_availability',
    { schema: checkEmailSchema },
    async (req) => {
      const { email } = req.query
      return await fastify.prisma.user.count({ where: { email } }) === 0
    })

})
