module PayPal
  include PayPal::SDK::REST

  #TODO: rewrite to products from Restaurants
  def create_payment
    @payment = Payment.new(
      {
        intent: "sale",
        payer: {
          payment_method:  "paypal"
        },
        redirect_urls: {
          return_url: ENV["MY_UI_HOST"],
          cancel_url: ENV["MY_HOST"]
        },
        transactions:  [{
          item_list: {
            items: [{
              name: product_name,
              sku: product_value,
              price: product_price,
              currency: "USD",
              quantity: 1
            }]
          },
          amount:  {
            total:  coins,
            currency:  "USD"
          },
          description:  "Buy #{product_name}"
        }]
      }
    )
    
    if @payment.create
      @payment.id     # Payment Id
    else
      @payment.error  # Error Hash
    end
  end
end