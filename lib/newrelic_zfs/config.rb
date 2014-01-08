module ZfsConfig
  def self.get_config_location(config_file_location)
    if config_file_location.nil?
      print "No config file argument given, if you have already generated a config file please rerun using:\n" +
      "\n" +
      "newrelic_zfs full/path/to/file \n"+
      "\n" +
      'Or, create a config file now? [y/n]: '
      if user_says_yes?
        print 'Where should the file be created? '
        file_path = get_user_input
        create_config(File.join(file_path, 'config.yml'))

        config_file_location = get_file_path(file_path)
      end
    elsif !File.exist?(config_file_location)
      print 'The specified config file does not exist, do you want to create it now? [y/n]: '
      if user_says_yes?
        create_config(config_file_location)
      else
        config_file_location = nil
      end
    end

    return config_file_location
  end

  def self.create_config(config_file_name)
    puts "Writing file #{config_file_name}"
    print 'Please enter your API key: '
    api_key = get_user_input
    raise 'API Key must be non-empty' unless !api_key.nil? && !api_key.empty?

    print 'Please enter a name for this server: '
    server_name = get_user_input
    raise 'Server name must be non-empty' unless !server_name.nil? && !server_name.empty?

    File.open(config_file_name, 'w') do |f|
      f.write ERB.new(
                  "newrelic: \n" +
                      "  license_key: '<%= api_key %>' \n" +
                      "agents:\n" +
                      "  zfs:\n" +
                      "    instance_name: '<%= server_name %>'\n" +
                      "    print_metrics: false").result(binding)
    end
    puts 'Config file written, starting newrelic_zfs agent'
  end

  def self.get_file_path(file_path)
    if File.directory?(file_path)
      file_path = File.join(file_path, 'config.yml')
    end

    if File.extname(file_path).empty?
      file_path = file_path + '.yml'
    end

    return file_path
  end

  def self.user_says_yes?()
    return get_user_input == 'y'
  end

  def self.get_user_input()
    return $stdin.gets.chomp
  end
end

