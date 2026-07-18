## Description
<!-- Please include a summary of the change and which issue is fixed. -->
<!-- Please also include relevant motivation and context. -->

Fixes # (issue)

## Type of change
<!-- Please delete options that are not relevant. -->
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Architecture Verification
<!-- Voyanta AI uses a strict Clean Architecture. Please verify the following: -->
- [ ] I have not imported `package:flutter/material.dart` inside the `domain` or `data` layers.
- [ ] I have not made direct API calls from the UI/Controllers. All calls go through Repositories.
- [ ] I have updated the Isar database schema (`flutter pub run build_runner build`) if necessary.

## Testing Checklist
- [ ] I have run `flutter analyze` and there are 0 warnings/errors.
- [ ] I have added/updated Widget and Unit tests for this change.
- [ ] I have run `flutter test` and all tests pass.
- [ ] I have updated Golden image snapshots if UI was modified (`flutter test --update-goldens test/golden_test.dart`).

## Screenshots (if UI changed)
<!-- Please add Before and After screenshots. -->
