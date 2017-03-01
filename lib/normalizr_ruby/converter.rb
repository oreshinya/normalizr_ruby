module NormalizrRuby
  class Converter
    class SchemaNotFound < StandardError; end

    def initialize(context)
      @context = context
      @entities = {}
      @result = nil
    end

    def normalize(resource, options)
      opts = options.presence || {}
      @result = walk(resource, opts)
      { result: @result, entities: @entities }
    rescue SchemaNotFound => e
      resource
    end

    private

    def recase(value)
      key_transform = NormalizrRuby.config.key_transform
      KeyTransform.send(key_transform, value)
    end

    def not_found(klass)
      raise SchemaNotFound, "#{klass.name}Schema is not found."
    end

    def schema_class(resource)
      klass = resource.class
      klass = klass.base_class if klass.respond_to?(:base_class)
      schema_klass = "#{klass.name}Schema".safe_constantize
      not_found(klass) if schema_klass.nil?
      schema_klass
    end

    def init_schema(resource, options)
      schema_klass = options[:schema].presence || schema_class(resource)
      schema_klass.new(resource, @context, options.except(:schema))
    end

    def walk(resource, options)
      result = nil
      if resource.respond_to?(:map)
        result = resource.map {|r| walk(r, options)}
      else
        schema = init_schema(resource, options)
        hash = schema.attributes
        schema.associations.each do |assoc, assoc_options|
          assoc_resource = schema.association_resource(assoc)
          assoc_result = nil
          unless assoc_resource.nil?
            assoc_result = walk(assoc_resource, assoc_options)
          end
          hash[assoc] = assoc_result
        end
        result = schema.object.id
        entity_key = recase(schema.entity_key)
        @entities[entity_key] ||= {}
        @entities[entity_key][result] = recase(hash)
      end
      result
    end
  end
end
