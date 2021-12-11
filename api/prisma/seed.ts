import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function seed () {
  await prisma.user.create({
    data: {
      required: 'Michel',
      optional: ''
    }
  })
}

seed()
  .catch(err => {
    console.error(err)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
