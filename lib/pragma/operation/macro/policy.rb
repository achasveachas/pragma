# frozen_string_literal: true
module Pragma
  module Operation
    module Macro
      def self.Policy
        step = ->(input, options) { Policy.for(input, options) }
        [step, name: 'authorize', fail_fast: true]
      end

      module Policy
        class << self
          def for(input, options)
            return true unless options['policy.default.class']

            options['policy.default'] = options['policy.default.class'].new(
              user: options['current_user'],
              resource: options['model']
            )

            options['result.policy.default'] = options['policy.default'].send(
              "#{input.class.operation_name}?"
            ).tap do |result|
              options['result.response'] = Response::Forbidden.new unless result
            end
          end
        end
      end
    end
  end
end
