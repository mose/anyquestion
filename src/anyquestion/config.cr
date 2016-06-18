require "yaml"

module Anyquestion
  class Config
    getter :get

    YAML.mapping(
      public_folder: String
    )
  end
end
