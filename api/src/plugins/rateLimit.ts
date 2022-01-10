
import fp from 'fastify-plugin'
import rateLimit, { RateLimitOptions } from 'fastify-rate-limit'

declare module 'fastify' {
  export interface FastifyContextConfig {
    rateLimit?: RateLimitOptions
  }
}

export default fp(async (fastify) => {
  fastify.register(rateLimit, {
    global: false,
    max: 1000,
    timeWindow: '1 minute'
  })
})
