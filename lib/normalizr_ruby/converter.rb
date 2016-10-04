module NormalizrRuby
  class Converter
    class SchemaNotFound < StandardError; end

    def self.get_schema_class(resource)
      resource_class = resource.class
      resource_class = resource_class.base_class if resource_class.respond_to?(:base_class)
      resource_class_name = resource_class.name
      schema_class = "#{resource_class_name}Schema".safe_constantize
      if schema_class.nil?
        raise SchemaNotFound, "#{resource_class_name} is not found."
      end
      schema_class
    end

    def initialize(context)
      @context = context
      @entities = {}
      @result = nil
    end

    def normalize(resource, options)
      opts = options.presence || {}
      @result = walk(resource, opts)
      key_transform = NormalizrRuby.config.key_transform
      normalized_hash = { result: @result, entities: @entities }
      KeyTransform.send(key_transform, normalized_hash)
    rescue SchemaNotFound => e
      resource
    end

    def walk(resource, options)
      result = nil
      if resource.respond_to?(:map)
        result = resource.map {|r| walk(r, options)}
      else
        schema_class = options[:schema].presence || self.class.get_schema_class(resource)
        schema = schema_class.new(resource, @context, options.except(:schema))
        result = schema.object.id
        entity_key = schema.object.class.base_class.name.pluralize.to_sym
        hash = schema.attributes
        schema.associations.each do |association, assoc_options|
          if schema.object.send(association).nil?
            association_result = nil
          else
            association_result = walk(schema.object.send(association), assoc_options)
          end
          hash[association] = association_result
        end
        @entities[entity_key] ||= {}
        @entities[entity_key][result] = hash
      end
      result
    end
  end
end
