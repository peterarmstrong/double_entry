# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added contributor credits to README.

- Added support for Ruby 2.3, 2.4 and 2.5.

- Added support for Rails 5.0, 5.1 and 5.2

- Support passing an array of metadata values.

    ```ruby
    DoubleEntry.transfer(
      Money.new(20_00),
      :from     => one_account,
      :to       => another_account,
      :code     => :a_business_code_for_this_type_of_transfer,
      :metadata => { :key1 => ['value 1', 'value 2'], :key2 => 'value 3' },
    )
    ```

- Add index on the `double_entry_line_checks` table. This covers the query to
  obtain the last line check.

  Add this index to your database via a migration like:

    ```ruby
    def up
      add_index "double_entry_line_checks", ["created_at", "last_line_id"], :name => "line_checks_created_at_last_line_id_idx"
    end
    ```

### Changed

- Replaced Machinist with Factory Bot in test suite.

- Implement `DoubleEntry::Transfer::Set` and `DoubleEntry::Account::Set` with
  `Hash`es rather than `Array`s for performance.

### Removed

- Reporting API has now been moved to a separate gem
  [`double_entry-reporting`](https://github.com/envato/double_entry-reporting).

- Removed support for Ruby 1.9, 2.0, 2.1 and 2.2.

- Removed support for Rails 3.2, 4.0, and 4.1.

- Removed unneeded development dependencies from Gemspec.

- Removed spec and script files from gem package.

### Fixed

- Fixed more Ruby warnings.

- Use `double_entry` namespace when publishing to
  `ActiveSupport::Notifications`.

- Fixed problem of Rails version number not being set in migration template for apps using Rails 5 or higher.

## [1.0.1] - 2018-01-06

### Removed

- Removed Rubocop checks and build step.

### Fixed

- Use `Money#positive?` and `Money#negative?` rather than comparing to zero.
  Resolves issues when dealing with multiple currencies.

- Fixed typo in jack_hammer documentation.

## [1.0.0] - 2015-08-04

### Added

- Record meta-data against transfers.

    ```ruby
    DoubleEntry.transfer(
      Money.new(20_00),
      :from     => one_account,
      :to       => another_account,
      :code     => :a_business_code_for_this_type_of_transfer,
      :metadata => { :key1 => 'value 1', :key2 => 'value 2' },
    )
    ```

  This feature requires a new DB table. Please add a migration similar to:

    ```ruby
    class CreateDoubleEntryLineMetadata < ActiveRecord::Migration
      def self.up
        create_table "#{DoubleEntry.table_name_prefix}line_metadata", :force => true do |t|
          t.integer    "line_id",               :null => false
          t.string     "key",     :limit => 48, :null => false
          t.string     "value",   :limit => 64, :null => false
          t.timestamps                          :null => false
        end

        add_index "#{DoubleEntry.table_name_prefix}line_metadata",
                  ["line_id", "key", "value"],
                  :name => "lines_meta_line_id_key_value_idx"
      end

      def self.down
        drop_table "#{DoubleEntry.table_name_prefix}line_metadata"
      end
    end
    ```

### Changed

- Raise `DoubleEntry::Locking::LockWaitTimeout` for lock wait timeouts.

### Fixed

- Ensure that a range is specified when performing an aggregate function over
  lines.

## [0.10.3] - 2015-07-15

### Added

- Check code format with Rubocop as part of the CI build.

### Fixed

- More Rubocop code formatting issues fixed.

## [0.10.2] - 2015-07-10

### Fixed

- `DoubleEntry::Reporting::AggregateArray` correctly retreives previously
  calculated aggregates.

## [0.10.1] - 2015-07-06

### Added

- Run CI build against Ruby 2.2.0.

- Added Rubocop and resolved code formatting issues.

### Changed

- Reduced permutations of DB, Ruby and Rails in CI build.

- Build status badge displayed in README reports on just the master branch.

- Update RSpec configuration with latest recommended options.

### Fixed

- Addressed Ruby warnings.

- Fixed circular arg reference.

## [0.10.0] - 2015-01-09

### Added

- Define accounts that can be negative only.

    ```ruby
    DoubleEntry.configure do |config|
      config.define_accounts do |accounts|
        accounts.define(
          :identifier     => :my_account_that_never_goes_positive,
          :negative_only  => true
        )
      end
    end
    ```

- Run CI build against Rails 4.2

## [0.9.0] - 2014-12-08

### Changed

- `DoubleEntry::Reporting::Agregate#formated_amount` no longer accepts
  `currency` argument.

## [0.8.0] - 2014-11-19

### Added

- Log when we encounter deadlocks causing restart/retry.

## [0.7.2] - 2014-11-18

### Removed

- Removed `DoubleEntry::currency` method.

## [0.7.1] - 2014-11-17

### Fixed

- `DoubleEntry::balance` and `DoubleEntry::account` now raise
  `DoubleEntry::AccountScopeMismatchError` if the scope provided is not of
  the same type in the account definition.

- Speed up CI build.

## [0.7.0] - 2014-11-12

### Added

- Added support for currency. :money_with_wings:

### Changed

- Require at least version 6.0 of Money gem.

## [0.6.1] - 2014-10-10

### Changed

- Removed use of Active Record callbacks in `DoubleEntry::Line`.

- Changed `DoubleEntry::Reporting::WeekRange` calculation to use
`Date#cweek`.

## [0.6.0] - 2014-08-23

### Fixed

- Fixed defect preventing locking a scoped and a non scoped account.

## [0.5.0] - 2014-08-01

### Added

- Added a convenience method for defining active record scope identifiers.

    ```ruby
    DoubleEntry.configure do |config|
      config.define_accounts do |accounts|
        user_scope = accounts.active_record_scope_identifier(User)
        accounts.define(:identifier => :checking, :scope_identifier => user_scope)
      end
    end
    ```

- Added support for SQLite.

### Removed

- Removed errors: `DoubleEntry::RequiredMetaMissing` and
`DoubleEntry::UserAccountNotLocked`.

### Fixed

- Fixed `Reporting::reconciled?` support for account scopes.

## [0.4.0] - 2014-07-17

### Added

- Added Yardoc documention to the `DoubleEntry::balance` method.

### Changed

- Changed `Line#debit?` to `Line#increase?` and `Line#credit?` to
  `Line#decrease?`.

### Removed

- Removed the `DoubleEntry::Line#meta` attribute.

## [0.3.1] - 2014-07-11

### Fixed

- Obtain a year range array without prioviding a start date.

## [0.3.0] - 2014-07-11

### Added

- Add Yardoc to `Reporting` module.
- Allow reporting month and year time ranges without a start date.

### Changed

- Use ruby18 hash syntax for configuration example in README.

### Removed

- Removed `DoubleEntry::describe` and `DoubleEntry::Line#description`
  methods.

## [0.2.0] - 2014-06-28

### Added

- Added a configuration class to define valid accounts and transfers.

    ```ruby
    DoubleEntry.configure do |config|
      config.define_accounts do |accounts|
        accounts.define(identifier: :savings,  positive_only: true)
        accounts.define(identifier: :checking)
      end

      config.define_transfers do |transfers|
        transfers.define(from: :checking, to: :savings,  code: :deposit)
        transfers.define(from: :savings,  to: :checking, code: :withdraw)
      end
    end
    ```

### Changed

- Move reporting classes into the `DoubleEntry::Reporting` namespace. Mark
  this module as `@api private`: internal use only.

## 0.1.0 - 2014-06-20

### Added

- Library released as Open Source!

[Unreleased]: https://github.com/envato/double_entry/compare/v1.0.1...HEAD
[1.0.1]: https://github.com/envato/double_entry/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/envato/double_entry/compare/v0.10.3...v1.0.0
[0.10.3]: https://github.com/envato/double_entry/compare/v0.10.2...v0.10.3
[0.10.2]: https://github.com/envato/double_entry/compare/v0.10.1...v0.10.2
[0.10.1]: https://github.com/envato/double_entry/compare/v0.10.0...v0.10.1
[0.10.0]: https://github.com/envato/double_entry/compare/v0.9.0...v0.10.0
[0.9.0]: https://github.com/envato/double_entry/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/envato/double_entry/compare/v0.7.2...v0.8.0
[0.7.2]: https://github.com/envato/double_entry/compare/v0.7.1...v0.7.2
[0.7.1]: https://github.com/envato/double_entry/compare/v0.7.0...v0.7.1
[0.7.0]: https://github.com/envato/double_entry/compare/v0.6.1...v0.7.0
[0.6.1]: https://github.com/envato/double_entry/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/envato/double_entry/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/envato/double_entry/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/envato/double_entry/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/envato/double_entry/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/envato/double_entry/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/envato/double_entry/compare/v0.1.0...v0.2.0
