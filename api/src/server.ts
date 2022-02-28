import path from 'path'
import sensible from 'fastify-sensible'
import fastify, { FastifyInstance } from 'fastify'

import autoload from './utils/autoload'

export async function createServer (): Promise<FastifyInstance> {
  const server = fastify({
    /* c8 ignore start */
    logger:  process.env.LOGGER === 'true' && {
      prettyPrint: {
        colorize: true,
        translateTime: 'SYS:HH:MM:ss.l p'
      }
    }
    /* c8 ignore stop */
  })

  await server.register(sensible)
  await server.register(autoload, { dir: path.join(__dirname, 'plugins') })
  await server.register(autoload, { dir: path.join(__dirname, 'routes') })

  server.get('/', async () => 'FlutTwitter API')

  // Health Check route
  server.get('/_health', async () => true)

  return server
}
