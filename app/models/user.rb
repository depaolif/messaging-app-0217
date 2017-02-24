class User < ActiveRecord::Base
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :messages

  has_secure_password

  def groups_without
    id=[]
    self.groups.each{|group| id << group.id}
    Group.where.not(id: id)
  end
end
