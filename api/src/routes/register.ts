import fp from 'fastify-plugin'
import { Static, Type } from '@sinclair/typebox'

export default fp(async fastify => {
  // POST /register

  const registerSchema = {
    body: Type.Object({
      email: Type.String({ format: 'email' }),
      password: Type.String({ minLength: 8 })
    })
  }

  fastify.post<{ Body: Static<typeof registerSchema.body> }>('/register', { schema: registerSchema }, async (req, reply) => {
    const { email, password } = req.body

    if (await fastify.prisma.user.findUnique({ where: { email } })) {
      return reply.conflict(`Email "${email}" is already associated to an existing user`)
    }

    const user = await fastify.prisma.user.create({
      data: {
        email,
        password
      }
    })

    return {
      token: fastify.jwt.sign({ id: user.id }),
      user
    }
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
