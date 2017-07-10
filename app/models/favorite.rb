class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favpost, class_name: 'Micropost'
  
  validates :user_id, presence: true
  validates :favpost_id, presence: true
end
