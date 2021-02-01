module CommandKit
  #
  # Provides access to stdin, stdout, and stderr streams.
  #
  #     class MyCmd
  #       include CommandKit::Stdio
  #
  #       def main
  #       end
  #     end
  #
  # Can be initialized with custom stdin, stdout, and stderr streams for testing
  # purposes.
  #
  #     stdin  = StringIO.new
  #     stdout = StringIO.new
  #     stderr = StringIO.new
  #     MyCmd.new(stdin: stdin, stdout: stdout, stderr: stderr)
  #
  module Stdio
    #
    # Prepends {Initializer}.
    #
    # @param [Class] command
    #   The command class including {Stdio}.
    #
    def self.included(command)
      command.prepend Initializer
    end

    #
    # Defines an {Initializer#initialize #initialize method}.
    #
    module Initializer
      #
      # Initializes {#stdin}, {#stdout}, and {#stderr}.
      #
      # @param [IO] stdin
      #   The stdin input stream. Defaults to `$stdin`.
      #
      # @param [IO] stdout
      #   The stdout output stream. Defaults to `$stdout`.
      #
      # @param [IO] stderr
      #   The stderr error output stream. Defaults to `$stderr`.
      #
      def initialize(stdin: $stdin, stdout: $stdout, stderr: $stderr, **kwargs)
        @stdin  = stdin
        @stdout = stdout
        @stderr = stderr

        if self.class.instance_method(:initialize).arity == 0
          super()
        else
          super(**kwargs)
        end
      end
    end

    # The stdin input stream.
    #
    # @return [$stdin, IO]
    attr_reader :stdin

    # The stdout output stream.
    #
    # @return [$stdout, IO]
    attr_reader :stdout

    # The stderr error output stream.
    #
    # @return [$stderr, IO]
    attr_reader :stderr

    #
    # Calls `stdin.gets`.
    #
    def gets(*arguments)
      stdin.gets(*arguments)
    end

    #
    # Calls `stdin.readline`.
    #
    def readline(*arguments)
      stdin.readline(*arguments)
    end

    #
    # Calls `stdin.readlines`.
    #
    def readlines(*arguments)
      stdin.readlines(*arguments)
    end

    # NOTE: intentionally do not override `Kenrel#p` or `Kernel#pp` to not
    # hijack echo-debugging.

    #
    # Calls `stdout.putc`.
    #
    def putc(*arguments)
      stdout.putc(*arguments)
    end

    #
    # Calls `stdout.puts`.
    #
    def puts(*arguments)
      stdout.puts(*arguments)
    end

    #
    # Calls `stdout.print`.
    #
    def print(*arguments)
      stdout.print(*arguments)
    end

    #
    # Calls `stdout.printf`.
    #
    def printf(*arguments)
      stdout.printf(*arguments)
    end
  end
end