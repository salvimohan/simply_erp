class AddEmployeeCodeToAttendance < ActiveRecord::Migration[6.1]
  def change
    add_column :attendences, :employee_code, :integer
    add_column :attendences, :total_minutes, :integer, default: 0
    remove_column :attendences, :employee_id
    remove_column :attendences, :status
    remove_column :attendences, :hour
  end
end
