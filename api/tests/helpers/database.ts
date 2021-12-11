import execa from 'execa'
import knex, { Knex } from 'knex'
import knexCleaner from 'knex-cleaner'

let client: Knex

export async function setupDatabase (): Promise<void> {
  await execa.command('./node_modules/.bin/prisma migrate reset -f --skip-generate --skip-seed')
  client = knex(process.env.DATABASE_URL || '')
}

export async function cleanDatabase (): Promise<void> {
  await knexCleaner.clean(client)
}

export async function destroyDatabase (): Promise<void> {
  await client.destroy()
  const databaseName = client.client.config.connection.database
  delete client.client.config.connection.database
  client = knex(client.client.config)
  await client.raw(`DROP DATABASE IF EXISTS ${databaseName}`)
  await client.destroy()
}
