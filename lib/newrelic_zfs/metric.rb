class Metric
  attr_accessor :pool_name
  attr_accessor :name
  attr_accessor :value
  attr_accessor :unit

  def is_summary_metric?
    return @pool_name.nil?
  end

  def add_value(value)
    @value = @value + value
  end

  def newrelic_name
    if is_summary_metric?
      "ZPools/#{@name}"
    else
      "ZPools/#{@name}/#{pool_name}"
    end
  end
end