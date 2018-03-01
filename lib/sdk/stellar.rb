class Stellar
  include HTTParty
  
  base_uri ENV.fetch('STELLAR_BASE_URI', 'https://horizon-testnet.stellar.org')

  attr_accessor :cursor

  def initialize(account_id, cursor)
    @account_id = account_id
    @limit = 1
    @cursor = cursor
  end

  def account
    response = self.class.get("/accounts/#{@account_id}")
    to_object(response.body)
  end
  
  def transactions
    response = self.class.get("/accounts/#{@account_id}/transactions?limit=#{@limit}#{build_cursor}")
    to_object(response.body).try(:_embedded).try(:records)
  end
  
  
  private

  def build_cursor
    @cursor.nil? ? '' : "&cursor=#{@cursor}"
  end

  def to_object(response_body)
    JSON.parse(response_body, object_class: OpenStruct)
  end

end