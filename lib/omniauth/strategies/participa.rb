require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Participa < OmniAuth::Strategies::OAuth2

      option :name, :participa
      option :scope, 'public'
      option :authorize_options, [:redirect_uri, :scope]
      option :provider_ignores_state, true

      option :client_options, {
        site: 'http://participa.dev',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token',
        endpoint_url: '/api/v2/users/me'
      }

      def authorize_params
        super.tap do |params|
          options[:authorize_options].each do |k|
            params[k] = request.params[k.to_s] unless [nil, ''].include?(request.params[k.to_s])
          end

          params[:scope] = params[:scope].split(' ').map {|item| item.split(',')}.flatten.join(' ')
        end
      end

      uid { raw_info['id'] }

      info do
        {
          email: raw_info['email'],
          name: raw_info['full_name'],
          username: raw_info['username'],
          admin: raw_info['admin']
        }
      end

      # TODO: add user groups
      extra do
        skip_info? ? {} : { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= acces_token.get(options[:client_options].try(:endpoint_url)).parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      # https://github.com/doorkeeper-gem/doorkeeper/issues/732
      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
    end
  end
end
