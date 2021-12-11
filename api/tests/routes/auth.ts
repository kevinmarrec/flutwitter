describe('/auth/register', () => {
  test('registers new user & returns it with token', async () => {
    const payload = {
      email: 'x@y.z',
      password: 'foobar42'
    }

    const response = await server.inject({
      method: 'POST',
      url: '/auth/register',
      payload
    })

    expect(response.statusCode).toBe(200)

    const users = await server.prisma.user.findMany()

    expect(users.length).toBe(1)
    expect(users[0].email).toBe(payload.email)

    const body = JSON.parse(response.body)

    expect(body.token).toBeTruthy()
    expect(body.user).toEqual(expect.objectContaining({
      id: users[0].id,
      email: users[0].email
    }))
  })

  test('returns 409 Conflict when email is already used', async () => {
    const user = await server.prisma.user.create({
      data: {
        email: 'x@y.z',
        password: 'foobar42'
      }
    })

    const response = await server.inject({
      method: 'POST',
      url: '/auth/register',
      payload: {
        email: user.email,
        password: user.password
      }
    })

    expect(response.statusCode).toBe(409)
  })
})

describe('/auth/login', () => {
  test('returns authenticated user with token', async () => {
    const user = await server.prisma.user.create({
      data: {
        email: 'x@y.z',
        password: 'foobar42'
      }
    })

    const response = await server.inject({
      method: 'POST',
      url: '/auth/login',
      payload: {
        email: user.email,
        password: user.password
      }
    })

    expect(response.statusCode).toBe(200)

    const body = JSON.parse(response.body)

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
