class Converter
  @name_conversions = { 'Health' => 'UnhealthyCount' }
  @value_conversions = { 'ONLINE' => 0}
  @unit_conversions = { 'B' => 'bytes', 'K' => 'kilobytes', 'M' => 'megabytes', 'G' => 'gigabytes', 'T' => 'terabytes', 'P' => 'petabytes'}
  @last_seen_unit = {}

  def convert_name(metric)
    _do_convert(metric.name, @name_conversions)
  end

  def convert_value(metric)
    _do_convert_with_default(metric.value, @value_conversions, '1')
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

  def _do_convert_with_default(value, conversion_hash, default)
    converted = _do_convert(value, conversion_hash)

    converted.nil? ? default : converted
  end

  def _do_convert(value, conversion_hash)
    converted = conversion_hash[value]

    converted.nil? ? value : converted
  end
end