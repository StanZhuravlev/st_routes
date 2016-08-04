module StRoutes
  class RecognizeRoute

    def call(env)
      @env = env
      @path = env['action_dispatch.request.path_parameters'][:path]
      set_params('', '', 0, 0, [])

      parser = StRoutes::URL::Parser.new(@path)
      set_params(parser.controller, parser.action, parser.page_id, parser.category_id, parser.breadcrumb)

      controller_class = @st_controller.camelize.constantize
      my_action = @st_action
      controller_class.action(my_action).call(@env)
    end


    private


    def set_params(controller, action, page_id, category_id, breadcrumb)
      @st_controller = controller + '_controller'
      @st_action = action
      @env['action_dispatch.request.path_parameters'][:page_id] = page_id
      @env['action_dispatch.request.path_parameters'][:category_id] = category_id
      @env['action_dispatch.request.path_parameters'][:breadcrumb] = breadcrumb
      true
    end

  end
end