module Anyquestion
  class Sessions
    @session_name : String

    def initialize(config : Config)
      @session_name = config.session_name
      @all = {} of Int32 => String
    end

    def set(env, value)
      key = Random.new.rand(500000)
      @all[key] = value
      c = HTTP::Cookie.new(@session_name, key.to_s, "/", Time.now.to_utc + Time::Span.new(4, 0, 0))
      # c.add_response_headers env.response.headers
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
