class DeliveryOrdersController < ApplicationController
  before_action :load_products

  def new
    @customer = Customer.new
    @address = Address.new
  end

  def create
    @customer = Customer.new(customer_params)
    @address = Address.new(address_params)
    order_lines = build_order_lines

    if order_lines.empty?
      flash.now[:alert] = t("delivery_orders.no_items_selected")
      return render :new, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      normalized_phone = Phonelib.parse(customer_params[:phone]).e164
      customer = Customer.find_or_create_by!(phone: normalized_phone) do |c|
        c.name = customer_params[:name]
        c.created_via = "web"
      end
      address = customer.addresses.create!(address_params)
      @delivery_order = DeliveryOrder.create!(
        customer: customer, address: address, order_source: "web",
        order_lines_attributes: order_lines
      )
    end

    redirect_to locale_root_path(locale: I18n.locale), notice: t("delivery_orders.thank_you")
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = e.record.errors.full_messages.join(", ")
    render :new, status: :unprocessable_entity
  end

  private

  def load_products
    @products = Product.active.ordered
  end

  def customer_params
    params.require(:customer).permit(:name, :phone)
  end

  def address_params
    params.require(:address).permit(:district, :free_text_description, :delivery_notes, :geo_lat, :geo_lng)
  end

  def build_order_lines
    quantities = params[:quantities].is_a?(ActionController::Parameters) ? params[:quantities].to_unsafe_h : (params[:quantities] || {})
    quantities.filter_map do |product_id, quantity|
      quantity = quantity.to_i
      next if quantity <= 0

      product = @products.find { |p| p.id == product_id.to_i }
      next unless product

      { product_id: product.id, quantity: quantity, unit_price_try: product.base_price_try }
    end
  end
end
