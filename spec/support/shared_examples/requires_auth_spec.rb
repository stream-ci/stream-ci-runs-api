shared_examples 'requires auth' do |method, path, params|
  let(:method) { method }
  let(:path) { path }
  let(:params) { params }

  before { send(method, path, params: params, headers: headers) }

  describe 'without auth header', type: :request do
    let(:headers) { {} }

    it 'returns 401' do
      expect(response.code).to eq('401')
    end
  end

  describe 'with invalid auth header', type: :request do
    let(:headers) { { "X-SCIR-AUTH" => 'SOME-FAKE-TEST-KEY' } }

    it 'does not return 401' do
      expect(response.code).to eq('401')
    end
  end

  describe 'with auth header', type: :request do
    let(:headers) { { "X-SCIR-AUTH" => 'SOME-TEST-KEY' } }

    it 'does not return 401' do
      expect(response.code).not_to eq('401')
    end
  end
end
