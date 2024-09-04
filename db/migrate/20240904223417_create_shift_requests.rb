class CreateShiftRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :shift_requests do |t|
      t.references :employee, null: false, foreign_key: true
      t.date :date
      t.string :shift_type
      t.references :shift_requests, :shift, foreign_key: true

      t.timestamps
    end
  end
end
