import { createUser } from '../helpers/users'

describe('POST /auth/login', () => {
  test('returns authenticated user with token', async () => {
    const user = await createUser()

    const response = await server.inject({
      method: 'POST',
      url: '/auth/login',
      payload: {
        email: user.email,
        password: user.password
      }
    })

    expect(response.statusCode).toBe(200)

    const body = response.json()

    expect(body.token).toBeTruthy()
    expect(body.user).toEqual(expect.objectContaining({
      id: user.id,
      email: user.email
    }))
  })

  test('returns 401 Bad Request when bad credentials', async () => {
    const response = await server.inject({
      method: 'POST',
      url: '/auth/login',
      payload: {
        email: 'x@y.z',
        password: 'foobar42'
      }
    })

    expect(response.statusCode).toBe(401)
  })
})
