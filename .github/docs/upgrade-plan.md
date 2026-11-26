Rails upgrade plan
Overview
Upgrade this API-only banking application from the locked Rails 8.0.2 to Rails 8.1.4.1, the latest stable, non-prerelease Rails release verified on 2026-11-26. Preserve API contracts, authentication, existing balances and transaction records, and the current SQLite deployment model.

RailsGems reports Rails 8.1.4.1 as requiring Ruby >= 3.2.0. The implementation retains the repository's Ruby 3.2.3 runtime and Bundler 2.7.0, which satisfy the target's declared requirements.

Success criteria

The selected stable Rails release and a compatible, supported Ruby are consistently locked and used locally, in CI, and in the Docker image.
Both existing test frameworks, lint, security scanning, eager loading, and production-like boot pass, with existing failures distinguished from upgrade regressions.
Existing API responses and JWT authentication remain compatible; transfers, service payments, balance updates, and transaction rollback are verified.
A production-like copy of the SQLite database upgrades without data loss, and deployment and rollback procedures are documented and rehearsed.
Current state
Gemfile constrains Rails to ~> 8.1.4.1; Gemfile.lock locks 8.1.4.1. config/application.rb uses config.load_defaults 8.0 and API-only mode to isolate default changes.
.ruby-version, .tool-versions, and Dockerfile all specify Ruby 3.2.3; CI uses .ruby-version. The lockfile uses Bundler 2.7.0.
SQLite is used in all environments; production points at /app/db/production.sqlite3, mounted via config/deploy.yml. The Docker entrypoint automatically runs db:prepare before starting the server.
CI runs Rails/Minitest and system tests, RSpec, RuboCop, and Brakeman. The test job uses db:prepare so pending migrations are applied before either test framework runs; Makefile invokes RSpec separately.
rspec-rails is constrained to ~> 6.0. Review compatibility of it and other Rails integrations, including factory_bot_rails, sqlite3, jbuilder, bootsnap, kaminari, annotaterb, and rubocop-rails-omakase.
Banking flows use Active Record transactions, callbacks, and integer-backed enums. lib/json_web_token.rb signs tokens with secret_key_base. The development and test environments explicitly configure deprecations.
Technical approach
Follow the official Rails upgrade guide and release notes for every intervening minor/major release, not just the final target. Upgrade in supported increments when the guides require it, resolve deprecations and run checks at each step. Keep load_defaults 8.0 initially to isolate the framework upgrade from default behavior changes; review each new default and adopt it only after compatibility tests pass. Do not silently rotate credentials or rewrite historical migrations.

Implementation plan
Phase 1: Establish target and baseline
Confirm versions and support (Small). Identify the latest stable Rails version using official releases/RubyGems, its Ruby and Bundler requirements, supported upgrade path, and release-specific upgrade notes. Select a supported Ruby version compatible with the target and dependencies. Record exact versions and sources in the implementation notes. Dependency: none.

Capture a baseline (Medium). On an isolated development/test setup, record Ruby, Bundler, Rails, platform and database versions; install the existing locked dependencies if feasible. Run bin/rails db:test:prepare, bin/rails test test:system, bundle exec rspec, bin/rubocop, and bin/brakeman --no-pager. Record failures and deprecations separately. If the current environment cannot boot, document the blocker and establish the closest reproducible baseline without changing production data. Dependency: none.

Characterize critical behavior (Medium). Add focused regression tests where missing for registration/login, existing JWT acceptance and auth failures, account ownership, recipient and service endpoints, successful transfer and service payment, insufficient funds, and atomic rollback when the second transaction fails. Assert response status/JSON and exact stored balances, transaction types/statuses and record counts. Avoid testing unsupported routes or changing existing API semantics. Compare against the baseline and flag any pre-existing defects rather than silently redefining expected behavior. Dependency: baseline.

Phase 2: Upgrade runtime and framework
Align runtime (Small). Update .ruby-version, .tool-versions, and Dockerfile to the chosen Ruby; align Bundler with the target and lockfile. Verify native SQLite and other platform-specific gems resolve for supported development and deployment platforms. Dependency: target selection.

