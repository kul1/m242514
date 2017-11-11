# encoding: utf-8
class Article
  include Mongoid::Document
  # mindapp begin
  include Mongoid::Timestamps
  field :title, :type => String
  field :text, :type => String
  belongs_to :user
  has_many :comments
  validates :title, :text, :user_id, presence: true
  field :body, :type => String
  field :keywords, :type => String
  # mindapp end

    #
    # def self.search(search)
    #   where('title || keywords || body LIKE ?', "%#{search}%")
    # end

  def self.search(search)
    where("title LIKE ?", "%#{params['search']}%")
  end

end
