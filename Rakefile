require 'json'
require 'yaml'
require 'erb'
require 'logger'
require 'sinatra/activerecord/rake'
require 'puppet_community_data/application'

require "bundler/gem_tasks"

desc "Setup the database connection environment"
task :environment do
  ENV['RACK_ENV'] ||= 'production'
  rack_env = ENV['RACK_ENV']

  # Make sure heroku logging works
  STDOUT.sync = true
  STDERR.sync = true
  logger = Logger.new(STDOUT)

  # Configure the ActiveRecord library to use heroku compatible STDERR logging.
  ActiveRecord::Base.logger = logger.clone

  # Heroku overwrites our database.yml file with an ERB tempalte which
  # populates the database connection information automatically.  We need to
  # make sure to parse the file as ERB and not YAML directly.
  dbconfig = YAML.load(ERB.new(File.read('config/database.yml')).result)
  logger.debug("config/database.yml is #{JSON.generate(dbconfig)}")

  # establish_connection is what actually connects to the database server.
  ActiveRecord::Base.establish_connection(dbconfig[rack_env])
end

namespace :db do
  # This will use the migration as implemented in ActiveRecordTasks
  task :migrate => :environment
  task :rollback => :environment
end

namespace :job do
  desc "Import pull requests into the DB if it's Sunday"
  task :import_if_sunday => :environment do |t|

    logger = Logger.new(STDOUT)

    if not Date.today.sunday?
      logger.debug("Data not imported since today is not Sunday")
      Kernel.exit(true)
    end

    repo_names = ['puppetlabs/puppet-strings','puppetlabs/puppetlabs-stdlib','puppetlabs/puppetlabs-concat','puppetlabs/puppetlabs-apt']

    app = PuppetCommunityData::Application.new
    app.setup_environment
    app.generate_repositories(repo_names)
    app.write_pull_requests_to_database
  end


  desc "Import pull requests into the DB"
  task :import => :environment do |t|

    repo_names = ['puppetlabs/puppet-strings','puppetlabs/puppetlabs-stdlib','puppetlabs/puppetlabs-concat','puppetlabs/puppetlabs-apt']

    app = PuppetCommunityData::Application.new
    app.setup_environment
    app.generate_repositories(repo_names)
    app.write_pull_requests_to_database
  end

  desc "Import pull requests for a single specified repo into the DB"
  task :import_single_repo, [:repo_name] => :environment do |t, args|

    app = PuppetCommunityData::Application.new
    app.setup_environment
    app.generate_repositories([args[:repo_name]])
    app.write_pull_requests_to_database
  end

  desc "Import pull requests for a single specified repo into the DB if it's Sunday"
  task :import_single_repo_if_sunday, [:repo_name] => :environment do |t, args|

    logger = Logger.new(STDOUT)

    if not Date.today.sunday?
      logger.debug("Data not imported since today is not Sunday")
      Kernel.exit(true)
    end

    app = PuppetCommunityData::Application.new
    app.setup_environment
    app.generate_repositories([args[:repo_name]])
    app.write_pull_requests_to_database
  end
end
