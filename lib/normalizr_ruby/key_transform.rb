module NormalizrRuby
  module KeyTransform
    module_function

    def camel(value)
      case value
      when Hash then value.deep_transform_keys! { |key| camel(key) }
      when Symbol then camel(value.to_s).to_sym
      when String then value.underscore.camelize
      else value
      end
    end

    def camel_lower(value)
      case value
      when Hash then value.deep_transform_keys! { |key| camel_lower(key) }
      when Symbol then camel_lower(value.to_s).to_sym
      when String then value.underscore.camelize(:lower)
      else value
      end
    end

    def dash(value)
      case value
      when Hash then value.deep_transform_keys! { |key| dash(key) }
      when Symbol then dash(value.to_s).to_sym
      when String then value.underscore.dasherize
      else value
      end
    end

    def underscore(value)
      case value
      when Hash then value.deep_transform_keys! { |key| underscore(key) }
      when Symbol then underscore(value.to_s).to_sym
      when String then value.underscore
      else value
      end
    end

    def unaltered(value)
      value
    end
  end
end
