# frozen_string_literal: true

require 'legion/extensions/cognitive_surplus/helpers/constants'
require 'legion/extensions/cognitive_surplus/helpers/allocation'
require 'legion/extensions/cognitive_surplus/helpers/surplus_engine'
require 'legion/extensions/cognitive_surplus/runners/surplus'

module Legion
  module Extensions
    module CognitiveSurplus
      class Client
        include Runners::Surplus

        def initialize(**)
          @surplus_engine = Helpers::SurplusEngine.new
        end

        private

        attr_reader :surplus_engine
      end
    end
  end
end
