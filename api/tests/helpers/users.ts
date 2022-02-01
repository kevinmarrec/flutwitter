import type { Prisma, User } from '@prisma/client'
import bcrypt from 'bcryptjs'
import { faker } from 'faker'

interface UserPayload extends Pick<User, 'email' | 'name'> {
  birthDate: string
  password: string
}

export function makeUserPayload (data?: Partial<UserPayload>): UserPayload  {
  const firstName = faker.name.firstName()
  const lastName = faker.name.lastName()

  return {
    email: faker.internet.email(firstName, lastName),
    password: faker.internet.password(8),
    name: `${firstName} ${lastName}`,
    birthDate: faker.date.past(25).toISOString(),
    ...data
  }
}

export async function createUser (input?: Partial<Prisma.UserCreateInput>): Promise<User> {
  const firstName = faker.name.firstName()
  const lastName = faker.name.lastName()

  return server.prisma.user.create({
    data: {
      email: faker.internet.email(firstName, lastName),
      passwordHash: bcrypt.hashSync(faker.internet.password(8), 10),
      name: `${firstName} ${lastName}`,
      username: faker.internet.userName(firstName, lastName),
      birthDate: faker.date.past(25).toISOString(),
      ...input
    }
  })
}
