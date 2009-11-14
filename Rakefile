require 'rubygems'
require 'spec'
require 'rake/clean'
require 'spec/rake/spectask'
require 'pathname'

CLEAN.include '{log,pkg}/'

task :default => [ :spec ]

begin
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name              = 'dm-audited'
    gem.summary           = 'DataMapper plugin providing auditing for resources'
    gem.description       = 'DataMapper plugin providing auditing for resources'
    gem.email             = 'd.bussink@gmail.com'
    gem.homepage          = 'http://github.com/dbussink/dm-audited'
    gem.authors           = [ 'Dirkjan Bussink' ]

    gem.add_dependency 'dm-core',       '>=0.10.1'
    gem.add_dependency 'dm-serializer', '>=0.10.1'
    gem.add_dependency 'dm-timestamps', '>=0.10.1'

    gem.add_development_dependency 'rspec'
    gem.add_development_dependency 'yard'
  end
  Jeweler::GemcutterTasks.new

rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end

desc 'Run specifications'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts << '--options' << 'spec/spec.opts' if File.exists?('spec/spec.opts')
  t.spec_files = Pathname.glob(Pathname.new(__FILE__).dirname + 'spec/**/*_spec.rb')
end
