# frozen_string_literal: true

module AdminMain
  class AttendencesController < ApplicationController

    skip_before_action :authorize_admin, :only => [:import_attendance, :import_csv]

    before_action :authorize_hr_or_admin, :only => [:import_attendance, :import_csv]

    before_action :set_attendance, only: %i[edit update]
    before_action :set_employee, only: %i[show]

    def index
      @employees = Employee.where(['name LIKE ? ', "%#{params[:search]}%"])
    end

    def show
      @attendences = if params[:month].blank?
                       @employee.attendences.order('created_at asc').page(params[:page])
                     else
                       @employee.attendences.where('EXTRACT(MONTH FROM created_at) = ?', params[:month])
                     end
    end

    def edit; end

    def update
      if params[:attendence].present?
        if @attendence.update(attendence_params)
          redirect_to admin_main_attendence_path(@attendence.employee_id)
        else
          render :edit
        end
      else
        redirect_to admin_main_attendence_path
      end
    end

    def import_attendance
    end

    def import_csv
      uploaded_file = params[:csv_file]
      temp_file_path = uploaded_file.tempfile.path

      # Process the CSV data
      CSV.foreach(temp_file_path, headers: true) do |row|
        Attendence.create!({
          checkin_time: row["enter_time"], 
          checkout_time: row["out_time"], 
          employee_code: row["Employee Code"].to_i, 
          total_minutes: row["total_min"].to_i
        })
        # Access the data using row['column_name']
        # Create or update records in the database
      end
      redirect_to import_attendance_admin_main_attendences_path, { notice: 'Import successfully' }
    end

    private

    def set_attendance
      @attendence = Attendence.find_by_id params[:id]
      redirect_to root_path, { notice: 'NOT FOUND :)' } unless @attendence.present?
    end

    def attendence_params
      params.require(:attendence).permit(:checkout_time)
    end

    def set_employee
      @employee = Employee.find_by_id params[:id]
      redirect_to root_path, { notice: 'NOT FOUND :)' } unless @employee.present?
    end
  end
end
