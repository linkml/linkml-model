# Release Process

- Close all issues for planned release
- Checkout `main` branch in git
- Run `npm version <semver-pre-release, e.g., 1.6.0-rc1.1.1.0>` (Update, tag, and commit version in package.json to be a semver pre-release)
- Run `git push origin main --tags`
  - Triggers CI build from tag to call `./gradlew publishPackage` (Publish npm package to cloudsmith)
- Verify pre-released package
  - Create a temporary node project
  - In temporary project, run `npm install <pre-release-semver-tag>`
  - Inspect that installed package is as expected
- Run `npm version <semver-release, e.g., 1.6.0-1.0.0>` (Update, tag, and commit version in package.json to be a semver release)
- Run `git push origin main --tags`
  - Triggers CI build from tag to call `./gradlew publishPackage` (Publish npm package to cloudsmith)

# Versioning

## Goals

- Maintain traceability to linkml-model release
- Enable Mach 30 to be able to produce incremental releases for the same upstream model release (e.g., v1.6.0 upstream having multiple releases, albeit due to patches or documentation)

## Schema

- actual version is from linkml and we only match to final releases (so we don't pull or release against their release candidates)
- dash
- optional pre-release keyword like alpha, beta, rc ending in a dot when present
- semver release string for our release of the linkml release (so our first official release of 1.6.0 would be v1.6.0-1.0.0)

### Examples

- v1.6.0-1.0.0
- v1.6.0-alpha.1.0.0
- v1.6.0-rc1.1.0.0
