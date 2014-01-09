require_relative '../lib/newrelic_zfs/collector'

describe Collector do
  describe 'collect_stats' do
    it 'Breaks the table up and returns one stat for each column per pool' do
      Collector.stub(:run_command).and_return("NAME STAT1\npool1 1%")

      collector = Collector.new
      metrics = collector.collect_stats

      expect(metrics.length).to eq(1)
      expect(metrics[0].pool_name).to eq('pool1')
      expect(metrics[0].value).to eq(1)
      expect(metrics[0].unit).to eq('%')
    end
  end
end