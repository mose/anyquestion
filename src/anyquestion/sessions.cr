module Anyquestion
  class Sessions
    def initialize(config : Config)
      @session_name = config.session_name
      @all = {} of Int64 => String
    end

    def set(env, value)
      key = Random.new.rand(500000)
      @all[key] = value
      c = HTTP::Cookie.new(@session_name, key, "/", Time.now.to_utc + Time::Span.new(4, 0, 0))
      c.add_response_headers env.response.headers
    end

    def check?(env, value)
      if env.request.cookies[@session_name]? && @all[env.request.cookies[@session_name].value]?
        @all[env.request.cookies[@session_name].value] == value
      else
        false
      end
    end
  end
end
