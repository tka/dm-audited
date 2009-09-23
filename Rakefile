require 'rubygems'
require 'spec'
require 'rake/clean'
require 'rake/gempackagetask'
require 'spec/rake/spectask'
require 'pathname'
 
CLEAN.include '{log,pkg}/'

spec = Gem::Specification.load('dm-audited.gemspec')

task :default => [ :spec ]
 
WIN32 = (RUBY_PLATFORM =~ /win32|mingw|cygwin/) rescue nil
SUDO  = WIN32 ? '' : ('sudo' unless ENV['SUDOLESS'])
 
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
 
desc "Install #{spec.name} #{spec.version}"
task :install => [ :package ] do
  sh "#{SUDO} gem install pkg/#{spec.name}-#{spec.version} --no-update-sources", :verbose => false
end
 
desc 'Run specifications'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts << '--options' << 'spec/spec.opts' if File.exists?('spec/spec.opts')
  t.spec_files = Pathname.glob(Pathname.new(__FILE__).dirname + 'spec/**/*_spec.rb')
end
