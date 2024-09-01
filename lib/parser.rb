require 'optparse'
require 'pathname'

module Stlet
	class Parser
		def initialize
			@options = {}
		end

		def opt_parser
			@opt_parser ||= OptionParser.new do | opts |
				opts.banner = 'Usage: stlet [options] template data-csv'
				opts.on '-nNAME', '--name=NAME', 'Use this as the basis for the name of the output files' do | output_file_name | @options[:outputfilename] = output_file_name end
				opts.on '-dDIR', '--destdir=DIR', 'Destination dir for the output files' do |dir| @options[:destdir] = Pathname.new(dir).expand_path end
				opts.on '-h', '--help', 'Prints this help' do puts opts; exit end
			end
		end

		def call(argv)
			args_arr = opt_parser.parse(argv)
			check_enough_args(args_arr)
			check_no_duplicate_dest_dir(@options)
			check_valid_path(args_arr[0])
			check_valid_path(args_arr[1])
			check_is_erb(args_arr[0])
			check_is_csv(args_arr[1])
			@options[:template] = Pathname.new(args_arr[0]).expand_path
			@options[:datacsv] = Pathname.new(args_arr[1]).expand_path
			@options[:destdir] = Pathname.pwd.expand_path unless @options.key?(:destdir)
			check_valid_dir(@options[:destdir])
			@options
		end

		def check_enough_args(args_arr)
			exit_not_enough_args if args_arr.length < 2
		end

		def check_valid_path(filename)
			exit_invalid_filename(filename) unless Pathname.new(filename).file?
		end

		def check_valid_dir(dir)
			exit_invalid_dir(dir) unless Pathname.new(dir).directory?
		end

		def check_is_csv(filename)
			path = Pathname.new(filename)
			exit_not_a_csv(path.to_s) unless path.extname.downcase == '.csv'
		end

		def check_is_erb(filename)
			path = Pathname.new(filename)
			exit_not_an_erb(path.to_s) unless path.extname.downcase == '.erb'
		end

		def check_no_duplicate_dest_dir(options)
			exit_duplicate_dest_dir if (options.key?(:destdir) && options.key?(:cloudfile))
		end

		def integer_test
			@integer_test ||= /^\s*\d+\s*$/
		end

		def pages_are_integers?(page_arr)
			page_arr.reject do | page |
				integer_test.match(page)
			end.empty?
		end

		def check_pagelist_are_integers(page_arr)
			exit_pagelist_not_integers unless pages_are_integers?(page_arr)
		end

		def exit_not_enough_args
			STDERR.puts 'stlet needs two arguments (in addition to any options)'
			STDERR.puts 'The first should be an erb template file'
			STDERR.puts 'The second is a csv containing tenant data'
			exit(65)
		end

		def exit_invalid_filename(filename)
			STDERR.puts 'You have passed a non-existent filename as an argument'
			STDERR.puts "#{filename} does not exist"
			exit(66)
		end

		def exit_invalid_dir(dir)
			STDERR.puts 'The destination directory should be a valid directory'
			STDERR.puts "#{dir} is not a valid directory"
			exit(67)
		end

		def exit_not_a_csv(filename)
			STDERR.puts 'The second argument should be a csv file containing tenant data'
			STDERR.puts "#{filename} is not a csv.  It should end in .csv"
			exit(68)
		end

		def exit_not_a_erb(filename)
			STDERR.puts 'The first argument should be a erb file containing the template'
			STDERR.puts "#{filename} is not a erb.  It should end in .erb"
			exit(68)
		end

		def exit_invalid_filename(filename)
			STDERR.puts 'The first argument should be an erb template file'
			STDERR.puts "#{filename} is not an erb file.  It should end in .erb"
			exit(69)
		end

		def exit_duplicate_dest_dir
			STDERR.puts 'The dest dir and cloudfile options both set the destination directory'
			STDERR.puts 'Please use just one of them to define the destination directory'
			exit(69)
		end

		def exit_pagelist_not_integers
			STDERR.puts 'The second argument onwards should be the list of pages to split after'
			STDERR.puts "They should all be integers but they weren't"
			exit(70)
		end

	end
	
end
