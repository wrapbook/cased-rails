class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.string :title, null: false
      t.string :body, null: false

      t.timestamps null: false
    end
  end
end
