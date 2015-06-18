class MeetupUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup
  validates :user, presence: true
  validates :user_id, numericality: true
  validates :meetup, presence: true
  validates :meetup_id, numericality: true
  validates_uniqueness_of :user_id, scope: :meetup_id
end