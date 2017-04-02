# frozen_string_literal: true
module Pragma
  module Operation
    module Macro
      def self.Model
        step = ->(input, options) { Model.for(input, options) }
        [step, name: 'model']
      end

      module Model
        class << self
          def for(_input, options)
            options['model'] = options['model.class'].find_by(id: options['params']['id'])
          end
        end
      end
    end
  end
end
