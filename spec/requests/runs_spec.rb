describe RunsController, type: :request do
  let(:headers) { { "X-SCIR-AUTH" => 'SOME-TEST-KEY' } }
  let(:redis) { Redis.new }

  describe 'DELETE /runs/_clear' do
    it_behaves_like 'requires auth', :delete, '/runs/_clear'

    it 'clears all runs' do
      redis.rpush('test-run', ['foo_spec.rb', 'bar_spec.rb'])
      expect(redis.keys).to contain_exactly('test-run')

      delete '/runs/_clear', headers: headers

      expect(redis.keys).to be_empty
      expect(response.code).to eq('200')
    end
  end

  describe 'GET /runs' do
    it_behaves_like 'requires auth', :get, '/runs'

    it 'returns array of all run ids' do
      redis.rpush('test-run', ['foo_spec.rb', 'bar_spec.rb'])

      get '/runs', headers: headers

      expect(JSON.parse(response.body)['runs']).to contain_exactly('test-run')
      expect(response.code).to eq('200')
    end
  end

  describe 'POST /runs' do
    it_behaves_like 'requires auth',
      :post,
      '/runs',
      { run: { id: 'test-run', test_file_paths: ['foo_spec.rb', 'bar_spec.rb'] } }

    context 'when id and test_file_paths given' do
      it 'creates a run' do
        expect(redis.keys).to be_empty

        post '/runs',
          params: {
            run: {
              id: 'test-run',
              test_file_paths: ['foo_spec.rb', 'bar_spec.rb']
            }
          },
          headers: headers

        expect(redis.keys).to contain_exactly('test-run')
        expect(redis.lrange('test-run', 0, -1)).to contain_exactly(
          'foo_spec.rb', 'bar_spec.rb'
        )
        expect(response.code).to eq('204')
      end
    end

    context 'when no id given' do
      it 'returns an error' do
        expect(redis.keys).to be_empty

        post '/runs',
          params: {
            run: {
              test_file_paths: ['foo_spec.rb', 'bar_spec.rb']
            }
          },
          headers: headers

        expect(redis.keys).to be_empty
        expect(response.code).to eq('400')
      end
    end

    context 'when no test_file_paths given' do
      it 'returns an error' do
        expect(redis.keys).to be_empty

        post '/runs',
          params: {
            run: {
              id: 'test-run',
              test_file_paths: []
            }
          },
          headers: headers

        expect(redis.keys).to be_empty
        expect(response.code).to eq('400')

        post '/runs',
          params: {
            run: {
              id: 'test-run'
            }
          },
          headers: headers

        expect(redis.keys).to be_empty
        expect(response.code).to eq('400')
      end
    end
  end

  describe 'DELETE /runs/:id' do
    it_behaves_like 'requires auth', :delete, '/runs/1'

    context 'when an id is given' do
      it 'deletes specified run' do
        redis.rpush('test-run', ['foo_spec.rb', 'bar_spec.rb'])
        expect(redis.keys).to contain_exactly('test-run')

        delete '/runs/test-run', headers: headers

        expect(redis.keys).to be_empty
        expect(response.code).to eq('204')
      end
    end

    context 'when no valid id is given' do
      it 'returns an error' do
        redis.rpush('test-run', ['foo_spec.rb', 'bar_spec.rb'])
        expect(redis.keys).to contain_exactly('test-run')

        delete '/runs/fake-test-run', headers: headers

        expect(redis.keys).to contain_exactly('test-run')
        expect(response.code).to eq('400')
      end
    end

    context 'when no id is given' do
      it 'returns an error' do
        redis.rpush('test-run', ['foo_spec.rb', 'bar_spec.rb'])
        expect(redis.keys).to contain_exactly('test-run')

        delete '/runs', headers: headers

        expect(redis.keys).to contain_exactly('test-run')
        expect(response.code).to eq('400')
      end
    end
  end
end
