class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  has_many :favorites
  has_many :favposts, through: :favorites, source: :favpost
  
  # --- 課題対応
  # あるポストのお気に入り登録数を知る場合は以下を追加する
  #has_many :reverses_of_favorite, class_name: 'Favorite', foreign_key: 'favpost_id'
  #has_many :favpostcounts, through: :reverses_of_favorite, source: :micropost
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  # --- 課題対応
  
  def add_to_favorite( liked_post )
    # 現状、お気に入り登録する投稿は自分のものも出来る仕様。
    #unless self == other_user
      self.favorites.find_or_create_by(favpost_id: liked_post.id)
    #end
  end

  def delete_from_favorite( unliked_post )
    # 現状、お気に入り解除する投稿は自分のものも出来る仕様。
    favorite = self.favorites.find_by(favpost_id: unliked_post.id)
    favorite.destroy if favorite
  end

  def favorite?(other_post)
    self.favposts.include?( other_post )
  end
  
end


