class Meetup < ActiveRecord::Base
  validates :name, presence: true
  has_many :meetup_users
  has_many :users, through: :meetup_users
end