module PasswordReset
    extend ActiveSupport::Concern
    
    included do
      attr_accessor :reset_token
      before_save :downcase_email
    end
    
    # Sets the password reset attributes
    def create_reset_digest
      self.reset_token = User.new_token
      update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end
    
    # Sends password reset email
    def send_password_reset_email
      UserMailer.password_reset(self).deliver_now
    end
    
    # Returns true if a password reset has expired.
    def password_reset_expired?
      reset_sent_at < 2.hours.ago
    end
    
    class_methods do
      # Returns a random token
      def new_token
        SecureRandom.urlsafe_base64
      end
      
      # Returns the hash digest of the given string
      def digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end
    end
    
    private
    
    # Converts email to all lower-case
    def downcase_email
      self.email = email.downcase
    end
  end