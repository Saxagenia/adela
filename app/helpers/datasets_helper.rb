module DatasetsHelper
  def accrual_periodicity_translate(accrual_periodicity)
    ISO8601_DEFAULTS['accrual_periodicity'].invert[accrual_periodicity]
  end

  def validated_distributions?(dataset)
    dataset.distributions.select(&:validated?).present?
  end

  def published_distributions?(dataset)
    dataset.distributions.select(&:published?).present?
  end

  def documented_distributions(dataset)
    dataset.distributions.select { |d| d.published? || d.validated? }
  end
end