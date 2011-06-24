Gem::Specification.new {|s|
    s.name         = 'rbf'
    s.version      = '0.0.6'
    s.author       = 'meh.'
    s.email        = 'meh@paranoici.org'
    s.homepage     = 'http://github.com/meh/rbf'
    s.platform     = Gem::Platform::RUBY
    s.summary      = 'A simple Brainfuck interpreter.'
    s.files        = Dir.glob('lib/**/*.rb')
    s.require_path = 'lib'
    s.executables  = ['rbf']

    s.add_dependency('parslet')
    s.add_dependency('colorb')
    s.add_dependency('memoized')
}
