# frozen_string_literal: true

require 'json'

class CloudflareProxy
  def initialize(app)
    @app = app
  end

  def call(env)
    return @app.call(env) unless env['HTTP_CF_VISITOR']

    env['HTTP_X_FORWARDED_PROTO'] = JSON.parse(env['HTTP_CF_VISITOR'])['scheme']
    @app.call(env)
  end
end