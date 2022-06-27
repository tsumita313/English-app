class AddCommentToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :comment, :text
  end
end
