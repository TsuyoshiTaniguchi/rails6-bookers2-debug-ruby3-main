class Chat < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :room

  validates :message, presence: true, length: { maximum: 140 } # 140字制限
end
