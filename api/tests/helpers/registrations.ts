import type { Prisma, Registration } from '@prisma/client'
import faker from 'faker'

export async function createRegistration (input?: Partial<Prisma.RegistrationCreateInput>): Promise<Registration> {
  const firstName = faker.name.firstName()
  const lastName = faker.name.lastName()

  return server.prisma.registration.create({
    data: {
      email: faker.internet.email(),
      name: `${firstName} ${lastName}`,
      birthDate: faker.date.past(25, new Date(2000, 0, 0)),
      verificationCode: faker.datatype.number({ min: 100000, max: 999999 }),
      ...input
    }
  })
}
