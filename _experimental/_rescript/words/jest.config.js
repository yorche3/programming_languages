module.exports = {
  // The file extensions Jest will look for
  moduleFileExtensions: [
    "js",
    "mjs",
  ],
  // The patterns Jest uses to detect test files
  testMatch: [
    "<rootDir>/test/**/*_test.res.mjs",
  ],
  // A map from regular expressions to paths to transformers
  transform: {
    "^.+\\.m?js$": "babel-jest"
  },
  // An array of regexp pattern strings that are matched against all source file paths before transformation.
  // We want to transform ReScript packages from node_modules.
  transformIgnorePatterns: [
    "node_modules/(?!(rescript|@glennsl/rescript-jest)/)"
  ],
};
