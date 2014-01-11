require_relative 'newrelic_zfs/metric'
require_relative 'newrelic_zfs/processor'
require_relative 'newrelic_zfs/converter'

class Collector

  def initialize
    @blacklist = ['Altroot']
    @summary_metrics = ['UnhealthyCount', 'Cap', 'Size']
    @processor = Processor.new
    @converter = Converter.new
  end
  def collect_stats
    metrics = []
    first = true

    run_command.each_line do |line|
      if first
        @processor.process_header_line(line)
        first = false
      else
        metrics = metrics + @processor.line_to_metrics(line)
      end
    end

    metrics = metrics.find_all { |metric|
      !@blacklist.include?(metric.name)
    }

    #Convert the value first, otherwise adding won't work when calculating summary metrics
    metrics.each do |metric|
      metric.name = @converter.convert_name(metric)
      metric.value = @converter.convert_value(metric)
      metric.unit = @converter.convert_unit(metric)
    end

    get_summary_metrics(metrics).each do |metric|
      metric.name = @converter.convert_name(metric)
      metric.value = @converter.convert_value(metric)
      metric.unit = @converter.convert_unit(metric)
      metrics << metric
    end

    metrics
  end

  def get_summary_metrics(metrics)
    metrics_hash = {}
    metrics.each do |metric|
      if @summary_metrics.include?(metric.name)
        summary_metric = metrics_hash[metric.name]
        if summary_metric.nil?
          summary_metric = Metric.new
          summary_metric.name = metric.name
          summary_metric.unit = metric.unit
          metrics_hash[metric.name] = summary_metric
        end

        summary_metric.add_value(metric.value)
      end
    end

    metrics_hash.values
  end

  def run_command
    `zpool list`
  end
end