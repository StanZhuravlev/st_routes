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
      list = StRoutes::Page.sitemap
      expect(list).to include "/periodika/kak-stat-znamenitym-est-retsept"
      expect(list).not_to include "/zhurnaly/kak-stat-znamenitym-est-retsept"
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


  end
end
