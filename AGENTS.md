# AGENTS.md

This file applies to the `ohtk-mobile` repository.

For detailed setup, commands, runtime configuration, and architecture, read [CLAUDE.md](/Users/pphetra/projects/opensurveillance/ohtk-mobile/CLAUDE.md) first. It is the main repo-specific reference for:

- Flutter run/test/build commands
- `--dart-define` runtime configuration
- locator/service initialization order
- `stacked` and `mobx` usage patterns
- offline-first data flow
- `opsv_form` architecture and localization setup

This `AGENTS.md` only keeps the repo-local working rules that are easy to scan while editing.

## Repo Focus

`ohtk-mobile` is the Flutter client for OHTK reporting workflows. Changes here often affect login, tenant selection, offline queueing, uploads, or dynamic forms, so seemingly small UI changes can have state and sync consequences.

Before editing, identify:

- which screen or service owns the behavior
- whether the change touches offline storage, upload queues, or auth state
- whether the change depends on `ohtk-api` schema or backend behavior

## Change Rules

- Follow the existing `stacked` view-model pattern for screens instead of pushing logic into widgets.
- Keep backend access inside services and API classes; do not scatter GraphQL calls across UI code.
- Treat locator registration order and app restart behavior as high-risk areas.
- Treat auth refresh, tenant switching, and compiled runtime endpoints as high-risk areas and verify them explicitly.
- Preserve the `opsv_form` `library` + `part` structure; do not refactor it into normal imports casually.
- For offline-first flows, think through local DB writes, pending uploads, retry behavior, and reconnect behavior before closing the task.
- Do not hand-edit generated or runtime build output.

## Files To Avoid Editing By Hand

- `.dart_tool/`
- `build/`
- `ios/Pods/`

Generated localization output or build artifacts should come from the documented Flutter commands, not manual edits.

## Common Change Patterns

### Screen and workflow changes

- Prefer changes in the relevant view model, service, or router before adding widget-local state.
- Keep route changes aligned with [lib/router.dart](/Users/pphetra/projects/opensurveillance/ohtk-mobile/lib/router.dart) and auth gating behavior.

### Backend and sync changes

- Extend the existing service and `*Api` patterns instead of making one-off client usage.
- Assume GraphQL or auth-affecting changes may require follow-up work in `ohtk-api` and sometimes `ohtk-ms`.

### `opsv_form` changes

- For field behavior changes, check both model and widget layers:
- `lib/opsv_form/models/`
- `lib/opsv_form/widgets/`
- Add or update focused tests under [test/opsv_form](/Users/pphetra/projects/opensurveillance/ohtk-mobile/test/opsv_form) when practical.

### Local data changes

- If you change sqflite schema or stored records, add a new migration path instead of rewriting an old upgrade step.

## Verification

Use the narrowest meaningful validation for the area you changed:

- `flutter analyze`
- targeted `flutter test`
- focused device or emulator verification for login, uploads, offline queueing, routing, notifications, or tenant switching

If localization, generated code, or local DB behavior changed, verify the corresponding generation or migration path as well.

## Handoff Notes

Final notes for work in this repo should call out:

- whether the change depends on `ohtk-api`
- whether local data or migration behavior changed
- what verification was run
- any offline/auth/runtime risks that remain
