ActiveAdmin.register Salary do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :salary, :month, :total, :employee_id
  #
  # or
  #
  permit_params do
     permitted = [:salary, :month, :total, :employee_id]
     permitted << :other if params[:action] == 'create' && current_admin_user
     permitted
  end
  
end
