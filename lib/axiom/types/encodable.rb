# encoding: utf-8

module Axiom
  module Types

    # Add encoding constraints to a type
    module Encodable
      if RUBY_VERSION >= '1.9'

        # Hook called when module is extended
        #
        # Add #encoding DSL method to descendant and set the default to UTF-8.
        #
        # @param [Class] descendant
        #
        # @return [undefined]
        #
        # @api private
        def self.extended(descendant)
          super
          descendant.accept_options :encoding
          descendant.encoding Encoding::UTF_8
        end

        private_class_method :extended

        # Finalize by setting up a primitive constraint
        #
        # @return [Axiom::Types::Encodable]
        #
        # @api private
        def finalize
          return self if frozen?
          has_encoding
          super
        end

      private

        # Add constraint for the encoding
        #
        # @return [undefined]
        #
        # @api private
        def has_encoding
          constraint do |object|
            object.encoding.equal?(encoding) ||
            (encoding.ascii_compatible? && object.to_s.ascii_only?)
          end
        end

      end
    end # module Encodable
  end # module Types
end # module Axiom
