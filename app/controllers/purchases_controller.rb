class PurchasesController < ApplicationController
  
  def create
    @purchase = current_user.purchases.build(purchase_params)
    @purchase.save
    redirect_to root_path
  end
  
  private

  def purchase_params
    params[:purchase].permit(:content_id)
  end
end
