# spec/integration/meta_spec.rb

require 'swagger_helper'

describe 'SEMCON META API' do
	path '/api/meta' do
		get 'detailed container information' do
			tags 'Semantic information'
			produces 'plain/text'
			response '200', 'success' do
				before do
					Semantic.new(validation:"input").save
				end
				run_test!
			end
			response '404', 'not found' do
				run_test!
			end
		end

		post 'set container information' do
			tags 'Semantic information'
			consumes 'application/json'
			parameter name: :input, in: :body
			response '200', 'success' do
				let(:input) { { "init": file_fixture("init.trig").read } }
				run_test! do
					expect(Semantic.count).to eq(1)
					expect(Log.count).to eq(1)
				end
			end
			response '422', 'invalid' do
				let(:input) { { "init": "" } }
				run_test! do
					expect(Semantic.count).to eq(0)
					expect(Log.count).to eq(0)
				end
			end
		end
	end

	path '/api/meta/{detail}' do
		get 'specific container information' do
			tags 'Semantic information'
			produces 'application/json'
			parameter name: :detail, in: :path, type: :string,
				description: "'info' for general information, 'usage' for data usage policy, 'example' for examplary input data"
			response '200', 'success' do
				let(:detail) { 'info' }
				run_test!
			end
			response '200', 'success' do
				let(:detail) { 'usage' }
				run_test!
			end
			response '200', 'success' do
				let(:detail) { 'example' }
				run_test!
			end
			response '404', 'not found' do
				let(:detail) { 'invalid' }
				run_test!
			end
		end
	end
end