Refinery::Admin::UsersController.class_eval do
  before_action :find_available_spree_roles, only: [:new, :create, :edit, :update]

  def new
    @user = Refinery::User.new
    @selected_plugin_names = []
    @selected_spree_role_names = []
  end

  def create
    @user = Refinery::User.new user_params.except(:roles, :spree_roles)
    @selected_plugin_names = params[:user][:plugins] || []
    @selected_role_names = params[:user][:roles] || []
    @selected_spree_role_names = params[:user][:spree_roles] || []

    if @user.save
      create_successful
    else
      create_failed
    end
  end

  def edit
    @selected_plugin_names = find_user.plugins.map(&:name)
  end

  def update
    # Store what the user selected.
    @selected_role_names = params[:user].delete(:roles) || []
    @selected_role_names = @user.roles.select(:title).map(&:title) unless user_can_assign_roles?
    @selected_plugin_names = params[:user][:plugins]
    @selected_spree_role_names = params[:user][:spree_roles] || []

    if user_is_locking_themselves_out?
      flash.now[:error] = t('lockout_prevented', :scope => 'refinery.admin.users.update')
      render :edit and return
    end

    store_user_memento

    @user.roles = @selected_role_names.map { |r| Refinery::Role[r.downcase] }
    @user.spree_roles = @selected_spree_role_names.map { |r| Spree::Role.find_by(name: r) }
    if @user.update_attributes user_params
      update_successful
    else
      update_failed
    end
  end

  protected
    def create_successful
      @user.plugins = @selected_plugin_names

      # if the user is a superuser and can assign roles according to this site's
      # settings then the roles are set with the POST data.
      if user_can_assign_roles?
        @user.roles = @selected_role_names.map { |r| Refinery::Role[r.downcase] }
        @user.spree_roles = @selected_spree_role_names.map { |r| Spree::Role.find_by(name: r) }
      end

      redirect_to refinery.admin_users_path,
                  :notice => t('created', :what => @user.username, :scope => 'refinery.crudify')
    end

  private
    def find_available_spree_roles
      @available_spree_roles = Spree::Role.all
    end

  def store_user_memento
    # Store the current plugins and roles for this user.
    @previously_selected_plugin_names = @user.plugins.map(&:name)
    @previously_selected_roles = @user.roles
    @previously_selected_spree_roles = @user.spree_roles
  end

  def user_memento_rollback!
    @user.plugins = @previously_selected_plugin_names
    @user.roles = @previously_selected_roles
    @user.spree_roles = @previously_selected_spree_roles
    @user.save
  end

  def user_params
    params.require(:user).permit(
        :email, :password, :password_confirmation, :remember_me, :username,
        :login, :full_name, plugins: []
    )
  end
end