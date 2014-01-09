module ZFSTools
  class Stat
    attr_reader :pool_name
    attr_reader :name
    attr_reader :unit
    attr_reader :value

    def initialize(pool_name, name, unit, value)
      @pool_name = pool_name
      @name = name
      @unit = unit
      @value = value
    end
  end

  class Pool
    BLACK_LIST = ['Altroot']

    attr_accessor :name
    attr_reader :values

    def initialize()
      @values = {}
    end

    def add_value(heading, value)
      if !BLACK_LIST.include?(heading)
        @values.merge!({ heading => value })
      end
    end
  end

  class Converter
    UNITS = { 'B' => 'bytes', 'K' => 'kilobytes', 'M' => 'megabytes', 'G' => 'gigabytes', 'T' => 'terabytes', 'P' => 'petabytes'}
    HEADINGS = { 'Health' => 'UnhealthyCount' }

    def convert(heading, value)
      values = _split(value)
      return [ _convert(heading, HEADINGS), _convert_d(values[1], UNITS, 'Value'), values[0] ]
    end

    def _split(value)
      match = /\d+\.?\d*/.match(value)
      #If numeric value
      if match
        numeric_part = match[0]
        unit = value.slice(numeric_part.length, value.length)
        return [numeric_part, unit]
      elsif value == 'ONLINE'
        return [0, '']
      else
        return [1, '']
      end
    end

    def _convert_d(value, hash, default)
      converted = _convert(value, hash)

      if converted.nil?
        converted = default
      end

      return converted
    end

    def _convert(value, hash)
      converted = hash[value]

      #If the converted value is null, use the original unit
      if converted.nil?
        converted = value
      end

      return converted
    end
  end

  class Collector
    CONVERTER = Converter.new
    SUMMARY_METRICS = ['Unhealthy', 'Capacity']

    def collect_stats()
      first = true
      headings = {}
      pools = []

      `zpool list`.each_line do |line|
        #File.open('/Users/tomreay/Documents/workspaceWebApps/newrelic-zfs/list.txt').each_line do |line|
        pool = Pool.new
        line.split(' ').each_with_index do |token, index|
          if first
            headings.merge!({ index => token.capitalize})
          else
            if headings[index] == 'Name'
              pool.name = token
            else
              pool.add_value(headings[index], token)
            end
          end
        end
        first = false
        pools << pool
      end

      pools.each do |pool|
        pool.values.each do |heading, value|
          converted = CONVERTER.convert(heading, value)
          stat = Stat.new(pool.name, converted[0], converted[1], converted[2])
          stats << stat
        end
      end

      return stats
    end
  end
end