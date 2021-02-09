require "bundler/gem_tasks"
require "rake/testtask"

helper = Bundler::GemHelper.instance

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList["test/**/test_*.rb"]
end

task :default => :test

task "build" => "date_epoch"
task "build" => "changelogs"

task "date_epoch" do
  ENV["SOURCE_DATE_EPOCH"] = IO.popen(%W[git -C #{__dir__} log -1 --format=%ct], &:read).chomp
end

def helper.update_gemspec
  path = "#{__dir__}/#{gemspec.name}.gemspec"
  File.open(path, "r+b") do |f|
    if (d = f.read).sub!(/^(version\s*=\s*)".*"/) {$1 + gemspec.version.to_s.dump}
      f.rewind
      f.truncate(0)
      f.print(d)
    end
  end
end

def helper.commit_bump
  sh(%W[git -C #{__dir__} commit -m bump\ up\ to\ #{gemspec.version}
        #{gemspec.name}.gemspec])
end

def helper.version=(v)
  gemspec.version = v
  update_gemspec
  commit_bump
end
major, minor, teeny = helper.gemspec.version.segments

task "bump:teeny" do
  helper.version = Gem::Version.new("#{major}.#{minor}.#{teeny+1}")
end

task "bump:minor" do
  raise "can't bump up minor"
end

task "bump:major" do
  raise "can't bump up major"
end

task "bump" => "bump:teeny"

task "tag" do
  helper.__send__(:tag_version)
end

def changelog(output, ver = nil, prev = nil)
  ver &&= Gem::Version.new(ver)
  range = [[prev], [ver, "HEAD"]].map {_1 ? "v#{_1.to_s}" : _2}.compact.join("..")
  IO.popen(%W[git log --format=fuller --topo-order --no-merges #{range}]) do |log|
    line = log.gets
    FileUtils.mkpath(File.dirname(output))
    File.open(output, "wb") do |f|
      f.print "-*- coding: utf-8 -*-\n\n", line
      log.each_line do |line|
        line.sub!(/^(?!:)(?:Author|Commit)?(?:Date)?: /, '  \&')
        line.sub!(/ +$/, '')
        f.print(line)
      end
    end
  end
end

tags = IO.popen(%w[git tag -l v0.*]).grep(/v(.*)/) {$1}
tags.sort_by! {_1.scan(/\d+/).map(&:to_i)}
tags.inject(nil) do |prev, tag|
  task("logs/ChangeLog-#{tag}") {|t| changelog(t.name, tag, prev)}
  tag
end

desc "Make ChangeLog"
task "ChangeLog", [:ver, :prev] do |t, ver: nil, prev: tags.last|
  changelog(t.name, ver, prev)
end
changelogs = ["ChangeLog", *tags.map {"logs/ChangeLog-#{_1}"}]
task "changelogs" => changelogs
CLOBBER.concat(changelogs) << "logs"
