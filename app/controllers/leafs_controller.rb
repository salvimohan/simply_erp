class LeafsController < InheritedResources::Base
  before_action :authenticate_employee!
  def index
    if current_employee.role.name == "HR"
      @leafs = Leaf.order('created_at DESC')
    else
      @leafs = Leaf.where(employee_id: current_employee.id).order('created_at DESC')
    end
  end

  def create
    @leaf = Leaf.new(leaf_params)
    if @leaf.save 
      redirect_to leafs_path
    else
      render new_leaf_path
    end
  end

  def update
     @leaf = Leaf.find(params[:id])
      if @leaf.from_date > Time.now
        if @leaf.update(leave_status: 'cancelled')
          redirect_to leafs_path
        else
          render :index
        end
      else
         redirect_to leafs_path
      end
  end

  private
    def leaf_params
      params.require(:leaf).permit(:leave_type, :from_date, :till_date, :leave_starts, :leave_end, :total_days, :resion, :leave_status, :employee_id)
    end

end

