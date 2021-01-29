require 'command_kit/arguments/argument_value'

module CommandKit
  module Arguments
    #
    # Represents a defined argument.
    #
    class Argument < ArgumentValue

      # @return [Symbol]
      attr_reader :name

      # @return [String, nil]
      attr_reader :desc

      # @return [Regexp, nil]
      attr_reader :pattern

      # @return [Proc, nil]
      attr_reader :parser

      # @return [Proc, nil]
      attr_reader :block

      #
      # Initializes the argument.
      #
      # @param [Symbol] name
      #
      # @param [Class] type
      #
      # @param [String, nil] usage
      #
      # @param [Object, Proc, nil] default
      #
      # @param [Boolean] required
      #
      # @param [Boolean] repeats
      #
      # @param [String] desc
      #
      # @note `usage` will be assigned a default value based on `type` and
      # `name`.
      #
      # @yield [(value)]
      #
      # @yieldparam [Object, nil] value
      #
      def initialize(name, type:     String,
                           usage:    name.upcase,
                           default:  nil,
                           required: false,
                           repeats:  false,
                           desc:     ,
                           &block)
        super(
          type:     type,
          usage:    usage,
          default:  default,
          required: required
        )

        @name    = name
        @repeats = repeats
        @desc    = desc

        @pattern, @parser = self.class.parser(@type)

        @block = block
      end

      #
      # Looks up the option parser for the given `OptionParser` type.
      #
      # @param [Class] type
      #   The `OptionParser` type class.
      #
      # @return [(Regexp, Proc), nil]
      #   The matching pattern and converter proc.
      #
      def self.parser(type)
        OptionParser::DefaultList.search(:atype,type)
      end

      #
      # Specifies whether the argument can be repeated repeat times.
      #
      # @return [Boolean]
      #
      def repeats?
        @repeats
      end

      #
      # The usage string for the argument.
      #
      # @return [String]
      #
      def usage
        string = @usage
        string = "#{string} ..." if repeats?
        string = "[#{string}]" if optional?
        string
      end

      #
      # Parses the given argument.
      #
      # @param [Stirng, nil] arg
      #   The given argument.
      #
      # @return [Object]
      #   The parsed argument.
      #
      def parse(arg)
        if @parser
          arg = @parser.call(arg)
        end

        if @block
          arg = @block.call(arg)
        end

        return arg
      end

    end
  end
end
