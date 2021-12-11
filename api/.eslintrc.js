module.exports = {
  root: true,
  env: {
    node: true
  },
  parser: '@typescript-eslint/parser',
  plugins: [
    '@typescript-eslint'
  ],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended'
  ],
  rules: {
    indent: ['error', 2, { SwitchCase: 1 }],
    quotes: ['warn', 'single'],
    semi: ['error', 'never'],
    'comma-dangle': ['error', 'never'],
    'space-before-function-paren': ['error', 'always'],
    'space-infix-ops': ['error'],
    '@typescript-eslint/no-unused-vars': ['error', {
      args: 'all',
      argsIgnorePattern: '^_',
      varsIgnorePattern: '^_'
    }]
  }
}
