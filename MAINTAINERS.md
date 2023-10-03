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

# Versioning

## Goals

- Maintain traceability to linkml-model release
- Enable Mach 30 to be able to produce incremental releases for the same upstream model release (e.g., v1.6.0 upstream having multiple releases, albeit due to patches or documentation)
- Unequivocal Mach 30 release for use with m30ml

## Schema

- actual version is from linkml and we only match to final releases (so we don't pull or release against their release candidates)
- dash
- optional pre-release keyword like alpha, beta, rc ending in a dot when present
- semver release string for our release of the linkml release (so our first official release of 1.6.0 would be v1.6.0-1.0.0)
- a plus sign
- the string "m30ml" to designate this is our versioning

### Examples

- v1.6.0-1.0.0+m30ml
- v1.6.0-alpha.1.0.0+m30ml
- v1.6.0-rc1.1.0.0+m30ml
