describe('/register', () => {
  test('registers new user & returns it with token', async () => {
    const payload = {
      email: 'x@y.z',
      password: 'foobar42'
    }

    const response = await server.inject({
      method: 'POST',
      url: '/register',
      payload
    })

    expect(response.statusCode).toBe(200)

    const users = await server.prisma.user.findMany()

    expect(users.length).toBe(1)
    expect(users[0].email).toBe(payload.email)

    const body = response.json()

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
      url: '/register',
      payload: {
        email: user.email,
        password: user.password
      }
    })

    expect(response.statusCode).toBe(409)
  })
})

describe('/register/check_email', () => {
  test('returns true if email is not already in use', async () => {
    const response = await server.inject({
      method: 'GET',
      url: '/register/check_email',
      query: {
        email: 'x@y.z'
      }
    })

    expect(response.statusCode).toBe(200)
    expect(response.json()).toBe(true)
  })

  test('returns false if email is already in use', async () => {
    await server.prisma.user.create({
      data: {
        email: 'x@y.z',
        password: 'foobar42'
      }
    })

    const response = await server.inject({
      method: 'GET',
      url: '/register/check_email',
      query: {
        email: 'x@y.z'
      }
    })

    expect(response.statusCode).toBe(200)
    expect(response.json()).toBe(false)
  })
})
