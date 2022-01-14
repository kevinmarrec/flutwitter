import fp from 'fastify-plugin'
import path from 'path'
import { readdir } from 'fs/promises'

interface AutoLoadOptions {
  dir: string
}

async function findPlugins (dir: string) {
  const entries = await readdir(dir, { withFileTypes: true })
  const plugins: string[] = []

  for (const entry of entries.filter(entry => entry.name !== 'index.ts')) {
    if (entry.isFile()) {
      plugins.push(path.join(dir, entry.name))
    }
  }

  return plugins
}


export default fp<AutoLoadOptions>(async (fastify, { dir }) => {
  const plugins = await findPlugins(dir)
  await Promise.all(plugins.map(plugin => {
    return import(plugin).then((p) => fastify.register(p))
  }))
})
