require 'rails_helper'

module StRoutes
  RSpec.describe Page, type: :model do

    it "Добавление тестовых страниц", skip_clean: true do
      page = build(:st_routes_page, title: "Статья о лягушках", controller: :articles)
      expect(page).to be_valid
      page.save
      expect(page.slug).to eq "statya-o-lyagushkah"
      page.connect_to_category(StRoutes::Category.where(slug: "yunnyyi-tehnik").first)

      page = build(:st_routes_page, title: "Как стать знаменитым? Есть рецепт!", controller: :articles)
      expect(page).to be_valid
      page.save
      expect(page.slug).to eq "kak-stat-znamenitym-est-retsept"
      page.connect_to_category(StRoutes::Category.where(slug: "yunnyyi-tehnik").first)
      page.connect_to_category(StRoutes::Category.where(slug: "periodika").first)
    end

    it "Формирование sitemaps.txt", skip_clean: true do
      list = StRoutes::Sitemap.urls
      expect(list).to include "/periodika/kak-stat-znamenitym-est-retsept"
      expect(list).not_to include "/zhurnaly/kak-stat-znamenitym-est-retsept"

      list = StRoutes::Sitemap.urls('http://site.com/')
      expect(list).to include "http://site.com/periodika/kak-stat-znamenitym-est-retsept"
      expect(list).not_to include "http://site.com/zhurnaly/kak-stat-znamenitym-est-retsept"
    end

    it "Попытка вставить статью с имеющимся именем", skip_clean: true do
      page = build(:st_routes_page, title: "Статья о лягушках", controller: :articles)
      expect(page).to be_valid
      expect(page.slug).to include "statya-o-lyagushkah-1"
    end

    it "Запрет создания дубля slug", skip_clean: true do
      page = build(:st_routes_page, title: "Статья о лягушках", slug: "statya-o-lyagushkah", controller: :articles)
      expect(page).not_to be_valid
      expect(page.errors.full_messages.first).to include("URL")
    end

    it "Проверка корректности пути для in_path=true", skip_clean: true do
      item = StRoutes::Category.root(:articles)
      expect(item).not_to be_nil
      item.in_path = true
      expect(item).to be_valid
      item.save

      urls_correct = [
          "/stati/periodika/yunnyyi-tehnik/kak-stat-znamenitym-est-retsept",
          "/stati/periodika/yunnyyi-tehnik/kak-stat-znamenitym-est-retsept/",
          "/stati/periodika/kak-stat-znamenitym-est-retsept",
          "/stati/periodika/kak-stat-znamenitym-est-retsept/",
          "/stati/zhurnaly/yunnyyi-tehnik/kak-stat-znamenitym-est-retsept",
          "/stati/zhurnaly/yunnyyi-tehnik/kak-stat-znamenitym-est-retsept/",
          "/stati/zhurnaly/yunnyyi-tehnik/",
          "/stati/zhurnaly/yunnyyi-tehnik",
          "/stati/periodika/",
          "/stati",
          "/",
          "/stati?page=3",
          "HTTPS://TEST.com//stati?page=3",
          "HTTPS://TEST.com/stati"
      ]

      urls_correct.each do |url|
        parser = StRoutes::URL::Parser.new(url)
        expect(parser.type).not_to eq(:not_found), "1. Ожидалось, что путь #{url.inspect} существует при in_path=true"
      end

      urls_incorrect = [
          "/periodika/yunnyyi-tehnik/kak-stat-znamenitym-est-retsept",
          "/stati/zhurnaly/yunnyyi-tehnik/kak-stat-znamenitym-est-retsept-bla-bla",
          "/stati/zhurnaly/kak-stat-znamenitym-est-retsept"
      ]
      urls_incorrect.each do |url|
        parser = StRoutes::URL::Parser.new(url)
        expect(parser.type).to eq(:not_found), "2. Ожидалось, что путь #{url.inspect} НЕ-существует при in_path=true"
      end

    end

    it "Тест для примера https://github.com/StanZhuravlev/st_routes/wiki/Сокрытие-корневой-категории" do
      # Создаем категорию для статических страниц
      category = build(:st_routes_category, title: "Контент", controller: "content", in_path: true)
      expect(category).to be_valid
      expect(category.slug).to eq "kontent"
      category.save

      # Создаем страницу. После создания она автоматически будет привязана к корневой категории
      page = build(:st_routes_page, title: "О магазине", controller: :content)
      expect(page).to be_valid
      expect(page.slug).to eq "o-magazine"
      page.save

      # Тест 1 - /kontent в пути
      parser = StRoutes::URL::Parser.new("/kontent/o-magazine")
      expect(parser.type).to eq(:page)
      parser = StRoutes::URL::Parser.new("/o-magazine")
      expect(parser.type).to eq(:not_found)

      # Скрываем категорию из URL
      category.in_path = false
      category.save

      # Тест 1 - /kontent НЕ в пути
      parser = StRoutes::URL::Parser.new("/kontent/o-magazine")
      expect(parser.type).to eq(:not_found)
      parser = StRoutes::URL::Parser.new("/o-magazine")
      expect(parser.type).to eq(:page)
    end

    it "Тест canonical" do
      # Создаем категорию для статических страниц
      category = build(:st_routes_category, title: "Контент", controller: "content", in_path: true)
      expect(category).to be_valid
      expect(category.slug).to eq "kontent"
      category.save

      page = build(:st_routes_page, title: "О магазине", controller: :content)
      expect(page).to be_valid
      expect(page.slug).to eq "o-magazine"
      page.save

      parser = StRoutes::URL::Parser.new("/kontent/o-magazine")
      expect(parser.type).to eq(:page)
      page = StRoutes::Page.where(id: parser.page_id).first

      url = StRoutes::Canonical.url_for(category, page, host: "http://site.com")
      expect(url).to eq("http://site.com/kontent/o-magazine")

      category.in_path = false
      category.save

      url = StRoutes::Canonical.url_for(category, page, host: "http://site.com")
      expect(url).to eq("http://site.com/o-magazine")

      category.in_path = true
      category.save

      url = StRoutes::Canonical.url_for(category, nil, host: "http://site.com")
      expect(url).to eq("http://site.com/kontent")
    end

  end
end
