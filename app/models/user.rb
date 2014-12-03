class User < ActiveRecord::Base
  # We are defining 3 kind of roles for users
  # admin: has authority to delete any posts but editing and creating his own posts
  # writer: has authority to create and delete his own posts
  # reader: can only read the posts without any special authorizations
  enum role: [:reader, :writer, :admin]
  has_many :posts

  def role= value
    if value.kind_of?(String) and value.to_i.to_s == value
      super value.to_i
    else
      super value
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
