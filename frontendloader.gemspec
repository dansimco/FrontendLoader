Gem::Specification.new do |s|
  s.name = "frontendloader"
  s.version = "0.0.1"
  s.authors = ["Daniel Sim"]
  s.date = %q{2011-10-28}
  s.description = 'Accelerated front end development'
  s.summary = %Q{A command line interface for rapid creation of web app interfaces with many small files, compiled into two requests}
  s.email = 'dan@explodingbox.com'
  s.homepage = 'https://github.com/explodingbox/FrontEndLoader'
  s.has_rdoc = true
  s.executables << "fel"
  s.files = [
    'README.rdoc',
    'lib/FrontEndLoader.rb',
    'resources/FrontEndLoader.yml',
    'resources/js/helpers/mustache.js',
    'resources/js/mootools/mootools.js',
    'resources/js/mootools/apiRequest.js',
    'resources/js/mootools/renderView.js',
    'resources/js/mootools/View.js',
    'resources/less/reset.less'
  ]
end