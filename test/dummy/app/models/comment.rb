class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true

  def to_s
    body
  end
end
