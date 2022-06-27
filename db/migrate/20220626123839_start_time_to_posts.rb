class StartTimeToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :start_time, :datetime
  end
end
