Refinery::Admin::BaseController.class_eval do
  alias :original_refinery_admin_root_path :refinery_admin_root_path

  def refinery_admin_root_path
    if refinery_user?
      original_refinery_admin_root_path
    else
      refinery.login_path
    end
  end
end