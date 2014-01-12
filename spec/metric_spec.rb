require_relative '../lib/newrelic_zfs/metric'

describe Metric do
  describe 'add_value' do
    it 'Adds the value and updates the count for aggregate metrics' do
      metric = Metric.new
      metric.aggregate_function = Metric.method(:sum)
      metric.add_value(1)

      expect(metric.value).to eq(1)
      expect(metric.count).to eq(1)
    end

    it 'Calculates sum metrics correctly' do
      metric = Metric.new
      metric.aggregate_function = Metric.method(:sum)

      metric.add_value(1)
      metric.add_value(2)

      expect(metric.value).to eq(3)
    end

    it 'Calculates mean metrics correctly' do
      metric = Metric.new
      metric.aggregate_function = Metric.method(:mean)
      metric.add_value(1)
      metric.add_value(2)

      expect(metric.value).to eq(1.5)
    end

    it 'Calculates newrelic name correctly for normal metrics' do
      metric = Metric.new
      metric.pool_name = 'pool1'
      metric.name = 'stat1'

      name = metric.newrelic_name

      expect(name).to eq('ZPools/stat1/pool1')
    end

    it 'Calculates newrelic name correctly for summary metrics' do
      metric = Metric.new
      metric.name = 'stat1'
      metric.aggregate_function = Metric.method(:sum)

      name = metric.newrelic_name

      expect(name).to eq('ZPools/stat1')
    end
  end
end