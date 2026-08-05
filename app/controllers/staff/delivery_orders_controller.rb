module Staff
  class DeliveryOrdersController < Staff::BaseController
    before_action :set_delivery_order, only: [:show, :update]
    before_action :load_products, only: [:new, :create]

    def index
      @delivery_orders = DeliveryOrder.includes(:customer, :address).order(created_at: :desc)
      @delivery_orders = @delivery_orders.in_district(params[:district]) if params[:district].present?
      @delivery_orders = @delivery_orders.on_date(Date.parse(params[:date])) if params[:date].present?
    end

    def show
    end

    def update
      @delivery_order.update!(status_params)
      redirect_to staff_delivery_order_path(@delivery_order), notice: "Order updated."
    end

    def new
      @customer = Customer.new
      @address = Address.new
      @order_source = "phone"
    end

    def create
      @customer = Customer.new(customer_params)
      @address = Address.new(address_params)
      @order_source = params[:order_source].presence_in(%w[whatsapp phone]) || "phone"
      order_lines = build_order_lines

      if order_lines.empty?
        flash.now[:alert] = "Please select at least one product."
        return render :new, status: :unprocessable_entity
      end

      ActiveRecord::Base.transaction do
        normalized_phone = Phonelib.parse(customer_params[:phone]).e164
        customer = Customer.find_or_create_by!(phone: normalized_phone) do |c|
          c.name = customer_params[:name]
          c.created_via = @order_source
        end
        address = customer.addresses.create!(address_params)
        @delivery_order = DeliveryOrder.create!(
          customer: customer, address: address, order_source: @order_source,
          order_lines_attributes: order_lines
        )
      end

      redirect_to staff_delivery_order_path(@delivery_order), notice: "Order created."
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e.record.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end

    private

    def set_delivery_order
      @delivery_order = DeliveryOrder.includes(:customer, :address, order_lines: :product).find(params[:id])
    end

    def status_params
      params.require(:delivery_order).permit(:status)
    end

    def load_products
      @products = Product.active.ordered
    end

    def customer_params
      params.require(:customer).permit(:name, :phone)
    end

    def address_params
      params.require(:address).permit(:district, :free_text_description, :delivery_notes)
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
end
