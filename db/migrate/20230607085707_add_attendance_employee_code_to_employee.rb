class AddAttendanceEmployeeCodeToEmployee < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :attendance_employee_code, :integer
  end
end
