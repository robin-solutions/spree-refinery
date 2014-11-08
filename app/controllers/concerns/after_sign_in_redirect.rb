module AfterSignInRedirect
  extend ActiveSupport::Concern

  def signed_in_root_path(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    if refinery_user?
      refinery.admin_root_path
    elsif scope.store_admin?
      spree.admin_path
    else
      refinery.root_path
    end
  end
end