module StRoutes
  class Engine < ::Rails::Engine
    isolate_namespace StRoutes

    # Добавляем миграции в основное приложение по рецепту:
    #    https://blog.pivotal.io/pivotal-labs/labs/leave-your-migrations-in-your-rails-engines
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    # Подключение RSpec как инстумента тестирования:
    #     http://www.andrewhavens.com/posts/27/how-to-create-a-new-rails-engine-which-uses-rspec-and-factorygirl-for-testing/
    #     https://www.viget.com/articles/rails-engine-testing-with-rspec-capybara-and-factorygirl
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    # Загружаем файлы локализации в общий проект
    #      http://stackoverflow.com/a/31426146
    config.before_initialize do
      config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end

    # Загружаем библиотеки
    #      https://blog.pivotal.io/labs/labs/rails-autoloading-for-your-gem
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

  end
end
