import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

async function seed () {
  // Seed some data here
}

seed()
  .catch(err => {
    console.error(err)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
