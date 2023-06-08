# frozen_string_literal: true

# attendence controller
module Hr
  # attendence controller we are use for hr
  class AttendencesController < ApplicationController
    before_action :set_attendance, only: %i[show edit update]

    def show_attendence
      @employee = Employee.find(params[:id])
      @start_date, @end_date = Time.now.beginning_of_month, Time.now.end_of_month
      @attendences = Attendence.where(employee_code: @employee.attendance_employee_code, 
        checkin_time: (@start_date..@end_date)).group_by{|attendence| attendence.checkin_time.strftime("%d %b %Y")}
    end

    def details
      @employee = Employee.find(params[:id])
      start_date = params[:day].to_date.all_day rescue Time.now
      @attendences = Attendence.where(employee_code: @employee.attendance_employee_code).where(checkin_time: start_date)
    end

    def show
      employee_attendence(@attendence.employee_id)
    end

    def edit; end

    def update
      if params[:attendence].present?
        if @attendence.update(attendence_params)
          redirect_to hr_attendence_path
        else
          render :edit
        end
      else
        redirect_to hr_attendence_path
      end
    end

    def search
      @attendences = Attendence.search(params)
    end

    private

    def set_attendance
      @attendence = Attendence.find_by_id params[:id]
      redirect_to root_path, { notice: 'NOT FOUND :)' } unless @attendence.present?
    end

    def attendence_params
      params.require(:attendence).permit(:checkout_time)
    end

    def employee_attendence(employee_id)
      @attendences = Attendence.where(employee_code: employee_id)
    end
  end
end
