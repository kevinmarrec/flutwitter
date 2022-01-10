
import dotenv from 'dotenv'
import { createServer } from '../src/server'
import { setupDatabase, cleanDatabase, destroyDatabase } from './helpers/database'

dotenv.config({ path: '.env.test' })

jest.mock('nodemailer', () => ({
  createTransport: jest.fn().mockReturnValue({
    sendMail: jest.fn()
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

describe ('routes', () => {
  test('/', async () => {
    const response = await server.inject('/')
    expect(response.body).toBe('FlutTwitter API')
  })

  require('./routes/auth')
  require('./routes/emailVerifications')
  require('./routes/users')
})
