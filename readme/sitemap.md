# Генерация файла sitemap.txt

[Вернуться](https://github.com/StanZhuravlev/st_routes)

Чтобы сформировать в памяти приложения массив ссылок на страницы и категории сайта, необходимо использовать класс `StRoutes::Sitemap`.

```ruby
# Пример 1 - Генерация sitemap ссылок без указания домена
list = StRoutes::Sitemap.urls
expect(list).to include "/periodika/kak-stat-znamenitym-est-retsept"
expect(list).not_to include "/zhurnaly/kak-stat-znamenitym-est-retsept"

# Пример 2 - Генерация sitemap ссылок с указанием домена
list = StRoutes::Sitemap.urls('http://site.com/')
expect(list).to include "http://site.com/periodika/kak-stat-znamenitym-est-retsept"
expect(list).not_to include "http://site.com/zhurnaly/kak-stat-znamenitym-est-retsept"
```
