# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter mobile app (`podd_app`) for OHTK / One Health Toolkit — community and official incident/observation reporting that talks to a Django GraphQL backend (`ohtk-ms`). Dart SDK `>=2.18.0 <3.0.0`, Flutter 3-era dependencies.

## Common commands

```bash
# First-time setup / after pulling: fetch deps
flutter pub get

# Code generation (mobx_codegen). Required after editing any mobx-annotated store,
# though most stores in this repo use Observable(...) directly so codegen is usually a no-op.
flutter pub run build_runner build --delete-conflicting-outputs

# Static analysis / lint
flutter analyze

# Run full test suite
flutter test

# Run a single test file
flutter test test/opsv_form/form_test.dart

# Run tests matching a name
flutter test --plain-name "nested form"

# Regenerate localizations after editing lib/l10n/*.arb
flutter gen-l10n         # uses l10n.yaml

# Run against local backend (opensur.test, see README for hosts + adb reverse setup)
flutter run

# Run against a remote tenant — endpoints come from --dart-define
flutter run \
  --dart-define=GRAPHQL_ENDPOINT=https://backend.ohtk.org/graphql/ \
  --dart-define=TENANT_API_ENDPOINT=https://admin.ohtk.org/api/servers/

# Production builds (android bundle + ios ipa against ohtk.org)
./build.sh
```

`.vscode/launch.json` has pre-wired launch configs for localhost, `ohtk.org`, `poddlaos.org`, and specific device IDs — prefer those over remembering `--dart-define` flags.

## Configuration surface

All runtime endpoints are compiled in via `--dart-define`, read in `lib/services/config_service.dart`:

- `GRAPHQL_ENDPOINT` (default `https://opensur.test/graphql/`)
- `TENANT_API_ENDPOINT` (default `https://opensur.test/api/servers/`) — used to look up per-tenant GraphQL endpoints by invitation code
- `CONSENT_CONFIGURATION_KEY`, `CONSENT_ACCEPT_TEXT_KEY`
- `ENVIRONMENT` (`dev` tightens Firebase Remote Config fetch settings in `main.dart`)

The app trusts self-signed certs globally (`MyHttpOverrides` + `overrideDioSelfSignCertificateHandling`) to support the `opensur.test` dev setup — keep this in mind when reasoning about TLS.

## Architecture

### Service locator + async init chain

`lib/locator.dart` is the single source of truth for wiring. It uses `get_it` with `registerSingletonAsync` and explicit `dependsOn:` lists, which means init order is declared, not procedural. The chain is roughly:

```
ConfigService → SecureStorageService → GqlService
                                     → Api* (one GraphQL api class per domain)
                                     → Db/Image/File/ReportType/Report/Observation services
                                     → AuthService (depends on all content services so it can refresh/reset them on login/logout)
                                     → view-model singletons (AllReportsViewModel, MyReportsViewModel)
```

Progress strings are pushed onto a `StreamController<String>` that drives the splash/loading UI in `OhtkApp`. `RestartWidget.restartApp` re-runs `setupLocator` to hard-reset the app (used after logout / tenant switch) — this is why every registration checks `isRegistered` and unregisters first.

### Stacked + MobX hybrid

This project mixes two state libraries:

- **Stacked** (`stacked`, `stacked_hooks`) for screen-level `ViewModel`s under `lib/ui/**/*_view_model.dart`, paired with `ViewModelBuilder` in the matching `_view.dart`.
- **MobX** (`mobx`, `flutter_mobx`) for the dynamic form engine under `lib/opsv_form/` and a handful of reactive fields inside services. Uses `Observable(...)` / `ObservableList` directly rather than `@observable` codegen, so there are no `.g.dart` files to regenerate even though `mobx_codegen` is listed in dev_dependencies.

When adding a screen, follow the stacked pattern (`FooViewModel extends BaseViewModel` / `ReactiveViewModel`). When adding form fields, follow the mobx pattern inside `opsv_form`.

### `opsv_form` — the dynamic form engine

`lib/opsv_form/opsv_form.dart` is a single-library-with-parts (`library opensurveillance_form; part '...'`) that defines `Form → Section → Question → Field` from a JSON definition fetched from the backend (`report_type.definition`, observation definitions, etc.). Don't split these into normal imports — they intentionally share private state via `part of opensurveillance_form`.

- Field types live in `lib/opsv_form/models/fields/` (text, textarea, integer, decimal, date, images, files, location, single/multiple choice, subform).
- Corresponding Flutter widgets live in `lib/opsv_form/widgets/` and are selected by `widgets.dart`.
- `Values` is a flat name-keyed registry of field values used for condition evaluation (`lib/opsv_form/models/condition.dart`) and serialization.
- Subforms are nested `Form`s referenced via `SubformField`.
- Tests under `test/opsv_form/` drive fields through JSON templates — look there first when changing field behavior.

### Data flow: reports, observations, offline queue

Reports and observation records are **offline-first**:

1. User fills an `opsv_form` → `ReportService` / `ObservationRecordService` writes the submission + attachments to sqflite (`lib/services/db_service.dart`, DB version 11 with numbered `_onUpgrade` branches).
2. Image/File submissions are tracked separately (`IImageService`, `IFileService`) with their own upload queue.
3. A background submit loop (`report_service.dart`, `observation_record_service.dart`) pushes pending rows to GraphQL mutations and updates local state.
4. `connectivity_plus` gates retries; `AuthService` hooks into GraphQL `Signature has expired` errors to transparently refresh JWT via `GqlService` interceptors.

When changing DB schema: bump the `version:` in `DbService.init`, add a new `_onUpgrade` branch (never mutate an existing one), and add a new `_createTable...V{N}` helper — existing installs must migrate cleanly.

### GraphQL layer

`GqlService` owns a single `GraphQLClient` built on `dio + gql_dio_link + CookieManager + HiveStore`. Every domain has a thin `*Api` class under `lib/services/api/` that takes a `ResolveGraphqlClient` function (not the client directly) so the client can be rebuilt on tenant switch without re-registering all APIs. Extend this pattern when adding a new backend call.

### Routing + auth gating

`lib/router.dart` (`OhtkRouter`, singleton) builds a `GoRouter` with `refreshListenable: authService` and a redirect that forces `/login` when `AuthService.isLogin` is false. Named routes are declared as `static const` on `OhtkRouter` — use `context.goNamed(OhtkRouter.reportForm, ...)` rather than raw paths.

### Localization

ARB files in `lib/l10n/`, template `app_en.arb`, untranslated strings tracked in `untranslated.txt`. Generation is configured in `l10n.yaml` and runs automatically on `flutter pub get` / build, but `flutter gen-l10n` forces it. The user's language is persisted via `SharedPreferences` under the `languageKey` (`"language"`) constant and loaded in `setupAppLocalization` — it's used both for Material widgets and inside `opsv_form` for error messages.

## Testing notes

Tests that instantiate `opsv_form` models must register `AppLocalizations` on the locator in `setUpAll` (see `test/opsv_form/form_test.dart`) — fields pull localized error strings from `locator<AppLocalizations>()`. UI tests under `test/ui/` are thin; most coverage lives in form-engine tests.
