class Stellar
  include HTTParty
  
  base_uri ENV.fetch('STELLAR_BASE_URI', 'https://horizon-testnet.stellar.org')
  
  attr_accessor :cursor
  
  def initialize(account_id, cursor)
    # account public key
    @account_id = account_id
    # how many records to include per call
    @limit = 1
    # optional value to keep track of where we last processed a transaction
    @cursor = cursor
  end
  
  # GET call to retrieve all transactions
  # https://www.stellar.org/developers/horizon/reference/endpoints/transactions-for-account.html#request
  def transactions
    response = self.class.get("/accounts/#{@account_id}/transactions?limit=#{@limit}#{build_cursor}")
    to_object(response.body).try(:_embedded).try(:records) || []
  end
  
  
  private
  
  # Set cursor param when retrieving transactions if exists
  def build_cursor
    @cursor.nil? ? '' : "&cursor=#{@cursor}"
  end
  
  # Fancy way to parse json into Ruby OpenStruct object
  def to_object(response_body)
    JSON.parse(response_body, object_class: OpenStruct)
  end

end