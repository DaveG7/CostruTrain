# Releasing CostruTrain

Android binds app updates to the signing key. Once a signed APK is public, every
future update **must** use the same key — swapping it forces users to uninstall
first, which on this offline-first app destroys all their workouts and history.
Treat the keystore as unrecoverable-if-lost.

## 1. Keystore

Generated once, outside the repo:

```bash
keytool -genkeypair -v \
  -keystore ~/costrutrain-release.jks -storetype PKCS12 \
  -keyalg RSA -keysize 2048 -validity 10000 -alias costrutrain
```

Run this in a real terminal — `keytool` prompts need a TTY. Passwords must be at
least six characters.

**Back the `.jks` file and its passwords up to a second location.** A single copy
on one machine is one disk failure away from never being able to ship an update.

## 2. Local release builds

```bash
cp android/key.properties.example android/key.properties
# fill in keyAlias, keyPassword, storeFile (absolute path), storePassword
flutter build apk --release --split-per-abi
```

`android/key.properties` and `*.jks` are gitignored. While `key.properties` is
absent, `android/app/build.gradle.kts` deliberately falls back to the **debug**
key — fine for local testing, never for anything published.

## 3. CI secrets

`.github/workflows/release.yml` builds the published APKs and needs four
repository secrets (*Settings → Secrets and variables → Actions*):

| Secret | Value |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | the `.jks` file, base64-encoded, single line |
| `ANDROID_KEY_ALIAS` | e.g. `costrutrain` |
| `ANDROID_KEY_PASSWORD` | key password |
| `ANDROID_STORE_PASSWORD` | keystore password |

Encode the keystore with:

```bash
base64 -w0 ~/costrutrain-release.jks | xclip -selection clipboard
# or: base64 -w0 ~/costrutrain-release.jks > /tmp/keystore.b64
```

`-w0` matters — line-wrapped output decodes to a corrupt keystore.

The workflow fails fast if any secret is missing, and verifies with `apksigner`
that no built APK carries the `CN=Android Debug` certificate, so a
misconfiguration cannot silently publish a debug-signed release.

## 4. Tagging

Version format is `MAJOR.MINOR.PATCH[-channel.N]+BUILD` (see `CLAUDE.md`). Bump
`version:` in `pubspec.yaml` first, then:

```bash
git tag v1.1.0 -m "CostruTrain 1.1.0 — <one-liner changelog>"
git push origin --tags
```

Pushing a `v*` tag triggers `release.yml`, which builds per-ABI APKs and creates a
**public** GitHub Release with generated notes. Do not tag until the four secrets
above are set.

Note: pushing a commit that touches `.github/workflows/*` over HTTPS requires a
personal access token with both the `repo` **and** `workflow` scopes. Without
`workflow`, GitHub rejects the push with a misleading
*"Invalid username or token"* message.
