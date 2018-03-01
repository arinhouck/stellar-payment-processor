require "#{Rails.root}/lib/sdk/stellar"
class PaymentProcessor
  
  def self.perform
    
    cursor_setting = Setting.find_or_create_by(key: 'cursor')
    cursor = cursor_setting&.value
    sdk = ::Stellar.new(ENV.fetch('ACCOUNT_ID', 'GCBTFNXKR276VT2O7IP5G7MZFOGMPB4UNFQUOIXC2AKAAD7DYMF23O7N'), cursor)
    memos = []
    
    transactions = sdk.transactions
    until transactions.empty?
      transactions.each do |tr|
        memos << tr.memo
        sdk.cursor = tr.paging_token
      end
      transactions = sdk.transactions
    end
    
    Purchase.where(memo: memos.compact).update_all(completed: true)
    
    if sdk.cursor != cursor
      cursor_setting.update_column(:value, sdk.cursor)
    end
  end
  
end