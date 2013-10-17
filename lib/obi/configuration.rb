require 'yaml'

module Obi
	class Configuration

		@config_settings = YAML.load_file(CONFIG_FILE_LOCATION) unless defined? @config_settings

		# get config settings from config file
		def self.settings
			@config_settings
		end


		# set config settings from config file
		def self.settings=(settings)
			@config_settings = YAML.load_file(settings)
			return @config_settings
		end


		# update config variable values
		def update_config_setting(setting_variable, setting_value=nil)
			File.open(CONFIG_FILE_LOCATION, 'r+') do |file|
				file.each_line do |line|
					if line =~ /#{setting_variable}/
						if line =~ /(local_settings|staging_settings|production_settings)/
							setting = server_toggle(line.scan(/[^:]*$/)[0].strip)
							setting_value = setting
						end
						obi_config = File.read(CONFIG_FILE_LOCATION)
						obi_config.gsub!( /#{Regexp.escape(line)}/, "#{setting_variable}: #{setting_value}\n")
						File.open(CONFIG_FILE_LOCATION, "w") {|file| file.puts obi_config}
					end
				end
			end
		end

		# toggle server settings
		def server_toggle(setting)
			possible_settings = ['enabled', 'wp-enabled', 'disabled']
			if possible_settings.include?(setting)
				case setting
				when 'enabled'
					return 'wp-enabled'
				when 'wp-enabled'
					return 'disabled'
				else
					return 'enabled'
				end
			end
		end
	end
end
