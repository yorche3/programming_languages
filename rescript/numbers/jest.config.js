module.exports = {
  testEnvironment: 'node', // or 'jsdom' for browser environments
  transform: {
    '^.+\\.re\\.(js|mjs|cjs|jsx|ts|tsx)$': '<path_to_rescript_transformer>', // e.g., 'rescript-jest-transformer'
    // // If using ts-jest, you might configure it to handle ReScript's JS output
  },
  moduleFileExtensions: ['res', 'js', 'json', 'node'],
};