require 'tilt'

module SassC
  module Rails
    class Importer < SassC::Importer
      class Extension
        attr_reader :postfix

        def initialize(postfix=nil)
          @postfix = postfix
        end

        def import_for(original_path, parent_path, full_path, options)
          SassC::Importer::Import.new(full_path)
        end
      end

      class CSSExtension
        def postfix
          ".css"
        end

        def import_for(original_path, parent_path, full_path, options)
          import_path = full_path.gsub(/\.css$/,"")
          SassC::Importer::Import.new(import_path)
        end
      end

      class CssScssExtension < Extension
        def postfix
          ".css.scss"
        end

        def import_for(original_path, parent_path, full_path, options)
          source = File.open(full_path, 'rb') { |f| f.read }
          SassC::Importer::Import.new(full_path, source: source)
        end
      end

      class CssSassExtension < Extension
        def postfix
          ".css.sass"
        end

        def import_for(original_path, parent_path, full_path, options)
          sass = File.open(full_path, 'rb') { |f| f.read }
          parsed_scss = SassC::Sass2Scss.convert(sass)
          SassC::Importer::Import.new(full_path, source: parsed_scss)
        end
      end

      class SassERBExtension < Extension
        def postfix
          ".sass.erb"
        end

        def import_for(original_path, parent_path, full_path, options)
          template = Tilt::ERBTemplate.new(full_path)
          parsed_erb = template.render(options[:sprockets][:context], {})
          parsed_scss = SassC::Sass2Scss.convert(parsed_erb)
          SassC::Importer::Import.new(full_path, source: parsed_scss)
        end
      end

      class ERBExtension < Extension
        def import_for(original_path, parent_path, full_path, options)
          template = Tilt::ERBTemplate.new(full_path)
          parsed_erb = template.render(options[:sprockets][:context], {})
          SassC::Importer::Import.new(full_path, source: parsed_erb)
        end
      end

      EXTENSIONS = [
        Extension.new(".scss"),
        Extension.new(".sass"),
        CSSExtension.new,
        ERBExtension.new(".scss.erb"),
        ERBExtension.new(".css.erb"),
        SassERBExtension.new,
        CssScssExtension.new,
        CssSassExtension.new
      ]

      PREFIXS = [ "", "_" ]

      def imports(path, parent_path)
        parent_dir, _ = File.split(parent_path)
        specified_dir, specified_file = File.split(path)

        search_paths = ([parent_dir] + load_paths).uniq

        if specified_dir != "."
          search_paths.map! do |path|
            File.join(path, specified_dir)
          end
        end

        search_paths.each do |search_path|
          PREFIXS.each do |prefix|
            file_name = prefix + specified_file

            EXTENSIONS.each do |extension|
              try_path = File.join(search_path, file_name + extension.postfix)
              if File.exists?(try_path)
                record_import_as_dependency try_path
                return extension.import_for(path, parent_path, try_path, options)
              end
            end
          end
        end

        Import.new(path)
      end

      private

      def record_import_as_dependency(path)
        context.depend_on path
      end

      def context
        options[:sprockets][:context]
      end

      def load_paths
        options[:load_paths]
      end
    end
  end
end
