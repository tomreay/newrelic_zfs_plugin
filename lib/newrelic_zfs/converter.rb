class Converter
  def initialize
    @name_conversions = { 'health' => 'UnhealthyCount' }
    @value_conversions = { 'online' => 0}
    @unit_conversions = { 'b' => 'bytes', 'k' => 'kilobytes', 'm' => 'megabytes', 'g' => 'gigabytes', 't' => 'terabytes', 'p' => 'petabytes'}
    @last_seen_unit = {}
  end

  def convert_name(metric)
    _do_convert(metric.name, @name_conversions)
  end

  def convert_value(metric)
    converted = _do_convert(metric.value, @value_conversions)
    Integer(converted) rescue Float(converted) rescue 1
  end

  def convert_unit(metric)
    converted = _do_convert(metric.unit, @unit_conversions)

    if converted.nil?
      converted = _do_convert(metric.name, @last_seen_unit)
    else
      @last_seen_unit[metric.name] = converted
    end

    converted
  end

  def _do_convert(value, conversion_hash)
    value = value.nil? ? nil : value.downcase
    converted = conversion_hash[value]

    converted.nil? ? value : converted
  end
end