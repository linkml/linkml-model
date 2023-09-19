# Release Process

- Close all issues for planned release
- Update (and commit) version in package.json to be a semver pre-release
- Tag commit with same semver pre-release version
- Trigger CI build from tag to call `./gradlew publishPackage`
- Verify pre-released packacke
  - Create a temporary node project
  - In temporary project, run `npm install <pre-release-semver-tag>`
  - Inspect that installed package is as expected
- Update (and commit) version in package.json to be a semver release
- Tag commit with same semver release version
- Trigger CI build from tag to call `./gradlew publishPackage`