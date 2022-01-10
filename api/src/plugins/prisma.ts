import { PrismaClient } from '@prisma/client'
import fp from 'fastify-plugin'

declare module 'fastify' {
  export interface FastifyInstance {
    prisma: PrismaClient
  }
}

export default fp(async (fastify) => {
  const client = new PrismaClient()
  fastify.decorate('prisma', client)
  fastify.addHook('onClose', async () => {
    await client.$disconnect()
  })
})
