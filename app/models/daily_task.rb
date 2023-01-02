# frozen_string_literal: true

class DailyTask < ApplicationRecord
  belongs_to :employee
  validates :description, presence: true
   paginates_per 5

  def self.search(search)
    if search
      daily_task = DailyTask.where(employee_id: [search])
    else
      all
    end
  end
end
