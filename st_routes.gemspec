$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "st_routes/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "st_routes"
  s.version     = StRoutes::VERSION
  s.authors     = ["Stan Zhuravlev"]
  s.email       = ["stan@v-screen.ru"]
  s.homepage    = "https://github.com/StanZhuravlev"
  s.summary     = "Управление маршрутами с ЧПУ"
  s.description = "Управление маршрутами с ЧПУ."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir["spec/**/*"] # https://www.viget.com/articles/rails-engine-testing-with-rspec-capybara-and-factorygirl

  s.add_dependency "rails", '~> 5.0', '>= 5.0.0'

  s.add_development_dependency "sqlite3", "~> 0"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'debase'
  s.add_development_dependency 'ruby-debug-ide'
  s.add_development_dependency 'database_cleaner', "~> 0"
end
