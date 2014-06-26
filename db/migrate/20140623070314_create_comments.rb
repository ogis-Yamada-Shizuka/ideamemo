class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :reviewer
      t.string :reviewcomment

      t.timestamps
    end
  end
end
