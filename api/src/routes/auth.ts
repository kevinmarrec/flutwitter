import fp from 'fastify-plugin'
import { Static, Type } from '@sinclair/typebox'

export default fp(async fastify => {
  // POST /auth/register

  const registerSchema = {
    body: Type.Object({
      email: Type.String({ format: 'email' }),
      password: Type.String({ minLength: 8 })
    })
  }

  fastify.post<{ Body: Static<typeof loginSchema.body> }>('/auth/register', { schema: registerSchema }, async (req, reply) => {
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

  // POST /auth/login

  const loginSchema = {
    body: Type.Object({
      email: Type.String({ format: 'email' }),
      password: Type.String({ minLength: 8 })
    })
  }

  fastify.post<{ Body: Static<typeof loginSchema.body> }>('/auth/login', { schema: loginSchema }, async (req, reply) => {
    const { email, password } = req.body

    const user = await fastify.prisma.user.findFirst({
      where: {
        email,
        password
      },
      select: {
        id: true,
        email: true
      }
    })

    if (!user) {
      return reply.unauthorized('Bad credentials')
    }

    return {
      token: fastify.jwt.sign({ id: user.id }),
      user
    }
  })
})
