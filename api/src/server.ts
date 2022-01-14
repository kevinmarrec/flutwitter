import path from 'path'
import sensible from 'fastify-sensible'
import fastify, { FastifyInstance } from 'fastify'

import autoload from './utils/autoload'

export async function createServer (): Promise<FastifyInstance> {
  const server = fastify({
    logger: process.env.LOGGER === 'true' && /* istanbul ignore next */ {
      prettyPrint: {
        colorize: true,
        translateTime: 'SYS:HH:MM:ss.l p'
      }
    }
  })

  await server.register(sensible)
  await server.register(autoload, { dir: path.join(__dirname, 'plugins') })
  await server.register(autoload, { dir: path.join(__dirname, 'routes') })

  server.get('/', async () => {
    return 'FlutTwitter API'
  })

  // Health Check route
  server.get('/_health', async () => true)

  return server
}
