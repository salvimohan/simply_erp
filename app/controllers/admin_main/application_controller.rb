module AdminMain
  # applicationcontroller
  class ApplicationController < ApplicationController
    before_action :authorize_admin
    layout 'application'

    def authorize_admin
      redirect_to root_path, alert: I18n.t('employee.unauthorize_error') unless current_employee.is_admin?
    end

    def authorize_hr_or_admin
      redirect_to root_path, alert: I18n.t('employee.unauthorize_error') if (!current_employee.is_admin? && !current_employee.is_hr?)
    end
  end
end
