# frozen_string_literal: true

module AdminMain
  require 'securerandom'

  class EmployeesController < ApplicationController
    before_action :set_employee, only: %i[show destroy edit generate_password]
    before_action :set_designations, only: %i[new create edit update]

    def index
      @employees = Employee.search(params[:search])
      @designations = Designation.all
    end

    def new
      @employee = Employee.new
    end

    def show; end

    def create
      @employee = Employee.new(employee_params)
      if @employee.save
        redirect_to admin_main_employee_path(@employee)
      else
        render :new
      end
    end

    def edit; end

    def update
      @employee = Employee.find_by_id params[:id]
      if @employee.update(employee_params)
        redirect_to admin_main_employee_path(@employee)
      else
        render :edit
      end
    end

    def destroy
      @employee.destroy
      redirect_to admin_main_employees_path
    end

    def update_leave_balance
      singleton_leave = AdminSingletonLeave.instance
      unless singleton_leave.leave_increment_date == Date.today.beginning_of_month
        leaves = Employee.all
        leaves.each do |leave|
          leave.increment!(:leave_count)
        end
        singleton_leave.update(leave_increment_date: Date.today.beginning_of_month)
      end
      redirect_to root_path
    end

    def generate_password
      @password = SecureRandom.alphanumeric(10)
      @employee.password = @password
      @employee.save
    end

    private

    def set_designations
      @designations = Designation.all
      @skills = Skill.all
      @roles = Role.all
    end

    def set_employee
      @employee = Employee.find_by_id params[:id]
      redirect_to root_path, { notice: 'NOT FOUND' } unless @employee.present?
    end

    def employee_params
      params.require(:employee).permit(:designation_id, :role_id, :name, :father_name, :mother_name, :date_of_birth,
                                       :phone_number, :email, :address, :bank_name, :account_number, :pan_card_number, :aadhar_card_number, :primary_skill, :password, :password_confirmation, :joining_date, :gender, :image, :alternate_phone_number, :alternate_email, :alternate_address, :reference_name, :reference_contact_number,:attendence_employee_code)
    end
  end
end
