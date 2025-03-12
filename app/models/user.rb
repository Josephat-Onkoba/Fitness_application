class User < ApplicationRecord
    has_secure_password
    
    has_many :workouts, dependent: :destroy
    has_many :goals, dependent: :destroy
    
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 }
    validates :first_name, :last_name, presence: true
    
    def full_name
      "#{first_name} #{last_name}"
    end
    attr_accessor :reset_token
    # other attributes and validations...
    
    # Returns a random token
    def self.new_token
      SecureRandom.urlsafe_base64
    end
    
    # Returns the hash digest of the given string
    def self.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
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
    
    # Returns true if a password reset has expired
    def password_reset_expired?
      reset_sent_at < 2.hours.ago
    end
    
    # Returns true if the given token matches the digest
    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end
  end