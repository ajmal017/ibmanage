class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]


  def index_download
    @reports = Report.all
    @portfolios = Portfolio.all
  end


  def update_positions
    begin
      r = Report.find(params[:id])

      report_id = r.code
      token = r.portfolio.token
      portfolio_id = r.portfolio.id

      @fws = Flexws.new
      @fws.fetchAndUpdateDB(token, report_id, portfolio_id)

    rescue => e
      puts e.message
      puts @fws.logs
    end
  end


  def download
    r = Report.find(params[:id])

    name = "#{r.portfolio.name}_#{r.name}.csv"
    portfolio_id = r.portfolio.id
    
    @fws = Flexws.new
    str = @fws.toYahooFormat(portfolio_id)

    send_data str, filename: name, type: "application/csv"
  end



  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:name, :code, :portfolio_id)
    end

end
