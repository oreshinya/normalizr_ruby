class User < ActiveRecord::Base
  belongs_to :team
  has_many :comments
  has_many :reactions
end
