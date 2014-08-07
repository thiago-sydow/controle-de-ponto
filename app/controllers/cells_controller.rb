class CellsController < ApplicationController

  def total_worked_hours
    render cell: :record, :total_worked_on_day, current_user
  end

end