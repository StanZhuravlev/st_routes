# Описание

В данном файле описаны служебные библиотеки, необходимые для функционирования модуля StRoutes:
- `builder` - класс строит промежуточный кеш URL категорий (таблица `category_urls`)
- `parser` - класс распознает URL страницы или категории


# Builder


# Parser

## mainpage

```ruby
route = StRoutes::URL::Parser.new("/")
puts route.url                               # => /
puts route.type                              # => :mainpage
puts route.category_id                       # => 0
puts route.page_id                           # => 0
puts route.controller                        # => mainpage
puts route.action                            # => mainpage
puts route.breadcrumb                        # => []
```

## category

```ruby
# Возможные варианты написания URL
# - http://TEST.COM/CATEGORY
# - /category/
# - http://TEST.COM/CATEGORY?page=3
# - /category?page=3


route = StRoutes::URL::Parser.new("http://TEST.COM/CATEGORY/subcategory?page=3")
puts route.url                               # => /category/subcategory
puts route.type                              # => :category
puts route.category_id                       # => 34
puts route.page_id                           # => 0
puts route.controller                        # => articles
puts route.action                            # => index
puts route.breadcrumb                        # => [2, 34]
```

## page

```ruby
# Возможные варианты написания URL
# - http://TEST.COM/CATEGORY/page
# - /category/page
# - http://TEST.COM/CATEGORY/page?page=3
# - /category/page?page=3


route = StRoutes::URL::Parser.new("http://TEST.COM/CATEGORY/subcategory/page?page=3")
puts route.url                               # => /category/subcategory/page
puts route.type                              # => :page
puts route.category_id                       # => 34
puts route.page_id                           # => 535
puts route.controller                        # => articles
puts route.action                            # => show
puts route.breadcrumb                        # => [2, 34]
```

## not_found


```ruby
route = StRoutes::URL::Parser.new("bla-bla-bla")
puts route.url                               # => /bla-bla-bla
puts route.type                              # => :not_found
puts route.category_id                       # => 0
puts route.page_id                           # => 0
puts route.controller                        # => errors
puts route.action                            # => url_not_found
puts route.breadcrumb                        # => []
```


