class StocksController < ApplicationController
  def index

  end

  def show
    @c = Company.find(params[:id])
    time_format = "%e-%b-%Y %H:%M:%S"

    # https://www.fusioncharts.com/fusiontime/examples/column-and-line-combination-chart-on-time-axis
    @c_schema = [
      {
      "name": "Time",
      "type": "date",
      "format": time_format
      },
      {
      "name": "Price",
      "type": "number"
      },
      {
      "name": "Volume",
      "type": "number"
      }
    ].to_json

    @c_data = @c.stocks.where('stocks.data_datetime >= ?', 60.days.ago).order('data_datetime ASC').map {|e| [e.data_datetime.strftime(time_format), e.price.to_f, e.volume.to_f]}.to_json

  end
end
