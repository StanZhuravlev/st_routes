# desc "Explaining what the task does"
# task :st_routes do
#   # Task goes here
# end

namespace :st_routes do
  namespace :install do

    desc "Копирование шаблонов корневых категорий"
    task roots: :environment do
      src_folder = File.join(__dir__, '..', 'seeds', '*.rb')
      dst_folder = File.join(Rails.root, 'db', 'seeds')
      FileUtils.mkdir_p(dst_folder) rescue nil
      Dir.glob(src_folder).each do |file|
        FileUtils.copy_file(file, File.join(dst_folder, File.basename(file)), remove_destination: true)
        puts "Copied templates to \"db/seeds/#{File.basename(file)}\""
      end
      puts
      puts "Execute:"
      puts "   rails st_routes:install:seed"
      puts
    end


    desc "Создать корневые категории в базе данных"
    task seed: :environment do
      Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
        if File.exist?(filename)
          load(filename)
        end
      end
    end


  end
end



