module AfterSignInRedirect
  extend ActiveSupport::Concern

  def signed_in_root_path(resource_or_scope)
    if refinery_user?
      refinery.admin_root_path
    elsif current_refinery_user.store_admin?
      spree.admin_path
    else
      refinery.root_path
    end
  end
end