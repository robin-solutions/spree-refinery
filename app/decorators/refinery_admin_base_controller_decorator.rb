Refinery::Admin::BaseController.class_eval do
  alias :original_refinery_admin_root_path :refinery_admin_root_path

  def refinery_admin_root_path
    if refinery_user?
      original_refinery_admin_root_path
    else
      if main_app.respond_to?(:root_path)
        main_app.root_path
      else
        refinery.root_path
      end
    end
  end
end