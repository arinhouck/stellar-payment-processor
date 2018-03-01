require "#{Rails.root}/lib/sdk/stellar"
class PaymentProcessor
  
  def self.perform
    
    # Create or find a setting record by `cursor` key
    cursor_setting = Setting.find_or_create_by(key: 'cursor')
    
    # Extract the value of the `cursor` if it exists in DB
    cursor = cursor_setting&.value
    
    # Instantiate the Stellar SDK by merchant account public key and cursor
    sdk = ::Stellar.new(ENV.fetch('ACCOUNT_ID', 'GCBTFNXKR276VT2O7IP5G7MZFOGMPB4UNFQUOIXC2AKAAD7DYMF23O7N'), cursor)
    
    # Instantiate list of memos
    memos = []
    
    # Extract transactions
    transactions = sdk.transactions
    
    # Loop until no transactions left (empty)
    until transactions.empty?
      
      # iterate each transaction and extract memo
      transactions.each do |tr|
        memos << tr.memo
        # Set cursor to call API again (API is paginated)
        sdk.cursor = tr.paging_token
      end
      
      # When you call transactions again it will
      # extract transactions after new cursor
      transactions = sdk.transactions
    end
    
    # Mark all purchases as completed by memo (not include nil values)
    Purchase.where(memo: memos.compact).update_all(completed: true)
    
    # Update latest cursor in database
    # so next time payment processor starts it
    # will load from latest cursor
    if sdk.cursor != cursor
      cursor_setting.update_column(:value, sdk.cursor)
    end
  end

end