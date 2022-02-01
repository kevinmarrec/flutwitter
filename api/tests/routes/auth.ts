import bcrypt from 'bcryptjs'
import { faker } from 'faker'
import { describe, expect, test } from 'vitest'

import { createUser } from '../helpers/users'

describe('POST /auth/login', () => {
  test('returns authenticated user with token', async () => {
    const password = faker.internet.password(8)

    const user = await createUser({
      passwordHash: bcrypt.hashSync(password, 10)
    })

    const response = await server.inject({
      method: 'POST',
      url: '/auth/login',
      payload: {
        email: user.email,
        password
      }
    })

    expect(response.statusCode).toBe(200)

    const body = response.json()

    expect(body.token).toBeTruthy()
    expect(body.user).toEqual(expect.objectContaining({
      name: user.name,
      username: user.username
    }))
  })

  test('returns 401 Bad Request when bad credentials', async () => {
    const response = await server.inject({
      method: 'POST',
      url: '/auth/login',
      payload: {
        email: 'foo@bar.baz',
        password: 'foobar42'
      }
    })

    expect(response.statusCode).toBe(401)
  })
})
