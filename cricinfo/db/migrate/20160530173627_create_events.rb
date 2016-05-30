class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :batsman_id
      t.integer :bowler_id
      t.integer :run
      t.string :comment
      t.string :important
      t.string :over
      t.integer :match_id

      t.timestamps null: false
    end
  end
end
