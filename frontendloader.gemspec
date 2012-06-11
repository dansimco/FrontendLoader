Gem::Specification.new do |s|
  s.name = "frontendloader"
  s.version = "0.0.6"
  s.authors = ["Daniel Sim","Exploding Box Productions"]
  s.date = %q{2011-10-28}
  s.description = 'Accelerated front end development'
  s.summary = %Q{A command line interface for rapid creation of web app interfaces, compiling less, js and mustache files into two requests}
  s.email = 'dan@explodingbox.com'
  s.homepage = 'https://github.com/explodingbox/FrontEndLoader'
  s.has_rdoc = true
  s.executables << "fel"
  s.add_dependency('listen')
  s.files = [
    'README.rdoc',
    'lib/FrontEndLoader.rb',
    'lib/processors/less.rb',
    'lib/processors/scss.rb',
    'resources/FrontEndLoader.yml',
  ]
end