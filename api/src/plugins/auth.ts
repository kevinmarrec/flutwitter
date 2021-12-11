import fp from 'fastify-plugin'
import fastifyJWTPlugin from 'fastify-jwt'
import { preValidationAsyncHookHandler } from 'fastify'

declare module 'fastify' {
  export interface FastifyInstance {
    authenticate: preValidationAsyncHookHandler
  }
}

declare module 'fastify-jwt' {
  interface FastifyJWT {
    payload: {
      id: number
    }
  }
}

export default fp(async (fastify) => {
  fastify.register(fastifyJWTPlugin, { secret: process.env.JWT_SECRET || 'supersecret' })
  fastify.decorate<preValidationAsyncHookHandler>('authenticate', async function (request, reply) {
    try {
      await request.jwtVerify()
    } catch (err) {
      reply.send(err)
    }
  })
})
