require_relative 'newrelic_zfs/metric'
require_relative 'newrelic_zfs/processor'
require_relative 'newrelic_zfs/converter'

class Collector

  def initialize
    @blacklist = ['Altroot']
    @summary_metrics = { 'UnhealthyCount' => Metric.method(:sum), 'Capacity' => Metric.method(:mean),
                         'Size' => Metric.method(:sum) }
    @processor = Processor.new
    @converter = Converter.new
  end
  def collect_stats
    metrics = []
    first = true

    run_command.each_line do |line|
      if first
        puts 'Processing as a header line'
        puts line
        @processor.process_header_line(line)
        first = false
      else
        puts 'Processing as a metric line'
        puts line
        metrics = metrics + @processor.line_to_metrics(line)
      end
    end

    puts 'Filtering out blacklist metrics'
    metrics = metrics.find_all { |metric|
      !@blacklist.include?(metric.name)
    }

    #Convert the value first, otherwise adding won't work when calculating summary metrics
    puts 'Starting to convert metrics'
    metrics = convert_metrics(metrics)
    puts 'Finished converting metrics'
    puts 'Starting to calculate and convert summary metrics'
    metrics = metrics + convert_metrics(get_summary_metrics(metrics))
    puts 'Finished calculating and converting summary metrics'

    metrics
  end

  def get_summary_metrics(metrics)
    puts 'Started to calculate summary metrics'
    metrics_hash = {}
    metrics.each do |metric|
      puts "Processing metric #{metric.name}"
      if @summary_metrics.has_key?(metric.name)
        puts 'Metric is in summmary metrics list, processing it'
        summary_metric = metrics_hash[metric.name]
        if summary_metric.nil?
          puts 'No previous summary metric existed, creating a new one'
          summary_metric = Metric.new
          summary_metric.name = metric.name
          summary_metric.unit = metric.unit
          summary_metric.aggregate_function = @summary_metrics[metric.name]
          metrics_hash[metric.name] = summary_metric
        end

        puts "Adding value #{metric.value} to summary metric #{summary_metric.name}"
        summary_metric.add_value(metric.value)
      end
    end

    puts 'Finished calculating summary metrics'
    metrics_hash.values
  end

  def convert_metrics(metrics)
    metrics.each do |metric|
      puts "Converting metric name: #{metric.name}"
      metric.name = @converter.convert_name(metric)
      puts "Metric name is now: #{metric.name}"
      puts "Converting metric value #{metric.value}"
      metric.set_value @converter.convert_value(metric)
      puts "Value is now: #{metric.value}"
      puts "Converting metric unit: #{metric.unit}"
      metric.unit = @converter.convert_unit(metric)
      puts "Unit is now: #{metric.unit}"
    end
  end

  def run_command
    `zpool list`
  end
end