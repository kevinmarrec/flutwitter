import fp from 'fastify-plugin'
import { createTransport, Transporter } from 'nodemailer'

declare module 'fastify' {
  export interface FastifyInstance {
    mailer: Transporter
  }
}


export default fp(async (fastify) => {
  fastify.decorate('mailer', createTransport({
    host: process.env.MAILER_HOST,
    port: 587,
    auth: {
      user: process.env.MAILER_USER,
      pass: process.env.MAILER_PASS
    }
  }))
})
