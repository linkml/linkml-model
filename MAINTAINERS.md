# Release Process

- Close all issues for planned release
- Update, tag, commit, and push version in package.json to be a semver pre-release; run `npm version <semver-pre-release>`
- Trigger CI build from tag to call `./gradlew publishPackage`
- Verify pre-released packacke
  - Create a temporary node project
  - In temporary project, run `npm install <pre-release-semver-tag>`
  - Inspect that installed package is as expected
- Update, tag, commit, and push version in package.json to be a semver release; run `npm version <semver-pre-release>`
- Trigger CI build from tag to call `./gradlew publishPackage`