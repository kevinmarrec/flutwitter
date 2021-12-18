import fp from 'fastify-plugin'
import { Static, Type } from '@sinclair/typebox'

export default fp(async fastify => {
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
