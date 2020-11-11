class Post < ApplicationRecord
  belongs_to :user

  def to_s
    title
  end
end
