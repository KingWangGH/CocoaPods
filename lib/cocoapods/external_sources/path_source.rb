module Pod
  module ExternalSources

    # Provides support for fetching a specification file from a path local to
    # the machine running the installation.
    #
    # Works with the {LocalPod::LocalSourcedPod} class.
    #
    class PathSource < AbstractExternalSource

      # @see  AbstractExternalSource#fetch
      #
      def fetch(sandbox)
        title = "Fetching podspec for `#{name}` #{description}"
        UI.titled_section(title, { :verbose_prefix => "-> " }) do
          podspec = podspec_path
          unless podspec.exist?
            raise Informative, "No podspec found for `#{name}` in " \
              "`#{declared_path}`"
          end
          store_podspec(sandbox, podspec)
          is_absolute = absolute?(podspec)
          sandbox.store_local_path(name, podspec.dirname, is_absolute)
        end
      end

      # @see  AbstractExternalSource#description
      #
      def description
        "from `#{params[:path] || params[:local]}`"
      end

      private

      # @!group Helpers

      # @return [String] The path as declared by the user.
      #
      def declared_path
        result = params[:path] || params[:local]
        result.to_s if result
      end

      # @return [Pathname] The absolute path of the podspec.
      #
      def podspec_path
        Pathname(normalized_podspec_path(declared_path))
      end

      # @return [Bool]
      #
      def absolute?(path)
        Pathname(path).absolute? || path.to_s.start_with?('~')
      end
    end
  end
end

