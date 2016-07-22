class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: /.+@.+\..+/i}
  has_secure_password
  validates :password, presence: true, length: {minimum: 4}
  attr_accessor :remember_token
  before_save {self.email = email.downcase}

  def User.digest(string)
    cost=ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    					        BCrypt::Engine.cost
    BCrypt::Passowrd.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remembe_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

end
