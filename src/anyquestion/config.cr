require "yaml"

module Anyquestion
  class Config
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
  end
end
