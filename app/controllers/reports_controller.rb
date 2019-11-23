class ReportsController < ApplicationController
  def option; end

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

    @report.start_date = params["start_date"].to_date
    @report.end_date = params["end_date"].to_date

    @report.kind = params[:kind]

    if @report.save
      redirect_to report_path(@report), notice: 'You created a report'
    else
      redirect_back fallback_location: root_path, notice: @report.errors.full_messages.to_s
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
