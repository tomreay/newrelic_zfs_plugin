require_relative '../lib/collector'

describe Collector do
  ZPOOL_HEADER = "NAME STAT1 \n"
  ZPOOL_NUMBER_ROW = "pool1 1.1%"

  describe 'collect_stats' do

    it 'Breaks the table up and returns one stat for each column per pool' do
      collector = Collector.new
      collector.stub(:run_command).and_return(ZPOOL_HEADER + ZPOOL_NUMBER_ROW)

      metrics = collector.collect_stats

      expect(metrics.length).to eq(1)
      expect(metrics[0].pool_name).to eq('pool1')
      expect(metrics[0].value).to eq(1.1)
      expect(metrics[0].unit).to eq('%')
    end

    it 'Converts ONLINE into 0' do
      collector = Collector.new
      collector.stub(:run_command).and_return(ZPOOL_HEADER + 'pool1 ONLINE')

      metrics = collector.collect_stats

      expect(metrics[0].value).to eq(0)
    end

    it 'Converts OFFLINE and DEGRADED into 1' do
      collector = Collector.new
      collector.stub(:run_command).and_return(ZPOOL_HEADER + "pool1 OFFLINE\npool2 DEGRADED\npool3 FAULTED")

      metrics = collector.collect_stats

      expect(metrics[0].value).to eq(1)
      expect(metrics[1].value).to eq(1)
      expect(metrics[2].value).to eq(1)
    end

    it 'Converts memory size units correctly' do
      collector = Collector.new
      collector.stub(:run_command).and_return(ZPOOL_HEADER + "pool1 1B\n" +
        "pool2 1K\n" +
        "pool3 1M\n" +
        "pool4 1G\n" +
        "pool5 1T\n" +
        "pool6 1P")

      metrics = collector.collect_stats

      expect(metrics[0].unit).to eq('bytes')
      expect(metrics[1].unit).to eq('kilobytes')
      expect(metrics[2].unit).to eq('megabytes')
      expect(metrics[3].unit).to eq('gigabytes')
      expect(metrics[4].unit).to eq('terabytes')
      expect(metrics[5].unit).to eq('petabytes')
    end

    it 'Collects summary metrics - summing' do
      collector = Collector.new
      collector.stub(:run_command).and_return("NAME HEALTH\npool1 OFFLINE\npool2 OFFLINE")

      metrics = collector.collect_stats

      expect(metrics[3].value).to eq(2)
    end
  end
end