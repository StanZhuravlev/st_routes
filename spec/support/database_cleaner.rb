require 'database_cleaner'

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |example|
    unless example.metadata[:skip_clean]
      DatabaseCleaner.strategy = :transaction
    end
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do |example|
    unless example.metadata[:skip_clean]
      DatabaseCleaner.start
    end
  end

  config.after(:each) do |example|
    unless example.metadata[:skip_clean]
      DatabaseCleaner.clean
    end
  end
end


# Заливка тестовых данных
RSpec.configure do |config|
  config.before(:suite) do
    # Корневые категории
    FactoryGirl.create :st_routes_category, title: "Статьи", controller: "articles"
    FactoryGirl.create :st_routes_category, title: "Новости", controller: "news"
    FactoryGirl.create :st_routes_category, title: "Вопросы и ответы", controller: "faq"
    FactoryGirl.create :st_routes_category, title: "Страницы", controller: "static_pages"
    FactoryGirl.create :st_routes_category, title: "Отзывы", controller: "reviews"
    FactoryGirl.create :st_routes_category, title: "Каталог страниц", controller: "landings"
    FactoryGirl.create :st_routes_category, title: "Каталог", controller: "tovars"
    FactoryGirl.create :st_routes_category, title: "Тест", controller: "test"
  end
end
