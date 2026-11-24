module.exports = {
  moduleFileExtensions: ["js", "mjs"],
  testMatch: ["<rootDir>/test/**/*_tests.res.mjs"],
  transform: {
    "^.+\\.m?js$": "babel-jest"
  },
  transformIgnorePatterns: [
    "node_modules/(?!(rescript|@glennsl/rescript-jest)/)"
  ]
};
