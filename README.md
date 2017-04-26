# Omniauth Participa

[![Gem Version](https://badge.fury.io/rb/omniauth-participa.svg)](https://badge.fury.io/rb/omniauth-participa)
[![Build Status](https://travis-ci.org/adab1ts/omniauth-participa.svg?branch=master)](https://travis-ci.org/adab1ts/omniauth-participa)
[![Dependency Status](https://gemnasium.com/badges/github.com/adab1ts/omniauth-participa.svg)](https://gemnasium.com/github.com/adab1ts/omniauth-participa)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square)](https://choosealicense.com/licenses/mit/)

This gem contains the [OmniAuth](https://github.com/omniauth/omniauth) strategy for [Participa](https://github.com/GuanyemBarcelona/participa) platform.


## Before You Begin

[Participa](https://github.com/GuanyemBarcelona/participa) supports [OAuth 2](https://www.oauth.com/) authentication, playing the [Authorization and Resource Server](https://aaronparecki.com/oauth-2-simplified/#roles) roles.

Participa uses the _Authorization Code_ grant to authorize Client apps acting on behalf the user. Contact the platform admin and ask for a **Client ID** and a **Client Secret** for your application. Remember to provide your **Redirect URI**:

`https://your-application.domain/auth/participa/callback`.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-participa'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-participa


## Usage

`OmniAuth::Strategies::Participa` is simply a Rack middleware. Tell OmniAuth about this provider. For a Rails app, your `config/initializers/omniauth.rb` file should look like this:

```ruby
# config/initializers/omniauth.rb

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :participa, ENV['PARTICIPA_CLIENT_ID'], ENV['PARTICIPA_CLIENT_SECRET']
end
```


## Configuration

You can configure several options, which you pass in to the `provider` method via a `Hash`:

Option name | Default | Explanation
--- | --- | ---
`site` | `https://participa.dev` | URL of the Participa server instance  (e.g. https://the-server-app.com)
`authorize_url` | `/oauth/authorize` | Authorization URL for Participa (e.g. https://the-server-app.com/oauth/authorize)
`token_url` | `/oauth/token` | Token URL for Participa (e.g. https://the-server-app.com/oauth/token)
`endpoint_url` | `/api/v2/users/me` | User endpoint URL for Participa (e.g. https://the-server-app.com/api/v2/users/me)'
`redirect_uri` | | Custom callback URL used during the server-side flow (e.g. https://the-client-app.com/auth/participa/callback)

Here's an example of a possible configuration:

```ruby
# config/initializers/omniauth.rb

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :participa, ENV['PARTICIPA_CLIENT_ID'], ENV['PARTICIPA_CLIENT_SECRET'],
    {
      redirect_uri: 'https://the-client-app.com/auth/participa/callback',
      client_options: {
        site: 'https://the-server-app.com',
        authorize_url: 'https://the-server-app.com/oauth/authorize',
        token_url: 'https://the-server-app.com/oauth/token',
        endpoint_url: 'https://the-server-app.com/api/v2/users/me'
      }
    }
end
```


## Auth Hash

Here's an example _Auth Hash_ available in the callback by accessing `request.env['omniauth.auth']`:

```ruby
{
  provider: 'participa',
  uid: '12345',
  info: {
    email: 'jane.doe@acme.com',
    name: 'Jane Doe',
    username: 'Jane_Doe',
    admin: true
  },
  credentials: {
    token: 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
    refresh_token: "FEDCBA...",
    expires_at: 1321747205, # when the access token expires (it always will),
    expires: true # this will always be true
  }
  extra: {
    raw_info: {
      id: '12345',
      email: 'jane.doe@acme.com',
      full_name: 'Jane Doe',
      username: 'Jane_Doe',
      admin: true,
      list_groups: ['group-1', 'group-2']
    }
  }
}
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contact

Email:    info[@]adabits[.]org  
Twitter:  [@adab1ts](https://twitter.com/adab1ts)  
Facebook: [Adab1ts](https://www.facebook.com/Adab1ts)  
LinkedIn: [adab1ts](https://www.linkedin.com/company/adab1ts)  


## Contributors

Contributions of any kind are welcome!

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<img alt="laklau" src="https://avatars.githubusercontent.com/u/6210292?v=3&s=117" width="117"> |[<img alt="zuzust" src="https://avatars.githubusercontent.com/u/351530?v=3&s=117" width="117">](https://github.com/adab1ts/omniauth-participa/commits?author=zuzust) |
:---: |:---: |
[Klaudia Alvarez](https://github.com/laklau) |[Carles Muiños](https://github.com/zuzust)
<!-- ALL-CONTRIBUTORS-LIST:END -->


## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).
