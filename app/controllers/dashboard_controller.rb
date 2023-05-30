# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_employee!
  def index
    @employees = Employee.where('EXTRACT(DAY FROM date_of_birth) = ?', Date.current.day).where(
      'EXTRACT(MONTH FROM date_of_birth) = ?', Date.current.month
    )
    @recent_join_employees = Employee.where(joining_date: (Time.now.to_date - 2.day)..Time.now.to_date)
    @upcoming_holidays = Holiday.where('holiday_date > ?', Time.now).limit(5).order('holiday_date ASC')
    @user_lists = Employee.where("mentor_id IS NULL")
  end
end
