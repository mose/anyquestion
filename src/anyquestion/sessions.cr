module Anyquestion
  class Sessions
    @session_name : String
    @autologged : Bool

    def initialize(config : Config)
      @session_name = config.session_name
      @autologged = config.autologged != "false"
      @all = {} of Int32 => String
    end

    def set(env, value)
      key = Random.new.rand(500000)
      @all[key] = value
      c = HTTP::Cookies.new
      c << HTTP::Cookie.new(@session_name, key.to_s, "/", Time.now.to_utc + Time::Span.new(4, 0, 0))
      c.add_response_headers env.response.headers
    end

    def drop(env)
      if has_session(env)
        @all.delete env.request.cookies[@session_name].value.to_i32
      end
    end

    def check?(env, value)
      return true if @autologged
      if has_session(env)
        @all[env.request.cookies[@session_name].value.to_i32] == value
      else
        false
      end
    end

    def has_session(env)
      env.request.cookies[@session_name]? &&
        @all[env.request.cookies[@session_name].value.to_i32]?
    end
  end
end
