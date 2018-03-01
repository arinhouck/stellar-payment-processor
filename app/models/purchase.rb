class Purchase < ApplicationRecord
  
  before_create :assign_memo

  def assign_memo
    self.memo = SecureRandom.hex(14)
  end

end
