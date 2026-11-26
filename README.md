# Bankfacilito

## Requirements

- Ruby 3.2.3
- Rails 8.1.4.1
- Bundler 2.7.0
- SQLite 3.8.0 or newer

Install the locked dependencies with `bundle install`. The application uses
SQLite in development and test, and production stores its database at
`/app/db/production.sqlite3`; deployments must mount that path on persistent
storage.

## Setup

```sh
bin/setup
```

Set the Rails credentials required by the deployment before starting the
application. The JWT signing secret is derived from `secret_key_base`; preserve
the existing credentials when upgrading or rolling back.

## Tests and checks

```sh
RAILS_ENV=test bin/rails db:prepare test test:system
bundle exec rspec
bin/rubocop
bin/brakeman --no-pager
bin/rails zeitwerk:check
```

System tests require Google Chrome. The test commands use the test database
only; never run destructive database tasks against production.

## Deployment and rollback

The Docker entrypoint runs `bin/rails db:prepare` before the production server
starts. Review the migrations and back up the SQLite database, including its
WAL state after writes are quiesced, before deploying. Verify the backup by
restoring it to an isolated volume and comparing schema, row counts, balances,
and transaction records.

Monitor `/up`, application errors, login, and financial invariants after
deployment. Re-deploying an older image does not reverse an applied migration:
if rollback requires a database restore, stop writes, restore a verified backup,
and reconcile or approve writes created after that backup.
