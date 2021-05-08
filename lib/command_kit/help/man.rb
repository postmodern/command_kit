# frozen_string_literal: true

require 'command_kit/help'

module CommandKit
  module Help
    #
    # Allows displaying a man-page instead of the usual `--help` output.
    #
    # ## Environment Variables
    #
    # * `TERM` - Specifies the type of terminal. When set to `DUMB`, it will
    #   disable man-page help output.
    #
    module Man
      include Help

      module ModuleMethods
        #
        # Extends {ClassMethods} or {ModuleMethods}, depending on whether
        # {Help::Man} is being included into a class or a module.
        #
        # @param [Class, Module] context
        #   The class or module including {Man}.
        #
        def included(context)
          super(context)

          if context.class == Module
            context.extend ModuleMethods
          else
            context.extend ClassMethods
          end
        end
      end

      extend ModuleMethods

      #
      # Defines class-level methods.
      #
      module ClassMethods
        #
        # Gets or sets the directory where man-pages are stored.
        #
        # @param [String, nil] new_man_dir
        #   If a String is given, it will set The class'es man-page directory.
        #
        # @return [String, nil]
        #   The class'es or superclass'es man-page directory.
        #
        # @example
        #   man_dir File.expand_path('../../../man',__FILE__)
        #
        def man_dir(new_man_dir=nil)
          if new_man_dir
            @man_dir = File.expand_path(new_man_dir)
          else
            @man_dir || (superclass.man_dir if superclass.kind_of?(ClassMethods))
          end
        end
      end

      #
      # Determines if displaying man pages is supported.
      #
      # @return [Boolean]
      #   Indicates whether the `TERM` environment variable is not `dumb`
      #   and `$stdout` is a TTY.
      #
      def self.supported?
        ENV['TERM'] != 'dumb' && $stdout.tty?
      end

      #
      # Returns the man-page file name for the given command name.
      #
      # @param [String] command
      #   The given command name.
      #
      # @return [String]
      #   The man-page file name.
      #
      def man_page(command=command_name)
        "#{command}.1"
      end

      #
      # Displays the given man page.
      #
      # @param [String] page
      #   The man page file name.
      #
      # @return [Boolean, nil]
      #   Specifies whether the `man` command was successful or not.
      #   Returns `nil` when the `man` command is not installed.
      #
      def man(page=man_page)
        system('man',page)
      end

      #
      # Displays the {#man_page} instead of the usual `--help` output.
      #
      # @raise [NotImplementedError]
      #   {ClassMethods#man_dir man_dir} does not have a value.
      #
      # @note
      #   if `TERM` is `dumb` or `$stdout` is not a TTY, fallsback to printing
      #   the usual `--help` output.
      #
      def help
        if Man.supported?
          unless self.class.man_dir
            raise(NotImplementedError,"#{self.class}.man_dir not set")
          end

          man_path = File.join(self.class.man_dir,man_page)

          if man(man_path).nil?
            super
          end
        else
          super
        end
      end
    end
  end
end
