class RatingQuestion
  include Mongoid::Document

  field :title
  field :tag
  validates :title, presence: true
end