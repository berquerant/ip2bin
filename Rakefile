require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :generate do
  sh %[bundle exec typeprof lib/**/*.rb > lib/ip2bin.rbs]
end
