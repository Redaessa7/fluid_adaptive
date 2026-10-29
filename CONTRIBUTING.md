# Contributing

Thanks for helping! The goal of this package is to stay small, predictable and safe to depend on.

## Setup

```bash
flutter pub get
flutter analyze
flutter test
```

## Ground rules

- **Semantic versioning.** No breaking changes in `2.x`. Add new optional parameters or new APIs instead;
  deprecate with `@Deprecated` and remove only in `3.0.0`.
- **Every behaviour change needs a test**, ideally a widget test that sets `tester.view.physicalSize`.
- **Public API needs dartdoc** (the `public_member_api_docs` lint enforces it). Keep claims in docs and README verifiable. No performance numbers without a measurement.
- **Never throw in release mode** because of odd input (zero, negative, NaN, infinite sizes). Use `assert` for
  developer mistakes plus a safe fallback for release builds.
- **Minimum SDK:** code must keep working on Flutter 3.16 / Dart 3.2 (CI checks this).

## Releasing (maintainers)

1. Update `version` in `pubspec.yaml` and add a `CHANGELOG.md` entry.
2. `flutter pub publish --dry-run`
3. Tag `vX.Y.Z` and push the tag (see `.github/workflows/publish.yml`).
