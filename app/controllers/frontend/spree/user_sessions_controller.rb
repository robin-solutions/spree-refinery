class Spree::UserSessionsController < Devise::SessionsController
  helper 'spree/base', 'spree/store'
  if RefinerySpree::Engine.dash_available?
    helper 'spree/analytics'
  end

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::SSL
  include Spree::Core::ControllerHelpers::Store

  # Want to default to refinery authentication messages
  include Refinery::AuthenticatedSystem
  include AfterSignInRedirect

  ssl_required :new, :create, :destroy, :update
  ssl_allowed :login_bar

  def create
    authenticate_refinery_user!

    if refinery_user_signed_in?
      respond_to do |format|
        format.html {
          flash[:success] = Spree.t(:logged_in_succesfully)
          redirect_back_or_default(after_sign_in_path_for(spree_current_user))
        }
        format.js {
          render :json => {:user => spree_current_user,
                           :ship_address => spree_current_user.ship_address,
                           :bill_address => spree_current_user.bill_address}.to_json
        }
      end
    else
      respond_to do |format|
        format.html {
          flash.now[:error] = t('devise.failure.invalid')
          render :new
        }
        format.js {
          render :json => { error: t('devise.failure.invalid') }, status: :unprocessable_entity
        }
      end
    end
  end

  private
    def accurate_title
      Spree.t(:login)
    end

    # def redirect_back_or_default(default)
    #   redirect_to(session["spree_user_return_to"] || default)
    #   session["spree_user_return_to"] = nil
    # end
end