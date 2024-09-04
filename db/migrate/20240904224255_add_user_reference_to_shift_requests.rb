class AddUserReferenceToShiftRequests < ActiveRecord::Migration[7.0]
  def change
    add_reference :shift_requests, :user, null: false, foreign_key: true
  end
end
