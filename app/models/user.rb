class User < ActiveRecord::Base
  has_many :roles
  has_many :groups, through: :roles
  has_many :messages

  validates :username, uniqueness: true

  has_secure_password

  def not_in_groups
    id=[]
    self.groups.each{|group| id << group.id}
    Group.where.not(id: id)
  end

  def get_role(group)
    if !self.roles.where(group: group)[0].nil?
      self.roles.where(group: group)[0].role_type
    else
      return nil
    end
  end

  def set_role(roletype, group)
    self.roles.where(group: group).update(role_type: roletype)
  end
end
