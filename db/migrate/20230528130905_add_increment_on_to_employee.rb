class AddIncrementOnToEmployee < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :increment_on, :datetime
  end
end
