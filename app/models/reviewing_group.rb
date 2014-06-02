class ReviewingGroup < ActiveRecord::Base
  attr_accessible :name, :user_tokens
  attr_reader :user_tokens

  has_and_belongs_to_many :users

  validates :name, presence: true

  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end

  def members
    self.users.map { |m| m.to_s}.sort.join(', ')
  end

  def to_s
    self.name
  end

end
