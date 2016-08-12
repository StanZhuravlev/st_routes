FactoryGirl.define do
  factory :st_routes_category, class: 'StRoutes::Category' do
      title ""
      slug { StRoutes::URL::Slug.generate_slug(StRoutes::Category, title, "") }
      controller ""
      is_root true
      in_path true
  end
end
