import fastify, { FastifyInstance } from 'fastify'
import path from 'path'

export async function createServer (): Promise<FastifyInstance> {
  const server = fastify({
    logger: process.env.LOGGER === 'true'
  })

  // Enable TypeScript support for `fastify-autoload` plugin
  process.env['TS_NODE_DEV'] = 'true'

  await server.register(import('fastify-sensible'))
  await server.register(import('fastify-autoload'), { dir: path.join(__dirname, 'plugins') })
  await server.register(import('fastify-autoload'), { dir: path.join(__dirname, 'routes') })

  server.get('/', async () => {
    return 'Salut toi !'
  })

  // Health Check route
  server.get('/_health', async () => true)

  return server
}