
import dotenv from 'dotenv'
import { afterAll, beforeAll, beforeEach, describe, expect, test, vi } from 'vitest'

import { createServer } from '../src/server'
import { cleanDatabase, destroyDatabase, setupDatabase } from './helpers/database'

dotenv.config({ path: '.env.test' })

vi.mock('nodemailer', () => ({
  createTransport: vi.fn().mockReturnValue({
    sendMail: vi.fn()
  })
}))

beforeAll(async () => {
  await setupDatabase()
  global.server = await createServer()
})

beforeEach(async () => {
  await cleanDatabase()
})

afterAll(async () => {
  await server.close()
  await destroyDatabase()
})

test('server is defined', () => {
  expect(server).toBeDefined()
})

test('server is healthy', async () => {
  const response = await server.inject('/_health')
  expect(response.statusCode).toBe(200)
})

describe ('routes', async () => {
  test('/', async () => {
    const response = await server.inject('/')
    expect(response.body).toBe('FlutTwitter API')
  })

  await import('./routes/auth')
  await import('./routes/emailVerifications')
  await import('./routes/users')
})
