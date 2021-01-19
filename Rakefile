require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList["test/**/test_*.rb"]
end

task :default => :test

task "build" => "date_epoch"

task "date_epoch" do
  ENV["SOURCE_DATE_EPOCH"] = IO.popen(%W[git -C #{__dir__} log -1 --format=%ct], &:read).chomp
end
