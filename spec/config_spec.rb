require_relative '../lib/newrelic_zfs/config.rb'

describe ZfsConfig do
  CONFIG_PATH = 'test_config_location'
  CONFIG_FILE_NAME = 'config.yml'
  CONFIG_FULL_PATH = "#{CONFIG_PATH}/#{CONFIG_FILE_NAME}"
  API_KEY = 'test_api_key'
  SERVER_NAME = 'test_server_instance'

  describe 'getConfigLocation' do
    it 'Should generate a file if a path that does not exist is given' do
      File.stub(:exist?).and_return(false)
      ZfsConfig.stub(:get_user_input).and_return('y')
      ZfsConfig.should_receive(:create_config).with(CONFIG_FULL_PATH).exactly(1).times

      returned = ZfsConfig.get_config_location(CONFIG_FULL_PATH)
      expect(returned).to eq(CONFIG_FULL_PATH)
    end

    it 'Should return the file path for a file that does exist' do
      File.stub(:exist?).and_return(true)

      returned = ZfsConfig.get_config_location(CONFIG_FULL_PATH)
      expect(returned).to eq(CONFIG_FULL_PATH)
    end

    it 'Should ask if the user wants to create a config file is no path is given, creating it if they say yes' do
      ZfsConfig.stub(:get_user_input).and_return('y', CONFIG_PATH)
      File.stub(:directory?).and_return(true)
      ZfsConfig.should_receive(:create_config).with(CONFIG_FULL_PATH).exactly(1).times.and_return(CONFIG_FULL_PATH)

      returned = ZfsConfig.get_config_location(nil)
      expect(returned).to eq(CONFIG_FULL_PATH)
    end

    it 'Should ask if the user wants to create a config file is no path is given, exiting it if they say no' do
      ZfsConfig.stub(:get_user_input).and_return('n')

      returned = ZfsConfig.get_config_location(nil)
      expect(returned).to eq(nil)
    end
  end

  describe 'create_config' do
    it 'Config file is created' do
      ZfsConfig.stub(:get_user_input).and_return(API_KEY, SERVER_NAME)
      File.stub(:open)

      ZfsConfig.create_config(CONFIG_FULL_PATH)
    end

    it 'If the user enters an empty API Key, an exception is thrown' do
      ZfsConfig.stub(:get_user_input).and_return('')

      expect{ZfsConfig.create_config(CONFIG_FULL_PATH)}.to raise_error
    end

    it 'If the user enters an empty server name, an exception is thrown' do
      ZfsConfig.stub(:get_user_input).and_return(API_KEY, '')

      expect{ ZfsConfig.create_config(CONFIG_FULL_PATH) }.to raise_error
    end
  end

  describe 'user_says_yes?' do
    it 'Input = y returns true' do
      ZfsConfig.stub(:get_user_input).and_return('y')

      expect(ZfsConfig.user_says_yes?).to be_true
    end

    it 'Input = n returns false' do
      ZfsConfig.stub(:get_user_input).and_return('n')

      expect(ZfsConfig.user_says_yes?).to be_false
    end

    it "Input = '' returns false" do
      ZfsConfig.stub(:get_user_input).and_return('')

      expect(ZfsConfig.user_says_yes?).to be_false
    end
  end

  describe 'get_file_path' do

    it 'When passed a directory, config.yml is appended to the end' do
      File.stub(:directory?).and_return(true)

      returned = ZfsConfig.get_file_path(CONFIG_PATH)

      expect(returned).to eq(CONFIG_FULL_PATH)
    end

    it 'When passed a file, its returned as is' do
      File.stub(:directory?).and_return(false)

      returned = ZfsConfig.get_file_path(CONFIG_FULL_PATH)

      expect(returned).to eq(CONFIG_FULL_PATH)
    end

    it 'When the file name has no extension, it is set to yml' do
      File.stub(:directory?).and_return(false)

      returned = ZfsConfig.get_file_path('file_name')

      expect(File.extname(returned)).to eq('.yml')
    end

    it 'When the file name has an extension that is not yml, it is left the same' do
      File.stub(:directory?).and_return(false)

      returned = ZfsConfig.get_file_path('file_name.txt')

      expect(File.extname(returned)).to eq('.txt')
    end
  end
end