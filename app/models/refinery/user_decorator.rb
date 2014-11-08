Refinery::User.class_eval do
  before_validation :copy_username_from_email

  protected

    def copy_username_from_email
      if self.username.blank? && self.email.present?
        self.username = self.email
      end
    end
end