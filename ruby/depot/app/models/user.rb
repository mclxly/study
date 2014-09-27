class User < ActiveRecord::Base
  attr_accessor :current_password

  validates :name, presence: true, uniqueness: true
  has_secure_password
  after_destroy :ensure_an_admin_remains  
  # validates :password_confirmation, presence: true, :on => :update, :unless => lambda{ |user| user.password.blank? }

  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise "Can't delete last user"
      end
    end
end
