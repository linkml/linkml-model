# Release Process

- Close all issues for planned release
- Checkout and pull `main` branch in git from origin
- Run `npm version <semver-pre-release, e.g., 1.6.0-alpha1.1.0>` (Update in package.json to be a semver pre-release, then commit, tag with semver pre-release and auto run `git push && git push --tags`)
  - Triggers CI build from tag to call `./gradlew publishPackage` (Publish npm package to npmjs.com)
- Verify pre-released package
  - Create a temporary node project
  - In temporary project, run `npm install linkml-schema`
  - Inspect that installed package is as expected
- Run `npm version <semver-release, e.g., 1.6.0-v1.0.0>` (Update in package.json to be a semver release, then commit, tag with semver release and auto run `git push && git push --tags`)
  - Triggers CI build from tag to call `./gradlew publishPackage` (Publish npm package to npmjs.com)
- Create new release (on GitHub)
  - select (final release) tag
  - auto-generate release notes
  - publish final release

# Versioning

## Goals

- Maintain traceability to linkml-model release
- Enable Mach 30 to be able to produce incremental releases for the same upstream model release (e.g., v1.6.0 upstream having multiple releases, albeit due to patches or documentation)

## Schema

- actual version is from linkml and we only match to final releases (so we don't pull or release against their release candidates)
- dash
- release keyword
  - alpha (initial pre-release)
  - beta (optional intermediary pre-release)
  - rc (release candidate, final pre-release)
  - v (final release)
- semver release string for our release of the linkml release (so our first official release of 1.6.0 would be v1.6.0-v1.0.0)

### Examples

- v1.6.0-alpha1.0.0
- v1.6.0-beta1.0.0
- v1.6.0-rc1.0.0
- v1.6.0-v1.0.0