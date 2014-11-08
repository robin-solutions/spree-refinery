

Refinery::User.class_eval do
  class DestroyWithOrdersError < StandardError; end

  include Spree::UserAddress
  include Spree::UserPaymentSource

  before_validation :copy_username_from_email
  before_destroy :check_completed_orders

  has_many :orders, class_name: 'Spree::Order'

  def store_admin?
    has_spree_role?('admin')
  end

  private

    def copy_username_from_email
      self.username ||= self.email if self.email
    end

    def check_completed_orders
      raise DestroyWithOrdersError if orders.complete.present?
    end
end