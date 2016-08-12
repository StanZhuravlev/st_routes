FactoryGirl.define do
  factory :st_routes_page, :class => 'StRoutes::Page' do
    title ""
    slug { StRoutes::URL::Slug.generate_slug(StRoutes::Page, title, "") }
    controller ""
    is_published true
  end

end
