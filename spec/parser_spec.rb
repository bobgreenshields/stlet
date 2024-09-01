require_relative '../lib/parser'

include Stlet

describe Parser do
	let(:parser) { Parser.new }

	describe '#check_enough_args' do
		context 'with less than 2 arguments' do
			let(:args) { ['filename'] }
			it 'calls #exit_not_enough_args' do
				expect(parser).to receive(:exit_not_enough_args)
				parser.check_enough_args(args)
			end
		end
		context 'with 2 or more args' do
			let(:args) { ['filename', '5'] }
			it 'does not call #exit_not_enough_args' do
				expect(parser).not_to receive(:exit_not_enough_args)
				parser.check_enough_args(args)
			end
		end
	end
			
	describe '#check_is_csv' do
		context 'when the second arg does not end in .csv' do
			let(:args) { 'filename.txt' }
			it 'calls #exit_not_a_csv' do
				expect(parser).to receive(:exit_not_a_csv)
				parser.check_is_csv(args)
			end
		end
		context 'when the second arg does end in .csv' do
			let(:args) { 'filename.csv' }
			it 'does not call #exit_not_a_csv' do
				expect(parser).not_to receive(:exit_not_a_csv)
				parser.check_is_csv(args)
			end
		end
	end
			
	describe '#check_is_erb' do
		context 'when the first arg does not end in .erb' do
			let(:args) { 'filename.txt' }
			it 'calls #exit_not_an_erb' do
				expect(parser).to receive(:exit_not_an_erb)
				parser.check_is_erb(args)
			end
		end
		context 'when the first arg does end in .erb' do
			let(:args) { 'filename.erb' }
			it 'does not call #exit_not_an_erb' do
				expect(parser).not_to receive(:exit_not_an_erb)
				parser.check_is_erb(args)
			end
		end
	end
			
	describe '#call' do
		context 'with option of -d' do
			let(:args) { [ '-d', 'outputdir', 'template.erb', 'tenants.csv'] }
			it 'returns a hash with the correct keys' do
				allow(parser).to receive(:check_valid_path).and_return(true)
				allow(parser).to receive(:check_valid_dir).and_return(true)
				result = parser.call(args)
				expect(result[:template].to_s).to eql (Pathname.pwd + 'template.erb').to_s
			end
		end
		# context 'with a filename as the first arg' do
		# 	let(:args) { ['filename.pdf', '-ca', ' 2', '5'] }
		# 	it 'returns the correct pathname in the :source key' do
		# 		allow(parser).to receive(:check_valid_path).and_return(true)
		# 		result = parser.call(args)
		# 		expect(result[:source].to_s).to eql (Pathname.pwd + 'filename.pdf').to_s
		# 	end
		# end
		# context 'with integers as the last args' do
		# 	let(:args) { ['filename.pdf', '-ca', ' 2', '5'] }
		# 	it 'returns an array of integers in the :pagelist key' do
		# 		allow(parser).to receive(:check_valid_path).and_return(true)
		# 		result = parser.call(args)
		# 		expect(result[:pagelist]).to eql [2,5]
		# 	end
		# end
		# context 'with out of order integers as the last args' do
		# 	let(:args) { ['filename.pdf', '-ca', ' 2', '11', '5'] }
		# 	it 'returns a sorted array of integers in the :pagelist key' do
		# 		allow(parser).to receive(:check_valid_path).and_return(true)
		# 		result = parser.call(args)
		# 		expect(result[:pagelist]).to eql [2,5,11]
		# 	end
		# end
		# context 'with -d and dest dir' do
		# 	let(:args) { ['-d', 'dest/dir', 'filename.pdf', '-a', ' 2', '11', '5'] }
		# 	it 'it returns a Pathname' do
		# 		allow(parser).to receive(:check_valid_dir)
		# 		allow(parser).to receive(:check_valid_path)
		# 		expect(parser.call(args)[:destdir]).to be_a(Pathname)
		# 	end
		# 	it 'it places the dest dir under the :destdir key' do
		# 		allow(parser).to receive(:check_valid_dir)
		# 		allow(parser).to receive(:check_valid_path)
		# 		expect(parser.call(args)[:destdir]).to eql (Pathname.pwd + 'dest/dir')
		# 	end
		# end
		# context 'with --destdir=dest/dir' do
		# 	let(:args) { ['--destdir=dest/dir', 'filename.pdf', '-a', ' 2', '11', '5'] }
		# 	it 'it places the dest dir under the :destdir key' do
		# 		allow(parser).to receive(:check_valid_dir)
		# 		allow(parser).to receive(:check_valid_path)
		# 		expect(parser.call(args)[:destdir]).to eql (Pathname.pwd + 'dest/dir')
		# 	end
		# end
		# context 'with cloudfile and destdir options set' do
		# 	let(:args) { ['--destdir=dest/dir', '-ca', 'filename.pdf', ' 2', '11', '5'] }
		# 	it 'it exits with an error' do
		# 		allow(parser).to receive(:check_valid_dir)
		# 		allow(parser).to receive(:check_valid_path)
		# 		expect(parser).to receive(:exit_duplicate_dest_dir)
		# 		parser.call(args)
		# 	end
		# end

	end
	
end
