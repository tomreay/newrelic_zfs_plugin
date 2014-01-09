require_relative 'metric'

class Processor
  def process_header_line(line)
    @headers = []
    line.split(' ').each_with_index do |header, index|
      @headers[index] = header
    end
  end

  def line_to_metrics(line)
    pool_name
    metrics = []
    line.split(' ').each_with_index do |value, index|
      if @headers[index] == 'Name'
        pool_name = value
      else
        metric = Metric.new
        split = split_value_and_unit(value)
        metric.name = @headers[index]
        metric.value = split[0]
        metric.unit = split[1]
        metrics << metric
      end
    end

    metrics.each { |metric|
      metric.pool_name = pool_name
    }
  end

  def split_value_and_unit(text)
    match = /\d+\.?\d*/.match(value)
    #If numeric value
    if match
      value = match[0]
      unit = value.slice(value.length, text.length)
      [value, unit]
    else
      [text, nil]
    end
  end
end