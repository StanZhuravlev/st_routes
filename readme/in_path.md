# Сокрытие корневной категории из URL

[Вернуться](https://github.com/StanZhuravlev/st_routes)

Типовые CMS требуют наличия в URL указания типа обрабатываемой страницы. Примеры:

    http://site.com/news/novost-1
    http://site.com/articles/statya-o-lyagushkah
    http://site.com/content/o-nas

В последнем примере, чтобы указать системе CMS на необходимость обработки статической страницы, используется часть `/content`. Однако для SEO предпочтительным является написание `http://site.com/o-nas`.

Чтобы получить подобные короткие ссылки, достаточно установить поле `in_path` в значение `false`. Пример:

```ruby
# Создаем категорию для статических страниц
category = build(:st_routes_category, title: "Контент", controller: "content", in_path: true)
expect(category.slug).to eq "kontent"
category.save

# Создаем страницу. После создания она автоматически будет привязана к корневой категории
page = build(:st_routes_page, title: "О магазине", controller: :content)
expect(page.slug).to eq "o-magazine"
page.save

# Пример 1 - /kontent в пути
parser = StRoutes::URL::Parser.new("/kontent/o-magazine")
expect(parser.type).to eq(:page)
parser = StRoutes::URL::Parser.new("/o-magazine")
expect(parser.type).to eq(:not_found)

# Скрываем категорию из URL
category.in_path = false
category.save

# Пример 2 - /kontent исключен из пути
parser = StRoutes::URL::Parser.new("/kontent/o-magazine")
expect(parser.type).to eq(:not_found)
parser = StRoutes::URL::Parser.new("/o-magazine")
expect(parser.type).to eq(:page)
```
