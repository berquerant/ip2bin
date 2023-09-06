require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :gen do
  task :typeprof do
    sh %[bundle exec typeprof lib/**/*.rb > sig/ip2bin.rbs]
  end
end

namespace :check do
  task :steep do
    sh %[bundle exec steep check]
  end

  task :rbs do
    sh %[bundle exec rbs -I sig/ validate --silent]
  end

  task :rufo do
    sh %[bundle exec rufo --check lib spec]
  end
end

namespace :fmt do
  task :rufo do
    sh %[bundle exec rufo lib spec]
  end
end
