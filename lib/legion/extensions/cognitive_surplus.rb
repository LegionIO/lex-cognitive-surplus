# frozen_string_literal: true

require 'legion/extensions/cognitive_surplus/version'
require 'legion/extensions/cognitive_surplus/helpers/constants'
require 'legion/extensions/cognitive_surplus/helpers/allocation'
require 'legion/extensions/cognitive_surplus/helpers/surplus_engine'
require 'legion/extensions/cognitive_surplus/runners/surplus'

module Legion
  module Extensions
    module CognitiveSurplus
      extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core
    end
  end
end
