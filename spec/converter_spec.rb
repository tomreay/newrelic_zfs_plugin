require_relative '../lib/newrelic_zfs/converter'
require_relative '../lib/newrelic_zfs/metric'

describe Converter do

  describe '_do_convert' do
    it 'Converts - into 0' do
      converter = Converter.new
      metric = Metric.new
      metric.add_value '-'

      converted = converter.convert_value(metric)

      expect(converted).to eq(0)
    end

    it 'Converts ONLINE into 0' do
      converter = Converter.new
      metric = Metric.new
      metric.add_value 'ONLINE'

      converted = converter.convert_value(metric)

      expect(converted).to eq(0)
    end

    it 'Converts DEGRADED into 1' do
      converter = Converter.new
      metric = Metric.new
      metric.add_value 'DEGRADED'

      converted = converter.convert_value(metric)

      expect(converted).to eq(1)
    end

    it "Doesn't alter floats" do
      converter = Converter.new
      metric = Metric.new
      metric.add_value 1.5

      converted = converter.convert_value(metric)

      expect(converted).to eq(1.5)
    end
  end
end