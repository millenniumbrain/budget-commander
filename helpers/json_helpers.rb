module JSONParserHelper
  module InstanceMethods
    def parse_json_inputs
      JSON.parse(env['rack.input'].gets)
    end
  end
end
