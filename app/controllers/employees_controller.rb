# frozen_string_literal: true

class EmployeesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_employee, only: %i[show update]
  before_action :set_designations, only: %i[edit update]
  load_and_authorize_resource

  def index
    @employees = Employee.search(params[:search])
    @designations = Designation.all
  end

  def show
    @employee = if current_user.is_hr?
                  Employee.find_by_id params[:id]
                else
                  current_user
                end
  end

  def edit; end

  def update
    if @employee.update(employee_params)
      redirect_to @employee
    else
      render :edit
    end
  end

  def profile
    @employee = Employee.all
  end

  private

  def set_designations
    @designations = Designation.all
    @skills = Skill.all
    @roles = Role.all
  end

  def set_employee
    @employee = Employee.find_by_id params[:id]
    redirect_to root_path, alert: I18n.t('employee.not_found') unless @employee.present?
  end

  def employee_params
    params.require(:employee).permit(:name, :father_name, :mother_name, :phone_number, :address, :email, :bank_name,
                                     :account_number, :pan_card_number, :aadhar_card_number, :primary_skill, :password, :password_confirmation, :designation_id, :role_id, :date_of_birth, :joining_date, :gender, :image, :alternate_phone_number, :alternate_email, :alternate_address, :reference_name, :reference_contact_number,:increment_on)
  end
end
