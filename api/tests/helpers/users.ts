import type { Prisma, User } from '@prisma/client'
import faker from 'faker'

export async function createUser (input?: Partial<Prisma.UserCreateInput>): Promise<User> {
  const firstName = faker.name.firstName()
  const lastName = faker.name.lastName()

  return server.prisma.user.create({
    data: {
      email: faker.internet.email(firstName, lastName),
      password: faker.internet.password(8),
      name: `${firstName} ${lastName}`,
      username: faker.internet.userName(firstName, lastName),
      birthDate: faker.date.past(25),
      ...input
    }
  })
}
