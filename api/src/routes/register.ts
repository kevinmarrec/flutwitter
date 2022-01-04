import fp from 'fastify-plugin'
import { Static, Type } from '@sinclair/typebox'

export default fp(async fastify => {
  // POST /register

  const registerSchema = {
    body: Type.Object({
      name: Type.String({ maxLength: 50 }),
      email: Type.String({ format: 'email' }),
      birthDate: Type.String({ format: 'date-time' })
    })
  }

  fastify.post<{ Body: Static<typeof registerSchema.body> }>('/register', { schema: registerSchema }, async (req, reply) => {
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
        verificationCode: '999999'
      }
    })

    reply.status(201)
    reply.send(`Registration for email '${email}' has been created`)
  })


  // GET /register/check_email
  const checkEmailSchema = {
    querystring: Type.Object({
      email: Type.String({ format: 'email' })
    })
  }

  fastify.get<{ Querystring: Static<typeof checkEmailSchema.querystring> }>('/register/check_email', { schema: checkEmailSchema }, async (req) => {
    const { email } = req.query
    return await fastify.prisma.user.count({ where: { email } }) === 0
  })
})
