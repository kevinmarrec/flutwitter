import dotenv from 'dotenv'
import { FastifyInstance } from 'fastify'
import { createServer } from './server'

let server: FastifyInstance

dotenv.config({ path: `.env.${process.env.NODE_ENV === 'production' ? 'production' : 'development' }` })

async function start () {
  server = await createServer()

  try {
    await server.listen(process.env.PORT || 4000, '0.0.0.0')
  } catch (err) {
    server.log.error(err)
    process.exit(1)
  }
}

process.on('SIGINT', async () => {
  await server.close()
  process.exit()
})

start()
