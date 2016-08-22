module NormalizrRuby
  module Generators
    class SchemaGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def create_schema
        template 'schema.rb', File.join('app/schemas', class_path, "#{file_name}_schema.rb")
      end
    end
  end
end
