class Meetup < ActiveRecord::Base
  validates :name, presence: true
  validates :location, presence: true
  validates :description, presence: true
  has_many :meetup_users
  has_many :users, through: :meetup_users
end