import fp from 'fastify-plugin'
import { Static, Type } from '@sinclair/typebox'
import { createSigner } from 'fast-jwt'

export default fp(async fastify => {
  // POST /email_verifications

  const createSchema = {
    body: Type.Object({
      email: Type.String({ format: 'email' })
    })
  }

  fastify.post<{ Body: Static<typeof createSchema.body> }>(
    '/email_verifications',
    { schema: createSchema },
    async (req, reply) => {
      const { email } = req.body

      if (await fastify.prisma.user.findUnique({ where: { email } })) {
        return reply.badRequest('Email "${email}" is already associated to an existing user')
      }

      const code = Math.floor(100000 + Math.random() * 900000)

      await fastify.prisma.emailVerification.upsert({
        where: { email },
        create: { email, code },
        update: { email, code }
      })

      reply.status(201)
      reply.send()
    })

  // POST /email_verifications/verify

  const verifySchema = {
    body: Type.Object({
      email: Type.String({ format: 'email' }),
      code: Type.Number({ pattern: '^\\d{6}$' })
    })
  }

  fastify.post<{ Body: Static<typeof verifySchema.body> }>(
    '/email_verifications/verify',
    { schema: verifySchema },
    async (req, reply) => {
      const { email, code } = req.body

      const emailVerification = await fastify.prisma.emailVerification.findFirst({ where: { email, code }})

      if (!emailVerification) {
        return reply.forbidden('Incorrect verification code')
      }

      return {
        token: createSigner({ key: process.env.EMAIL_VERIFICATION_JWT_SECRET || 'supersecret' })({ email })
      }
    })
})
