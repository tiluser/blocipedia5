class AddCollabListToWikis < ActiveRecord::Migration[5.1]
  def change
    add_column :wikis, :collab_list, :string
  end
end
