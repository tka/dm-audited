Gem::Specification.new do |s|
  s.name             = 'dm-audited'
  s.version          = '0.0.2'
  s.platform         = Gem::Platform::RUBY
  s.has_rdoc         = true
  s.extra_rdoc_files = %w[ README LICENSE ]
  s.summary          = 'DataMapper plugin providing auditing for resources'
  s.description      = s.summary
  s.author           = 'Dirkjan Bussink'
  s.email            = 'd.bussink@gmail.com'
  s.homepage         = 'http://github.com/dbussink/dm-audited'
  s.require_path     = 'lib'
  s.files            = [ 'lib/dm-audited.rb', 'spec/spec.opts', 'spec/spec_helper.rb',
                         'spec/unit/audited_spec.rb', 'Rakefile', *s.extra_rdoc_files ]
  s.add_dependency('dm-core', ">=0.10.0")
end
