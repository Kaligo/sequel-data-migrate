# SequelData::Migrate

Run data migrations along side schema migrations for Sequel. Inspired by
https://github.com/ilyakatz/data-migrate.

Data migrations are stored in db/data. They act like schema migrations,
except they should be reserved for data migrations.
For instance, if you realize you need to titleize all your titles, this is the place to do it.

The code is ported from Sequel migration extension.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add sequel-data-migrate

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install sequel-data-migrate

## Usage

Configure your database:

```ruby
SequelData::Migrate.configure do |config|
  config.db_configuration.host = ENV.fetch('DATABASE_URL')
  config.migration_path = 'db/data_migration' # default value is db/data
end
```

Add the rake task to `Rakelib` file in your project:

```ruby
require 'sequel_data/migrate/rake_task'
task 'data:migrate' => :environment
task 'data:rollback' => :environment
```

Now you can migrate using `rake db:migrate` and rollback using `rake
db:rollback`

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kaligo/sequel-data-migrate.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
