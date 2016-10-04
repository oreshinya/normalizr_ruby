module NormalizrRuby
  class Schema
    attr_reader :object, :context, :props

    class_attribute :_attributes
    class_attribute :_associations

    self._attributes ||= {}
    self._associations ||= {}

    def self.inherited(child)
      super
      child._attributes = _attributes.dup
      child._associations = _associations.dup
    end

    def self.attribute(key, options = {})
      _attributes[key] = options;
    end

    def self.association(key, options = {})
      _associations[key] = options;
    end

    def initialize(object, context, props)
      @object = object
      @context = context
      @props = props
    end

    def attributes
      hash = {}
      self.class._attributes.each do |key, options|
        next if options[:if] && !send(options[:if])
        hash[key] = respond_to?(key) ? send(key) : object.send(key)
      end
      hash
    end

    def associations
      hash = {}
      self.class._associations.each do |key, options|
        next if options[:if] && !send(options[:if])
        hash[key] = options.except(:if)
      end
      hash
    end

    def entity_key
      object.class
            .base_class
            .name
            .pluralize
            .to_sym
    end

    def association_resource(association_key)
      object.send(association_key)
    end
  end
end
