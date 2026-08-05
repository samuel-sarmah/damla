# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

PRODUCTS = [
  { sku: "WTR-0.5L", size_liters: 0.5, unit_type: "retail_pack", requires_deposit: false, base_price_try: 15.00,
    name: { tr: "0.5L Su Şişesi", en: "0.5L Water Bottle" } },
  { sku: "WTR-1L", size_liters: 1, unit_type: "retail_pack", requires_deposit: false, base_price_try: 20.00,
    name: { tr: "1L Su Şişesi", en: "1L Water Bottle" } },
  { sku: "WTR-1.5L", size_liters: 1.5, unit_type: "retail_pack", requires_deposit: false, base_price_try: 25.00,
    name: { tr: "1.5L Su Şişesi", en: "1.5L Water Bottle" } },
  { sku: "WTR-5L", size_liters: 5, unit_type: "retail_pack", requires_deposit: false, base_price_try: 60.00,
    name: { tr: "5L Su Bidonu", en: "5L Water Jug" } },
  { sku: "WTR-19L", size_liters: 19, unit_type: "refillable_jug", requires_deposit: true, base_price_try: 150.00,
    name: { tr: "19L Damacana (Değişim)", en: "19L Refillable Cooler Jug (Exchange)" } }
].freeze

PRODUCTS.each do |attrs|
  names = attrs.delete(:name)
  product = Product.find_or_initialize_by(sku: attrs[:sku])
  product.assign_attributes(attrs)
  product.save!
  names.each { |locale, name| Mobility.with_locale(locale) { product.update!(name: name) } }
end

puts "Seeded #{Product.count} products."

DELIVERY_ZONES = [
  { district: "lefkosa", delivery_days: %w[mon tue wed thu fri] },
  { district: "girne", delivery_days: %w[mon wed fri] },
  { district: "gazimagusa", delivery_days: %w[tue thu] },
  { district: "guzelyurt", delivery_days: %w[wed] },
  { district: "iskele", delivery_days: %w[tue thu] },
  { district: "lefke", delivery_days: %w[wed] }
].freeze

DELIVERY_ZONES.each do |attrs|
  DeliveryZone.find_or_initialize_by(district: attrs[:district])
              .tap { |zone| zone.assign_attributes(active: true, delivery_days: attrs[:delivery_days]) }
              .save!
end

puts "Seeded #{DeliveryZone.count} delivery zones."

staff_password = ENV.fetch("STAFF_SEED_PASSWORD", "changeme123")
staff_user = User.find_or_initialize_by(email_address: "staff@ozsu.example")
staff_user.password = staff_password
staff_user.password_confirmation = staff_password
staff_user.save!
puts "Seeded staff user (#{staff_user.email_address})."

water_quality_page = ContentPage.find_or_initialize_by(slug: "water-quality")
water_quality_page.save!
Mobility.with_locale(:tr) do
  water_quality_page.update!(
    title: "Su Kalitesi",
    body: <<~MARKDOWN
      KKTC'de ambalajlı kaynak suyu ve içme suyu üretimi, **"Ambalajlanmış Kaynak Suyu ve İçme Suyu Yasası"**
      kapsamında KKTC Sağlık Bakanlığı tarafından düzenlenir. Bakanlık, ambalajlı kaynak suyu, içme suyu ve
      su istasyonları için aylık kontrol sonuçlarını kendi web sitesinde yayımlar.

      **TODO (kurucu tarafından tamamlanmalı):** Şirketimizin Sağlık Bakanlığı ruhsat/tescil numarası ve
      güncel denetim sonuçları burada yayımlanacaktır. Gerçek belgeler ve referans numaraları eklenmeden
      bu sayfa yayına alınmamalıdır.

      Ayrıca TS 266 (içme suyu standardı) ve ISO 9001 / ISO 22000 / HACCP gibi kalite süreç sertifikaları,
      şirketimizin fiilen sahip olduğu belgeler doğrulandıktan sonra burada listelenecektir.
    MARKDOWN
  )
end
Mobility.with_locale(:en) do
  water_quality_page.update!(
    title: "Water Quality",
    body: <<~MARKDOWN
      Packaged spring water and drinking water production in TRNC is regulated by the TRNC Ministry of
      Health under the **"Packaged Spring Water and Drinking Water Law"**. The Ministry publishes monthly
      inspection results for packaged spring water, drinking water, and water stations on its own site.

      **TODO (founder to complete):** Our company's Ministry of Health registration/license number and
      current inspection results will be published here. Do not publish this page before the real
      documents and reference numbers are added.

      Quality-process certifications such as TS 266 (the Turkish drinking-water standard) and
      ISO 9001 / ISO 22000 / HACCP will be listed here once confirmed as marks the company actually holds.
    MARKDOWN
  )
end
puts "Seeded content page: #{water_quality_page.slug}."
