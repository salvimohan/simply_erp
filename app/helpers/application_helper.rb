# frozen_string_literal: true

# application controller
module ApplicationHelper
  def salary_total
    # array = []
    # current_employee.salaries.each do |s|
    #   next unless s.created_at.strftime('%m-%y') == Time.zone.now.strftime('%m-%y')

    #   current_employee.attendences.each do |a|
    #     array << a.checkin_time.strftime('%d-%m-%y')
    #     array.uniq
    #   end
    #   return s.salary / 30 * array.uniq.count
    # end
  end
   FLASH_CLASSES = {
      notice: 'alert alert-info',
      success: 'alert alert-success',
      alert: 'alert alert-danger',
      error: 'alert alert-danger'
    }.freeze
    
    def flash_class(level)
      FLASH_CLASSES[level]
    end

    def date_format(date)
      date.nil? ? '' : date.strftime("%d %b %Y")
    end

    def employee_image(employee)
      unless employee.image.blank?
        employee.image
      else
        "blank-profile.png"
      end
    end
end
