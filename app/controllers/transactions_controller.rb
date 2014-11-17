class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    @transaction.pre_tip_cost = @transaction.pre_tip_cost*100
    @transaction.post_tip = (@transaction.pre_tip_cost * (@transaction.tip_percentage+100))/100
    @transaction.individual_contribution = @transaction.post_tip / (@transaction.number_splitting + 1)

    # Adjusts Amount - Divides by 100. Amount saved as integer, not decimal. Negative# =Charge, Positive# =Payment
    @individual_contribution_adjusted = -(@transaction.individual_contribution / 100)
    #Converts note to url appropriate note for API request
    @note_adjusted = convert_string_to_url(@transaction.note)
    # NO OAuth currently - my access token used.    
    @access_token = 'grR2SCEm2C7HdWGukWQEJyW6RpEWJYp3'    
    
    # Static POST request sent via Venmo's API, NO OAuth.
    response = HTTParty.post("https://api.venmo.com/v1/payments?access_token=#{@access_token}&phone=#{@transaction.phone_number_charged}&amount=#{@individual_contribution_adjusted}&note=#{@note_adjusted}&audience=#{@transaction.audience}")
    puts response.body, response.code, response.message, response.headers.inspect


  # POST /transactions
  # POST
    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def convert_string_to_url(string)
    string.gsub(" ", "%20")
    string.gsub("?", "%3F")
    string.gsub("$", "%24")
    string.gsub("@", "%40")
    string.gsub("#", "%23")
    string.gsub("&", "%26")
    string.gsub("+", "%2B")
    string.gsub("=", "%3D")
    string.gsub("^", "%5E")
    string.gsub("/", "%2F")
    string.gsub(":", "%3A")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:pre_tip_cost, :note, :number_splitting, :tip_percentage, :post_tip, :audience, :phone_number_charged)
    end
end
