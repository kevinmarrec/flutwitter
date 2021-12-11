module.exports = {
  preset: 'ts-jest',
  testTimeout: 20000,
  collectCoverage: true,
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/index.ts'
  ],
  coverageThreshold: {
    global: {
      statements: 90
    }
  }
}
