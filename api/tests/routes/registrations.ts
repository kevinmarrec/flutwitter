import type { Registration } from '@prisma/client'
import faker from 'faker'

import { createRegistration } from '../helpers/registrations'
import { createUser } from '../helpers/users'

describe('POST /registrations', () => {
  const registrationPayload: Pick<Registration, 'email' | 'name' | 'birthDate'> = {
    email: faker.internet.email(),
    name: faker.name.findName(),
    birthDate: faker.date.past(25, new Date(2000, 0, 0))
  }

  test('creates a new registration', async () => {
    const response = await server.inject({
      method: 'POST',
      url: '/registrations',
      payload: registrationPayload
    })

    expect(response.statusCode).toBe(201)

    const registration = await server.prisma.registration.findFirst()

    expect(registration).toBeTruthy()
    expect(registration).toEqual(expect.objectContaining(registrationPayload))
  })

  test('returns 409 Conflict when email is already associated to an existing user', async () => {
    const user = await createUser()

    const response = await server.inject({
      method: 'POST',
      url: '/registrations',
      payload: {
        ...registrationPayload,
        email: user.email
      }
    })

    expect(response.statusCode).toBe(409)
  })

  test('returns 409 Conflict when email is already associated to a pending registration', async () => {
    const registration = await createRegistration()

    const response = await server.inject({
      method: 'POST',
      url: '/registrations',
      payload: {
        ...registrationPayload,
        email: registration.email
      }
    })

    expect(response.statusCode).toBe(409)
  })
})

describe('GET /registrations/check_email', () => {
  test('returns true if email is not already in use', async () => {
    const response = await server.inject({
      method: 'GET',
      url: '/registrations/check_email',
      query: {
        email: 'foo@bar.baz'
      }
    })

    expect(response.statusCode).toBe(200)
    expect(response.json()).toBe(true)
  })

  test('returns false if email is already used (by user)', async () => {
    const user = await createUser()

    const response = await server.inject({
      method: 'GET',
      url: '/registrations/check_email',
      query: {
        email: user.email
      }
    })

    expect(response.statusCode).toBe(200)
    expect(response.json()).toBe(false)
  })

  test('returns false if email is already used (by registration)', async () => {
    const registration = await createRegistration()

    const response = await server.inject({
      method: 'GET',
      url: '/registrations/check_email',
      query: {
        email: registration.email
      }
    })

    expect(response.statusCode).toBe(200)
    expect(response.json()).toBe(false)
  })
})


describe('POST /registrations/:id/verify', () => {
  test('returns registration if verification code is correct', async () => {
    const registration = await createRegistration()

    const response = await server.inject({
      method: 'POST',
      url: `/registrations/${registration.id}/verify`,
      payload: {
        verificationCode: registration.verificationCode
      }
    })

    expect(response.statusCode).toBe(200)
    expect(response.json()).toEqual(expect.objectContaining({
      email: registration.email
    }))
  })

  test('returns 404 Not Found if registration does not exist', async () => {
    const response = await server.inject({
      method: 'POST',
      url: '/registrations/1/verify',
      payload: {
        verificationCode: '000000'
      }
    })

    expect(response.statusCode).toBe(404)
  })

  test('returns 403 Forbidden if verification code is incorrect', async () => {
    const registration = await createRegistration()

    const response = await server.inject({
      method: 'POST',
      url: `/registrations/${registration.id}/verify`,
      payload: {
        verificationCode: '000000'
      }
    })

    expect(response.statusCode).toBe(403)
  })
})

describe('POST /registrations/:id/complete', () => {
  test('creates user & deletes registration when a registration is completed', async () => {
    const registration = await createRegistration()

    const response = await server.inject({
      method: 'POST',
      url: `/registrations/${registration.id}/complete`,
      payload: {
        password: faker.internet.password(8),
        verificationCode: registration.verificationCode
      }
    })

    expect(response.statusCode).toBe(200)

    const user = await server.prisma.user.findFirst({ select: { email: true } })

    expect(user).toBeTruthy()
    expect(user?.email).toEqual(registration.email)

    expect(await server.prisma.registration.count()).toBe(0)
  })

  test('returns 404 Not Found if registration does not exist', async () => {
    const response = await server.inject({
      method: 'POST',
      url: '/registrations/1/complete',
      payload: {
        password: faker.internet.password(8),
        verificationCode: '000000'
      }
    })

    expect(response.statusCode).toBe(404)
  })

  test('returns 403 Forbidden if verification code is incorrect', async () => {
    const registration = await createRegistration()

    const response = await server.inject({
      method: 'POST',
      url: `/registrations/${registration.id}/complete`,
      payload: {
        password: faker.internet.password(8),
        verificationCode: '000000'
      }
    })

    expect(response.statusCode).toBe(403)
  })
})
