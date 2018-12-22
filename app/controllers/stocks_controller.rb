class StocksController < ApplicationController
  def show
    # Default data Max Range one Month
    @c = Company.first
    @c_ss = @c.stocks.where(
      "data_datetime >= ?", Time.zone.parse('2015-11-01')
      ).group_by_month(&:data_datetime)
  end
end
