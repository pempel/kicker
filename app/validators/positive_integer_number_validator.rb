class PositiveIntegerNumberValidator < ActiveModel::Validations::NumericalityValidator
  def initialize(options = {})
    options.merge!(only_integer: true, greater_than: 0, allow_blank: true)
    super
  end
end
