class Spree::UsersController < Spree::StoreController
  ssl_required
  skip_before_filter :set_current_order, :only => :show
  prepend_before_filter :load_object, :only => [:show, :edit, :update]
  prepend_before_filter :authorize_actions, :only => :new

  include Spree::Core::ControllerHelpers

  def show
    @orders = @user.orders.complete.order('completed_at desc')
  end

  def create
    @user = Refinery::User.new(user_params)
    if @user.save

      if current_order
        session[:guest_token] = nil
      end

      redirect_back_or_default(root_url)
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      if params[:user][:password].present?
        # this logic needed b/c devise wants to log us out after password changes
        user = Refinery::User.reset_password_by_token(params[:user])
        sign_in(@user, :event => :authentication, :bypass => !RefinerySpree::Config[:signout_after_password_change])
      end
      redirect_to spree.account_url, :notice => Spree.t(:account_updated)
    else
      render :edit
    end
  end

  private

    # Allowable attributes
    # @@user_attributes = [:email, :password, :password_confirmation]
    def user_params
      params.require(:user).permit(Spree::PermittedAttributes.user_attributes)
    end

    def load_object
      @user ||= spree_current_user
      authorize! params[:action].to_sym, @user
    end

    def authorize_actions
      authorize! params[:action].to_sym, Refinery::User.new
    end

    def accurate_title
      Spree.t(:my_account)
    end
end