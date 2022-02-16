# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  code       :string
#  price      :integer          default(0)
#  stock      :integer          default(0)
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord
  # save
  before_save :validate_product
  after_save :send_notification
  after_save :push_notification, if: :discount?

  # validation
  validates :title, presence: { message: "Es necesario definir un valor para el titulo"}
  validates :code, presence: { message: "Es necesario definir un valor para el código"}
  validates :code, uniqueness: true

  # validates :price, length: { minimum:3, maximum:10 }
  validates :price, length: { in: 3..10, message: "El precio se encuentra fuera de rango" }, if: :has_price?

  def total
    self.price / 100
  end

  def discount?
    self.total < 5
  end

  def has_price?
    !self.price.nil? && self.price > 0
  end

  private

  def validate_product
    puts "\n\n\n>>> Un nuevo producto será añadido al almacen!"
  end
  
  def send_notification
    puts "\n\n\n>>> Un nuevo producto fue añadido al almacen: #{self.title} - #{self.total} USD"
  end

  # Precio < 5
  def push_notification
    puts "\n\n\n>>> Un nuevo producto en descuento ya se encuentra disponible: #{self.title}"
  end
end
