class ReportsController < ApplicationController

  def option

  end

  def index
    @reports = Report.all
  end

  def show
    report
  end

  def create
    @report = Report.new
    @report.user = income_user
    @report.title = params[:title] == '' ? Date.today.to_s : params[:title]
    @report.start_date = Date.new(params["start_date(1i)"].to_i, params["start_date(2i)"].to_i, params["start_date(3i)"].to_i)
    @report.end_date = Date.new(params["end_date(1i)"].to_i, params["end_date(2i)"].to_i, params["end_date(3i)"].to_i)
    @report.kind = params[:kind]

    if @report.save
      redirect_to report_path(@report), notice: 'You created a report'
    else
      redirect_back fallback_location: root_path, notice: "#{@report.errors.full_messages}"
    end
  end

  def destroy
    report.destroy
    flash[:notice] = 'You successfully delete report.'
    redirect_to reports_path
  end

  def report
    @report ||= Report.find(params[:id])
  end

end
