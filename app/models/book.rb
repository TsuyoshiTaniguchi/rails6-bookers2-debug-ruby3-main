class Book < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  scope :last_week, -> { where(created_at: 1.week.ago..Time.current) }

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.looks(search, word)
    case search
    when "perfect_match"
      where("title LIKE ?", "#{word}")
    when "forward_match"
      where("title LIKE ?", "#{word}%")
    when "backward_match"
      where("title LIKE ?", "%#{word}")
    when "partial_match"
      where("title LIKE ?", "%#{word}%")
    else
      all
    end
  end

  # 過去一週間でいいねが多い順に取得
  def self.popular_books_last_week
    last_week.left_joins(:favorites).group(:id).order('COUNT(favorites.id) DESC')
  end
end