Upgrade incrementally (Large). Change the Rails constraint to each required intermediate release and then the target release; update Gemfile.lock using Bundler, minimizing unrelated gem churn. Inspect dependency conflicts and update only required direct dependencies, notably the rspec-rails constraint if its supported version requires it. Preserve lockfile platforms used by developers and the Linux image. Boot and run relevant checks at every upgrade step. Dependencies: runtime and baseline.

Resolve framework compatibility (Large). Review generated bin/rails app:update changes interactively or against a generated reference; merge only necessary changes while retaining API-only settings, routes, SQLite paths, credentials, deployment behavior and custom logging. Audit release-note changes affecting Active Record enums, callbacks, transactions, JSON/Jbuilder, deprecation settings, autoloading, and authentication. Remove or replace obsolete APIs and configurations without introducing unrelated behavior changes. Preserve historical migration versions and review any regenerated schema diff. Dependencies: incremental upgrade and characterization tests.

Review defaults deliberately (Medium). With the upgraded framework running on 8.0 defaults, compare each intervening version's new defaults with current behavior. Test security-sensitive serialization, tokens and persistence compatibility, using explicit compatibility settings where needed. Enable newer defaults incrementally only when verified; if any cannot safely be enabled, retain 8.0 defaults and document the reason and follow-up rather than silently changing behavior. Dependency: compatibility.

Phase 3: Validate and prepare deployment
Run comprehensive checks (Medium). Run the commands from the baseline plus bin/rails zeitwerk:check and appropriate release-specific checks. Ensure both RSpec and Minitest execute, including new banking regressions; add RSpec to .github/workflows/ci.yml. Investigate upgrade-introduced failures and warnings, retaining evidence of pre-existing ones. Verify lint on changed Ruby code and report any baseline lint failures separately. Dependencies: compatibility and defaults review.

Exercise production-like persistence (Large). Restore a sanitized SQLite backup into an isolated volume; verify integrity and capture schema, row counts, balances, transaction records, and a representative existing token. Build and start the actual Docker image with isolated credentials and volume; verify boot, /up, API requests, token compatibility where the original signing secret is available, and db:prepare/migration behavior. Compare data before and after, and rehearse a restore. Never run destructive database tasks against production. Dependencies: runtime, framework upgrade and compatibility.

Document and stage rollout (Medium). Update README with supported Ruby/Rails/Bundler, setup and both test commands, plus container/deployment prerequisites. Document a SQLite-consistent backup including WAL state, restore verification, migration review, and a rollout with monitoring of /up, errors, login, and financial invariants. Since the entrypoint runs migrations automatically, inspect migrations and establish rollback compatibility before deploy. Rehearse restoring the previous image and, only if necessary, a verified backup after quiescing writes; a database restore discards subsequent writes and requires reconciliation/approval. Never assume image rollback reverses a migration. Dependencies: checks and production-like persistence.

Considerations
Confirmed scope: Preserve existing API behavior and the SQLite deployment model. Enable newer framework defaults only when verified safe.
Assumption: Latest means the latest stable release, not edge Rails.
Constraints: Preserve the existing master key and signing secret; do not expose credentials, real customer data, or JWTs in logs or test artifacts. Use isolated or sanitized data and test-only tokens.
Risks: Dependency support may lag Rails; use a compatible maintained version or explicitly stop and report the blocker. Pre-existing failures in either test suite or lint must not be masked. Integer balances and decimal transaction amounts make exact regression assertions especially important; avoid modifying monetary semantics as part of this upgrade.
Deployment: Production SQLite requires its persistent mount and a consistent backup. Rollback must account for writes and possible schema or serialization incompatibilities, not merely redeploy the old image.
Not included
New features, database-engine migration, broad monetary-model redesign, unrelated security or style cleanup, and changes to API behavior.
Actual deployment or production data access without explicit authorization.
