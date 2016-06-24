require "yaml"

module Anyquestion
  class Config
    macro build_overriding(vars)
      def override_with_env()
        {% for var in vars %}
          @{{var.id}} = ENV["AQ_{{var.id.upcase}}"]? || @{{var.id}}
        {% end %}
        self
      end
    end

    YAML.mapping(
      public_folder: {
        type:    String,
        default: "public",
      },
      css_file: {
        type:    String,
        default: "css/site.css",
      },
      anon_create: {
        type:    Bool | String,
        default: true,
      },
      password: {
        type:    String,
        default: "xxx",
      },
      session_name: {
        type:    String,
        default: "aq_id",
      }
    )

    build_overriding(%w(
      public_folder
      css_file
      anon_create
      password
      session_name
    ))
  end
end
