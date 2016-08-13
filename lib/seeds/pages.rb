# ruby encoding: utf-8

pages = [
    [ "О нас", :static_pages ],
    [ "Сертификаты", :static_pages ],
    [ "Инстаграм", :landing_pages ],
    [ "Статья о лягушках", :articles ],
    [ "Cкидка 20%!", :actions ],
    [ "Cкидка 50%!", :actions ],
    [ "Cкидка 70%!", :actions ],
    [ "Тестовый товар", :tovars ],
]

puts
puts "Создаем страницы:"
pages.each do |title, controller|
  category = StRoutes::Category.root(controller)
  if category.nil?
    puts "Root category #{controller.inspect} not found"
    next
  end

  record = StRoutes::Page.where(title: title, controller: controller ).first_or_create
  if record.valid?
    puts "  #{title.inspect} (#{controller.to_s}): #{record.slug.inspect}"
    record.connect_to_category(category)
  else
    puts "  ERROR: #{title.inspect} (#{controller.to_s})"
    record.errors.full_messages.each do |message|
      puts "         #{message}"
    end
  end
end
puts

StRoutes::Category.roots.find_each do |one|
  one.update_pages_count
end