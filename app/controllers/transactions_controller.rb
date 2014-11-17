class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all

    # @access_token = 'grR2SCEm2C7HdWGukWQEJyW6RpEWJYp3'
    # puts "My Access Token to the Venmo API: #{@access_token}"


    # MYYYY user id is: '1521929085255680697'
  
    # Use the class methods to get down to business quickly
    # response = HTTParty.get('https://api.stackexchange.com/2.2/questions?site=stackoverflow')

    # https://api.venmo.com/v1/payments?access_token=<access_token>

    # response = HTTParty.get('https://api.venmo.com/v1/payments?access_token=' + @access_token)
    # puts response.body, response.code, response.message, response.headers.inspect

    # https://sandbox-api.venmo.com/v1/payments?limit=1&access_token=grR2SCEm2C7HdWGukWQEJyW6RpEWJYp3
    # Returns last payment made

    # https://sandbox-api.venmo.com/v1/payments/1541549070684783037?access_token=grR2SCEm2C7HdWGukWQEJyW6RpEWJYp3
    # Returns payment [id]

    # https://sandbox-api.venmo.com/v1/payments?user_id=145434160922624933&phone=15555555555&email=venmo%40venmo.com&amount=0.10&note=api%20playyya&audience=private

    # POST /v1/payments?access_token=4wBq6AbfMrnE53mVMT2CvpPzynXwE7GP&user_id=145434160922624933&phone=15555555555&email=venmo%40venmo.com&amount=0.10&note=api%20playyya&audience=private

    # POST request to sample Venmo API payment (fields inflexible)


    # FROM THE COMMAND LINE...........THIS POST PAYMENT WORKED--IN REAL LIFE!!!!!!!!!!!!!!!!!!!
    # curl https://api.venmo.com/v1/payments -d access_token=grR2SCEm2C7HdWGukWQEJyW6RpEWJYp3 -d phone=16612107788 -d amount=3 -d note="playing" -d audience="private"

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
    puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    puts "pre tip : #{@transaction.pre_tip_cost}"
    puts "final amount"
    puts @transaction.post_tip
    puts "number splitting"
    puts @transaction.number_splitting
    @transaction.individual_contribution = @transaction.post_tip / (@transaction.number_splitting + 1)
    puts @transaction.individual_contribution


    # THIS WORKS!!!!!!!!! HTTP POST REQUEST works IRL
    # puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    # response = HTTParty.post("https://api.venmo.com/v1/payments?access_token=grR2SCEm2C7HdWGukWQEJyW6RpEWJYp3&phone=16612107788&amount=3&note=api%20play&audience=private")
    # puts response.body, response.code, response.message, response.headers.inspect



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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:pre_tip_cost, :note, :number_splitting, :tip_percentage, :post_tip)
    end
end
