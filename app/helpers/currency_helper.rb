module CurrencyHelper
  include ActionView::Helpers::NumberHelper

  def format_currency(amount, unit: "")
    number_to_currency(amount, unit: unit, precision: 2)
  end
end
