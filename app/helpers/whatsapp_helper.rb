module WhatsappHelper
  # WHATSAPP_BUSINESS_NUMBER must be set as a real secret in production; the
  # placeholder default here only keeps development/test from crashing.
  def whatsapp_order_url(product, quantity: 1)
    number = ENV.fetch("WHATSAPP_BUSINESS_NUMBER", "905330000000")
    text = t("whatsapp.order_template", quantity: quantity, product: product.name, size: product.size_liters)
    "https://wa.me/#{number}?text=#{ERB::Util.url_encode(text)}"
  end
end
