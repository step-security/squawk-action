[![StepSecurity Maintained Action](https://raw.githubusercontent.com/step-security/maintained-actions-assets/main/assets/maintained-action-banner.png)](https://docs.stepsecurity.io/actions/stepsecurity-maintained-actions)

# squawk-action ![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/step-security/squawk-action?display_name=tag&sort=semver)

A GitHub Action for [Squawk](https://github.com/sbdchd/squawk) — lint PostgreSQL migrations and report violations as pull request comments.

For more information on Squawk, see the [Squawk GitHub repository](https://github.com/sbdchd/squawk) or [squawkhq.com](https://squawkhq.com).

## Usage

Lint only the SQL files modified by the pull request. Use `pattern` instead of `files` to lint every matching file regardless of whether it was modified.

```yaml
name: Lint Migrations

on: pull_request

permissions:
  contents: read
  pull-requests: write

jobs:
  lint_migrations:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Find modified migrations
        id: modified-migrations
        run: |
          modified=$(git diff --diff-filter=d --name-only origin/$GITHUB_BASE_REF...origin/$GITHUB_HEAD_REF 'migrations/*.sql' | tr '\n' ' ')
          echo "file_names=$modified" >> $GITHUB_OUTPUT

      - name: Lint SQL migrations
        uses: step-security/squawk-action@v2
        with:
          files: ${{ steps.modified-migrations.outputs.file_names }}
          version: 'latest'
```

## Inputs

| Input | Required | Default | Description |
|---|---|---|---|
| `version` | Yes | `latest` | Version of squawk-cli to install from npm |
| `pattern` | No | — | Glob pattern to match SQL migration files (e.g. `migrations/*.sql`) |
| `files` | No | — | Space-separated list of SQL file paths to lint (no glob patterns; use `pattern` instead) |
| `pg-version` | No | — | Target PostgreSQL version for compatibility checks (e.g. `14.0`) |
| `assume-in-transaction` | No | `false` | Assume all statements run within a transaction |
| `config` | No | — | Path to a custom Squawk configuration file |
| `exclude` | No | — | Comma-separated list of Squawk rule names to exclude |
| `verbose` | No | `true` | Enable verbose output from Squawk |
| `upload-to-github` | No | `true` | Post lint results as a pull request comment |
| `fail-on-violations` | No | `false` | Exit with a non-zero code when violations are found |
| `access_token` | No | `github.token` | GitHub token used to post pull request comments |
