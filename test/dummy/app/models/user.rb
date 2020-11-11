class User < ApplicationRecord
  include Cased::Model::Automatic

  validates :email, presence: true, uniqueness: true

  def to_s
    email
  end
end
