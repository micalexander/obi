require 'Thor'
require 'obi/Version'
require 'obi/Menu'

module Obi
	class Controller < Thor
		include Thor::Actions
		include Obi::Version

		# Handles the creation of the .obiconfig file
		desc "config", "Maintain configuration variables"
		def config
			if (!File.exist?( CONFIG_FILE_LOCATION ))
				File.open( CONFIG_FILE_LOCATION, 'w') do |file|
					file.puts VERSION
				end
			else
				menu = Obi::Menu.new
				menu.launch_menu!
			end
		end


	end
end
