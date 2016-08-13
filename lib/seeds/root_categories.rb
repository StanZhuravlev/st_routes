# ruby encoding: utf-8

# Шаблон корневых категорий. Формат [ title, controller, in_path]:
#   - title - наименование категории
#   - controller - наименование контроллера обработчика. Для :static_pages необходимо создать StaticPagesController
#   - in_path - если true, то данная категория отображается в URL
#
# Если какие-то категории в конкретном проекте не нужны - их нужно просто закомментировать

categories = [
    [ "Новости", :news, true ],
    [ "Статьи", :articles, true ],
    [ "Отзывы", :reviews, true ],
    [ "Контент", :static_pages, false ],
    [ "Вопросы и ответы", :faq, true ],
    [ "Акции", :actions, true ],
    [ "Каталог товаров", :tovars, true ],
    [ "Бренды", :brands, true ],
    [ "Посадочные страницы", :landing_pages, true ],
]

puts
puts "Создаем категории:"
categories.each do |title, controller, in_path|
  record = StRoutes::Category.build( title: title, controller: controller, in_path: in_path, is_root: true )
  record.generate_slug
  if record.valid?
    puts "  #{title.inspect} (#{controller.to_s}): #{record.slug.inspect}"
  else
    puts "  ERROR: #{title.inspect} (#{controller.to_s})"
    record.errors.full_messages.each do |message|
      puts "         #{message}"
    end
  end
end
puts
