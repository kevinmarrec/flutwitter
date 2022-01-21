import bcrypt from 'bcryptjs'
import fp from 'fastify-plugin'
import { Static, Type } from '@sinclair/typebox'

import { pick } from '../utils/object'

export default fp(async fastify => {
  // POST /auth/login

  const loginSchema = {
    body: Type.Object({
      email: Type.String({ format: 'email' }),
      password: Type.String({ minLength: 8 })
    })
  }

  fastify.post<{ Body: Static<typeof loginSchema.body> }>('/auth/login', { schema: loginSchema }, async (request, reply) => {
    const { email, password } = request.body

    const user = await fastify.prisma.user.findUnique({
      where: {
        email
      }
    })

    if (!user || !bcrypt.compareSync(password, user.passwordHash)) {
      return reply.unauthorized('Bad credentials')
    }

    return {
      token: fastify.jwt.sign({ id: user.id }),
      user: pick(user, ['name', 'username'])
    }
  })
})
