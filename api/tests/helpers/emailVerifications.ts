import type { EmailVerification, Prisma } from '@prisma/client'
import { faker } from 'faker'

export async function createEmailVerification (input?: Partial<Prisma.EmailVerificationCreateInput>): Promise<EmailVerification> {
  return server.prisma.emailVerification.create({
    data: {
      email: faker.internet.email(),
      code: faker.datatype.number({ min: 100000, max: 999999 }),
      ...input
    }
  })
}
