describe ApplicationController, type: :request do
  it 'returns PONG' do
    get '/ping'
    expect(response.body).to eq('PONG')
    expect(response.code).to eq('200')
  end
end
