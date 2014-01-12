class Converter
  def initialize
    @name_conversions = { :health => 'UnhealthyCount', :cap => 'Capacity'}
    @value_conversions = { :online => 0, :- => 0}
    @unit_conversions = { :b => 'bytes', :k => 'kilobytes', :m => 'megabytes',
                          :g => 'gigabytes', :t => 'terabytes', :p => 'petabytes'}
    @last_seen_unit = {}
  end

  def convert_name(metric)
    _do_convert(metric.name, @name_conversions)
  end

  def convert_value(metric)
    converted = _do_convert(metric.raw_value, @value_conversions)
    Float(converted) rescue 1
  end

  def convert_unit(metric)
    converted = _do_convert(metric.unit, @unit_conversions)

    if converted.nil?
      converted = @last_seen_unit[metric.name]
    end

    if converted.nil?
      converted = 'Value'
    end

    @last_seen_unit[metric.name] = converted

    converted
  end

  def _do_convert(value, conversion_hash)
    symbol = value.nil? ? nil : value.downcase.to_sym rescue value
    converted = conversion_hash[symbol]

    converted.nil? ? value : converted
  end
end