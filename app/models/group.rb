class Group < ActiveRecord::Base
  has_many :roles
  has_many :users, through: :roles
  has_many :messages

  def get_admin
    Role.where(role_type: "Admin", group: self)[0].user
  end
end
