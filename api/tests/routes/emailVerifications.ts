import type { EmailVerification } from '@prisma/client'
import { faker } from 'faker'
import { beforeEach, describe, expect, test } from 'vitest'

import { createEmailVerification } from '../helpers/emailVerifications'
import { createUser } from '../helpers/users'

describe('POST /email_verifications', () => {
  const email = faker.internet.email()

  test('creates a new email verification', async () => {
    const response = await server.inject({
      method: 'POST',
      url: '/email_verifications',
      payload: {
        email
      }
    })

    expect(response.statusCode).toBe(201)
    expect(await server.prisma.emailVerification.findUnique({ where: { email} })).toBeTruthy()
  })

  test('returns 400 Bad Request if email is already associated to an user', async () => {
    await createUser({ email })

    const response = await server.inject({
      method: 'POST',
      url: '/email_verifications',
      payload: {
        email
      }
    })

    expect(response.statusCode).toBe(400)
  })
})

describe('POST /email_verifications/verify', () => {
  let emailVerification: EmailVerification

  beforeEach(async () => {
    emailVerification = await createEmailVerification()
  })

  test('returns email verification token', async () => {
    const response = await server.inject({
      method: 'POST',
      url: '/email_verifications/verify',
      payload: {
        email: emailVerification.email,
        code: emailVerification.code
      }
    })

    expect(response.statusCode).toBe(200)
    expect(response.json()).toHaveProperty('token')
  })

  test('returns 403 Forbidden is the verification code is incorrect', async () => {
    let code: number
    do { code = faker.datatype.number({ min: 100000, max: 999999 }) }
    while (code === emailVerification.code)

    const response = await server.inject({
      method: 'POST',
      url: '/email_verifications/verify',
      payload: {
        email: emailVerification.email,
        code
      }
    })

    expect(response.statusCode).toBe(403)
  })
})
