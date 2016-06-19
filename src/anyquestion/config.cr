require "yaml"

module Anyquestion
  class Config
    @overridable_by_env = %w(public_folder css_file)

    YAML.mapping(
      public_folder: {
        type:    String,
        default: "public",
      },
      css_file: {
        type:    String,
        default: "css/site.css",
      }
    )

    def override_with_env
      @overridable_by_env.each do |key|
        if self.respond_to key_to_sym
        end
      end
    end
  end
end
