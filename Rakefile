require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList["test/**/test_*.rb"]
end

task :default => :test

task "bump:minor" do
  raise "can't bump up minor"
end

task "bump:major" do
  raise "can't bump up major"
end
