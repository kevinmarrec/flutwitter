describe('/register', () => {
  const registrationPayload = {
    name: 'foo',
    email: 'x@y.z',
    birthDate: new Date()
  }

  test('creates a new registration', async () => {
    const response = await server.inject({
      method: 'POST',
      url: '/register',
      payload: registrationPayload
    })

    expect(response.statusCode).toBe(201)

    const registration = await server.prisma.registration.findFirst()

    expect(registration).toEqual(expect.objectContaining(registrationPayload))
  })

  test('returns 409 Conflict when email is already associated to an existing user', async () => {
    await server.prisma.user.create({
      data: {
        email: registrationPayload.email,
        password: 'foobar42'
      }
    })

    const response = await server.inject({
      method: 'POST',
      url: '/register',
      payload: registrationPayload
    })

    expect(response.statusCode).toBe(409)
  })

  test('returns 409 Conflict when email is already associated to a pending registration', async () => {
    await server.prisma.registration.create({
      data: {
        ...registrationPayload,
        verificationCode: ''
      }
    })

    const response = await server.inject({
      method: 'POST',
      url: '/register',
      payload: registrationPayload
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
