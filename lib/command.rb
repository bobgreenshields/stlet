require 'open3'

module Stlet
	class Command
		def call(*args)
			output, status = Open3.capture2e(*args)
			return output, (status.exitstatus == 0)
		end
	end
end

