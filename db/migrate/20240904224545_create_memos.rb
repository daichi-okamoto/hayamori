class CreateMemos < ActiveRecord::Migration[7.0]
  def change
    create_table :memos do |t|
      t.date :date
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.integer :shift_id

      t.timestamps
    end
  end
end
