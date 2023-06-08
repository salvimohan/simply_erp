# frozen_string_literal: true

# Attendence controller
class AttendencesController < InheritedResources::Base
  # load_and_authorize_resource
  before_action :set_attendance, only: %i[show edit]
  def index
    #@attendences = current_employee.attendences.order(created_at: :desc)
   @start_date, @end_date = Time.now.beginning_of_month, Time.now.end_of_month
    @attendences = Attendence.where(employee_code: current_employee.attendance_employee_code, 
      checkin_time: (@start_date..@end_date)).group_by{|attendence| attendence.checkin_time.strftime("%d %b %Y")}
  end

  def details
    start_date = params[:day].to_date.all_day rescue Time.now
    @attendences = Attendence.where(employee_code: current_employee.attendance_employee_code).where(checkin_time: start_date)
  end

  def show
    @attendences = Attendence.where(employee_code: @attendence.employee_code)
  end

  def create
    last_attendance = Attendence.where(checkin_time: Time.zone.now - 2.minutes..Time.zone.now,
                                       employee_id: current_employee.id).last
    if last_attendance.nil?
      Attendence.create(employee_id: current_employee.id, checkin_time: Time.zone.now,
                        status: 'Present', checkin_ip_address: request.remote_ip)
    else
      last_attendance.update_column('checkout_time', nil)
    end
    redirect_to root_path
  end

  def update_attendence
    attendence = current_employee.todays_last_attendence
    attendence.update(checkout_time: Time.zone.now, checkout_ip_address: request.remote_ip)
    redirect_to root_path
  end

  def set_attendance
    @attendence = Attendence.where(id: params[:id], employee_code: current_employee.attendance_employee_code).first
    redirect_to root_path, alert: I18n.t('employee.not_found') unless @attendence.present?
  end
end
