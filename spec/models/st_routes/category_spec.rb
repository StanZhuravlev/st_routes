require 'rails_helper'

module StRoutes
  RSpec.describe Category, type: :model do

    it "Проверка создания корневых путей", skip_clean: true do
      %w(Статьи Новости Вопросы\ и\ ответы Страницы Отзывы Каталог\ страниц Каталог).each do |title|
        expect(Category.where(title: title).first).not_to be_nil
      end

      %w(articles news static_pages reviews landings tovars).each do |controller|
        expect(Category.where(controller: controller).first).not_to be_nil
      end
    end

    it "Проверка автогенерации slug", skip_clean: true do
      item = build(:st_routes_category, title: "Тест", controller: "test1")
      expect(item).to be_valid
      item.save
      expect(item.slug).to eq "test-1"

      item = build(:st_routes_category, title: "Тест", controller: "test", is_root: false)
      expect(item).to be_valid
      item.save
      expect(item.slug).to eq("test-2")
    end

    it "Запрет создания дубля slug", skip_clean: true do
      item = build(:st_routes_category, title: "Тест", controller: "test2", slug: "test")
      expect(item).not_to be_valid
      expect(item.slug).to eq "test"
      expect(item.errors.full_messages.first).to include("URL")
    end

    it "Запрет создания длинных заголовков", skip_clean: true do
      item = build(:st_routes_category, title: "Тест длинного заголовка" * 100, controller: "long_title")
      expect(item).not_to be_valid
      expect(item.errors.full_messages.first).to include("1024")
    end

    it "Запрет создания еще одной корневой директории", skip_clean: true do
      item = build(:st_routes_category, title: "Тест", controller: "test")
      expect(item).not_to be_valid
      expect(item.errors.full_messages.first).to include("test")
    end

    it "Запрет скрытия из пути не корневой категории", skip_clean: true do
      item = build(:st_routes_category, title: "Тест", controller: "test", is_root: false, in_path: false)
      expect(item).not_to be_valid
    end

    it "Проверка создания вложенных категорий", skip_clean: true do
      # Загружаем корневую категорию
      item = StRoutes::Category.root(:articles)
      expect(item).not_to be_nil

      # Создаем категории 2-го уровня
      zh = build(:st_routes_category, title: "Журналы", controller: "articles", is_root: false)
      expect(zh).to be_valid
      zh.save
      item.add_subcategory(zh)

      per = build(:st_routes_category, title: "Периодика", controller: "articles", is_root: false)
      expect(per).to be_valid
      per.save
      item.add_subcategory(per)

      # Создаем категорию 3-го уровня
      ut = build(:st_routes_category, title: "Юнный техник", controller: "articles", is_root: false)
      expect(ut).to be_valid
      ut.save
      zh.add_subcategory(ut)
      per.add_subcategory(ut)
    end

    it "Проверка распознования корректных URL категорий, in_path=true", skip_clean: true do
      item = StRoutes::Category.root(:articles)
      expect(item).not_to be_nil
      item.in_path = true
      expect(item).to be_valid
      item.save

      paths = [
          "/stati/zhurnaly",
          "/stati/periodika",
          "/stati/zhurnaly/yunnyyi-tehnik",
          "/stati/periodika/yunnyyi-tehnik",
          "/novosti",
          "/katalog"
      ]
      paths.each do |p|
        path = StRoutes::URL::Parser.new(p)
        expect(path.type).to eq(:category), "1. Ожидалось, что путь #{p.inspect} существует при in_path=true"
      end
    end

    it "Проверка распознования НЕ-корректных URL категорий, in_path=true", skip_clean: true do
      item = StRoutes::Category.root(:articles)
      expect(item).not_to be_nil
      item.in_path = true
      expect(item).to be_valid
      item.save

      paths = [
          "/zhurnaly",
          "/stati/zhurnaly/not_found",
          "/stati/peXXXXXriodika/yunnyyi-tehnik"
      ]
      paths.each do |p|
        path = StRoutes::CategoryUrl.route_by_url(p)
        expect(path).to be_nil, "2. Ожидалось, что путь #{p.inspect} НЕ существует при in_path=true"
      end
    end

    it "Проверка распознования корректных URL категорий, in_path=false" do
      item = StRoutes::Category.root(:articles)
      expect(item).not_to be_nil
      item.in_path = false
      expect(item).to be_valid
      item.save

      paths = [
          "/periodika",
          "/periodika/yunnyyi-tehnik"
      ]
      paths.each do |p|
        path = StRoutes::CategoryUrl.route_by_url(p)
        expect(path).not_to be_nil, "3. Ожидалось, что путь #{p.inspect} существует при in_path=false"
      end
    end


    it "Проверка распознования НЕ-корректных URL категорий, in_path=true", skip_clean: true do
      item = StRoutes::Category.root(:articles)
      expect(item).not_to be_nil
      item.in_path = false
      expect(item).to be_valid
      item.save

      # Выключаем корневую категорию из показа в пути

      paths = [
          "/stati/periodika/yunnyyi-tehnik",
          "/periodika/not_found",
          "/periodXXXXika/yunnyyi-tehnik",
          "/stati"
      ]

      paths.each do |p|
        path = StRoutes::CategoryUrl.route_by_url(p)
        expect(path).to be_nil, "4. Ожидалось, что путь #{p.inspect} НЕ существует при in_path=false"
      end
    end

    it "Проверка корректности eager_load", skip_clean: true do
      sql = StRoutes::CategoryUrl.eager_load(:category).where(controller: 'articles', is_root: true).to_sql
      expect(sql).to include "= \"st_routes_category_urls\".\"category_id"
    end

    it "Проверка создания связей между категориями через category_links" do
      item = StRoutes::Category.where(slug: 'yunnyyi-tehnik').first
      expect(item).not_to be_nil
      childs = item.parent_categories.pluck(:slug)
      expect(childs).to include "zhurnaly"
      expect(childs).to include "periodika"
    end

  end
end
