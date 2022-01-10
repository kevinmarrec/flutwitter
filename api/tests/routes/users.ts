import faker from 'faker'
import { createSigner } from 'fast-jwt'

import { createEmailVerification } from '../helpers/emailVerifications'
import { createUser, makeUser } from '../helpers/users'

describe('POST /users', () => {
  const email: string = faker.internet.email()
  let authorizationToken: string

  beforeEach(async () => {
    await createEmailVerification({ email })
    authorizationToken = createSigner({ key: 'supersecret' })({ email })
  })

  test('creates a new user', async () => {
    const response = await server.inject({
      method: 'POST',
      url: '/users',
      headers: {
        authorization: authorizationToken
      },
      payload: makeUser({ email })
    })

    expect(await server.prisma.user.findUnique({ where: { email} })).toBeTruthy()

    expect(response.statusCode).toBe(200)
    expect(response.json()).toEqual(expect.objectContaining({
      user: expect.objectContaining({
        email
      })
    }))
  })

  test('returns 401 Unauthorized if authorization token is invalid', async () => {
    const response = await server.inject({
      method: 'POST',
      url: '/users',
      headers: {
        authorization: 'foo'
      },
      payload: makeUser({ email: 'foo@bar.baz' })
    })

    expect(response.statusCode).toBe(401)
  })

  test('returns 403 Forbidden if payload email does not match authorization email', async () => {
    const response = await server.inject({
      method: 'POST',
      url: '/users',
      headers: {
        authorization: authorizationToken
      },
      payload: makeUser({ email: 'foo@bar.baz' })
    })

    expect(response.statusCode).toBe(403)
  })

  test('returns 409 Conflict if email is already in use', async () => {
    await createUser({ email })

    const response = await server.inject({
      method: 'POST',
      url: '/users',
      headers: {
        authorization: authorizationToken
      },
      payload: makeUser({ email })
    })

    expect(response.statusCode).toBe(409)
  })
})

describe('GET /users/check_email_availability', () => {
  test('returns true if email is available', async () => {
    const response = await server.inject({
      method: 'GET',
      url: '/users/check_email_availability',
      query: {
        email: faker.internet.email()
      }
    })

    expect(response.statusCode).toBe(200)
    expect(response.json()).toBe(true)
  })

  test('returns false if email is already in use', async () => {
    const user = await createUser()

    const response = await server.inject({
      method: 'GET',
      url: '/users/check_email_availability',
      query: {
        email: user.email
      }
    })

    expect(response.statusCode).toBe(200)
    expect(response.json()).toBe(false)
  })
})
