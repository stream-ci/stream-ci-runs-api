# GET /runs/:run_id/tests/pop(.:format) tests#pop
# GET /runs/:run_id/tests(.:format) tests#index

describe TestsController, type: :request do
  let(:headers) { { "X-SCIR-AUTH" => 'SOME-TEST-KEY' } }
  let(:redis) { Redis.new }

  describe 'GET /runs/:run_id/tests' do
    it_behaves_like 'requires auth', :get, '/runs/1/tests'

    context 'when a valid id is given' do
      it 'returns array of test file paths' do
        redis.rpush('test-run', ['foo_spec.rb', 'bar_spec.rb'])
        expect(redis.keys).to contain_exactly('test-run')

        get '/runs/test-run/tests', headers: headers

        expect(JSON.parse(response.body)['tests']).to contain_exactly(
          'foo_spec.rb', 'bar_spec.rb'
        )
        expect(response.code).to eq('200')
      end
    end

    context 'when no valid id is given' do
      it 'returns an error' do
        redis.rpush('test-run', ['foo_spec.rb', 'bar_spec.rb'])
        expect(redis.keys).to contain_exactly('test-run')

        get '/runs/fake-test-run/tests', headers: headers

        expect(response.code).to eq('404')
        expect(response.body).to eq('Not Found')
      end
    end
  end

  describe 'GET /runs/:run_id/tests/pop' do
    it_behaves_like 'requires auth', :get, '/runs/1/tests/pop'

    context 'when a valid id is given' do
      context 'when a run has one test' do
        before { redis.rpush('test-run', ['foo_spec.rb']) }

        context 'when no count param is given' do
          it 'returns array of 1 test file path' do
            get '/runs/test-run/tests/pop', headers: headers

            expect(JSON.parse(response.body)['tests']).to contain_exactly(
              'foo_spec.rb'
            )
            expect(response.code).to eq('200')

            get '/runs/test-run/tests/pop', headers: headers

            expect(response.body).to eq('Not Found')
            expect(response.code).to eq('404')
          end
        end

        context 'when a count param of 0 is given' do
          it 'returns array of 1 test file path' do
            get '/runs/test-run/tests/pop', params: { count: 0 }, headers: headers

            expect(JSON.parse(response.body)['tests']).to contain_exactly(
              'foo_spec.rb'
            )
            expect(response.code).to eq('200')

            get '/runs/test-run/tests/pop', params: { count: 0 }, headers: headers

            expect(response.body).to eq('Not Found')
            expect(response.code).to eq('404')
          end
        end

        context 'when a count param of 1 is given' do
          it 'returns array of 1 test file path' do
            get '/runs/test-run/tests/pop', params: { count: 1 }, headers: headers

            expect(JSON.parse(response.body)['tests']).to contain_exactly(
              'foo_spec.rb'
            )
            expect(response.code).to eq('200')

            get '/runs/test-run/tests/pop', params: { count: 1 }, headers: headers

            expect(response.body).to eq('Not Found')
            expect(response.code).to eq('404')
          end
        end

        context 'when a count param of 2 is given' do
          it 'returns array of 1 test file path' do
            get '/runs/test-run/tests/pop', params: { count: 2 }, headers: headers

            expect(JSON.parse(response.body)['tests']).to contain_exactly(
              'foo_spec.rb'
            )
            expect(response.code).to eq('200')

            get '/runs/test-run/tests/pop', params: { count: 2 }, headers: headers

            expect(response.body).to eq('Not Found')
            expect(response.code).to eq('404')
          end
        end
      end

      context 'when a run has two tests' do
        before { redis.rpush('test-run', ['foo_spec.rb', 'bar_spec.rb']) }

        context 'when a count param of 1 is given' do
          it 'returns array of 1 test file path' do
            get '/runs/test-run/tests/pop', params: { count: 1 }, headers: headers

            expect(JSON.parse(response.body)['tests']).to contain_exactly(
              'foo_spec.rb'
            )
            expect(response.code).to eq('200')

            get '/runs/test-run/tests/pop', params: { count: 1 }, headers: headers

            expect(JSON.parse(response.body)['tests']).to contain_exactly(
              'bar_spec.rb'
            )
            expect(response.code).to eq('200')

            get '/runs/test-run/tests/pop', params: { count: 1 }, headers: headers

            expect(response.body).to eq('Not Found')
            expect(response.code).to eq('404')
          end
        end

        context 'when a count param of 2 is given' do
          it 'returns array of 2 test file paths' do
            get '/runs/test-run/tests/pop', params: { count: 2 }, headers: headers

            expect(JSON.parse(response.body)['tests']).to contain_exactly(
              'foo_spec.rb', 'bar_spec.rb'
            )
            expect(response.code).to eq('200')

            get '/runs/test-run/tests/pop', params: { count: 2 }, headers: headers

            expect(response.body).to eq('Not Found')
            expect(response.code).to eq('404')
          end
        end

        context 'when a count param of 3 is given' do
          it 'returns array of 2 test file paths' do
            get '/runs/test-run/tests/pop', params: { count: 3 }, headers: headers

            expect(JSON.parse(response.body)['tests']).to contain_exactly(
              'foo_spec.rb', 'bar_spec.rb'
            )
            expect(response.code).to eq('200')

            get '/runs/test-run/tests/pop', params: { count: 3 }, headers: headers

            expect(response.body).to eq('Not Found')
            expect(response.code).to eq('404')
          end
        end
      end
    end

    context 'when no valid id is given' do
      it 'returns an error' do
        redis.rpush('test-run', ['foo_spec.rb', 'bar_spec.rb'])
        expect(redis.keys).to contain_exactly('test-run')

        get '/runs/fake-test-run/tests/pop', headers: headers

        expect(response.code).to eq('404')
        expect(response.body).to eq('Not Found')
      end
    end
  end
end
