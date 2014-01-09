require_relative 'newrelic_zfs/metric'
require_relative 'newrelic_zfs/processor'
require_relative 'newrelic_zfs/converter'

class Collector
  @blacklist = ['Altroot']
  @summary_metrics = ['UnhealthCount', 'Cap']
  @processor = Processor.new
  @converter = Converter.new

  def collect_stats
    metrics = []
    first = false

    run_command.each_line do |line|
      if first
        @processor.process_header_line(line)
      else
        metrics << @processor.line_to_metrics(line)
      end
    end

    metrics = metrics.find_all { |metric|
      !@blacklist.include?(metric.name)
    }

    #Convert the value first, otherwise adding won't work when calculating summary metrics
    metrics.each do |metric|
      metric.value = @converter.convert_value(metric)
    end

    metrics = metrics + get_summary_metrics(metrics)

    metrics.each do |metric|
      metric.name = @converter.convert_name(metric)
      metric.unit = @converter.convert_unit(metric)
    end

    metrics
  end

  def get_summary_metrics(metrics)
    metrics_hash = {}
    @summary_metrics.each do |summary_metric|
      metric = Metric.new
      metric.name = summary_metric
      metrics_hash << {summary_metric => metric}
    end

    metrics.each do |metric|
      summary_metric = metrics_hash[metric.name]
      unless summary_metric.nil?
        summary_metric.add_value(metric.value)
      end
    end

    metrics_hash.values
  end

  def run_command
    `zpool list`
  end
end