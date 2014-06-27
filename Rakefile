# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task :test => "test:acceptance"

namespace :test do
    Rake::TestTask.new(:acceptance =>:prepare) do |t|
        t.libs << "test"
        t.pattern = "test/acceptance/**/*_test.rb"
    
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << ["Acceptance tests", "test/acceptance"]
    ::CodeStatistics::TEST_TYPES << "Acceptance tests"

    end
end
