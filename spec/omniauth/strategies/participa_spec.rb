require 'spec_helper'

describe OmniAuth::Strategies::Participa do
  let(:request) { double('Request', params: {}, cookies: {}, env: {}) }
  let(:app) { -> {[200, {}, ['Participa']]} }
  let(:raw_info) {
    {'id' => 'uid', 'admin' => true, 'email' => 'jane-doe@example.com', 'username' => 'jane-doe', 'full_name' => 'Jane Doe'}
  }

  subject do
    OmniAuth::Strategies::Participa.new(app, 'appid', 'secret', @options || {}).tap do |strategy|
      allow(strategy).to receive(:request) {
        request
      }
    end
  end

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  describe '#client_options' do
    it 'has correct authorize_url' do
      expect(subject.client.options[:authorize_url]).to eq('/oauth/authorize')
    end

    it 'has correct token_url' do
      expect(subject.client.options[:token_url]).to eq('/oauth/token')
    end

    it 'has correct endpoint_url' do
      expect(subject.client.options[:endpoint_url]).to eq('/api/v2/users/me')
    end

    describe 'overrides' do
      it 'should allow overriding the site' do
        @options = { client_options: {'site' => 'https://example.com'} }
        expect(subject.client.site).to eq('https://example.com')
      end

      it 'should allow overriding the authorize_url' do
        @options = { client_options: {'authorize_url' => 'https://example.com/oauth/authorize'} }
        expect(subject.client.options[:authorize_url]).to eq('https://example.com/oauth/authorize')
      end

      it 'should allow overriding the token_url' do
        @options = { client_options: {'token_url' => 'https://example.com/oauth/token'} }
        expect(subject.client.options[:token_url]).to eq('https://example.com/oauth/token')
      end

      it 'should allow overriding the endpoint_url' do
        @options = { client_options: {'endpoint_url' => 'https://example.com/api/v1/users/show'} }
        expect(subject.client.options[:endpoint_url]).to eq('https://example.com/api/v1/users/show')
      end
    end
  end

  describe '#authorize_options' do
    [:redirect_uri, :scope].each do |k|
      it "should support #{k}" do
        @options = { k => 'someval' }
        expect(subject.authorize_params[k.to_s]).to eq('someval')
      end
    end

    describe 'redirect_uri' do
      it 'should default to nil' do
        @options = {}
        expect(subject.authorize_params['redirect_uri']).to eq(nil)
      end

      it 'should set the redirect_uri parameter if present' do
        @options = { redirect_uri: 'https://example.com/auth/participa/callback' }
        expect(subject.authorize_params['redirect_uri']).to eq('https://example.com/auth/participa/callback')
      end
    end

    describe 'scope' do
       it 'should set default scope to public' do
         expect(subject.authorize_params['scope']).to eq('public')
       end

       it 'should join scopes' do
         @options = { scope: 'public,write' }
         expect(subject.authorize_params['scope']).to eq('public write')
       end

       it 'should support space delimited scopes' do
         @options = { scope: 'public write' }
         expect(subject.authorize_params['scope']).to eq('public write')
       end
    end
  end

  describe '#callback_path' do
    it 'has the correct default callback path' do
      expect(subject.callback_path).to eq('/auth/participa/callback')
    end

    it 'should set the callback_path parameter if present' do
      @options = { callback_path: '/auth/foo/callback' }
      expect(subject.callback_path).to eq('/auth/foo/callback')
    end
  end

  describe '#callback_url' do
    it 'should return the redirect_uri parameter if present' do
      @options = { redirect_uri: 'https://example.com/auth/foo/callback' }
      expect(subject.callback_url).to eq('https://example.com/auth/foo/callback')
    end
  end

  describe '#raw_info' do
    before do
      access_token = double('access_token')
      response = double('response', parsed: { foo: 'bar' })

      expect(access_token).to receive(:get).with('/api/v2/users/me').and_return(response)
      allow(subject).to receive(:access_token) { access_token }
    end

    it 'returns parsed response from access token' do
      expect(subject.raw_info).to eq({ foo: 'bar'})
    end
  end

  describe '#uid' do
    it 'should return the user id' do
      allow(subject).to receive(:raw_info).and_return(raw_info)
      expect(subject.uid).to eq(raw_info['id'])
    end
  end

  describe '#info' do
    before do
      allow(subject).to receive(:raw_info).and_return(raw_info)
    end

    it 'should include the user email' do
      expect(subject.info[:email]).to eq(raw_info['email'])
    end

    it 'should include the user full name' do
      expect(subject.info[:name]).to eq(raw_info['full_name'])
    end

    it 'should include the username' do
      expect(subject.info[:username]).to eq(raw_info['username'])
    end

    it 'should include the user admin flag' do
      expect(subject.info[:admin]).to eq(raw_info['admin'])
    end
  end

  describe '#extra' do
    before do
      allow(subject).to receive(:raw_info).and_return(raw_info)
    end

    context "when skip info is true" do
      before { subject.options.skip_info = true }

      it 'should not include raw_info' do
        expect(subject.extra).not_to have_key(:raw_info)
      end
    end

    context "when skip info is false" do
      before { subject.options.skip_info = false }

      it 'should include raw_info' do
        expect(subject.extra[:raw_info]).to eq(raw_info)
      end
    end
  end
end
