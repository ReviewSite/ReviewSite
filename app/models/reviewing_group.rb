class ReviewingGroup < ActiveRecord::Base
  attr_accessible :name, :user_tokens, :users
  attr_reader :user_tokens

  has_and_belongs_to_many :users

  validates :name, presence: true, uniqueness: true

  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end

  def members
    list(self.users)
  end

  def to_s
    self.name
  end

end
