class Metric
  attr_accessor :pool_name
  attr_accessor :name
  attr_accessor :unit
  attr_reader :count
  attr_writer :aggregate_function

  def initialize
    @count = 0
    @value = 0
  end

  def is_summary_metric?
    !@aggregate_function.nil?
  end

  def add_value(value)
    if @aggregate_function.nil?
      @value = value
    else
      @value = @value + value rescue value
      @count = @count + 1
    end
  end

  def set_value(value)
    @value = value
  end

  def value
    @aggregate_function.nil? ? @value : @aggregate_function.call(@value, @count)
  end

  def raw_value
    @value
  end

  def newrelic_name
    if is_summary_metric?
      "ZPools/#{@name}"
    else
      "ZPools/#{@name}/#{@pool_name}"
    end
  end

  def self.mean(value, count)
    if value.nil? || count.nil?
      0
    elsif count == 0
      value
    else
      value.to_f / count
    end
  end

  def self.sum(value, count)
    value
  end
end