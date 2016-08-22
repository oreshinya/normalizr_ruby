module ActionController
  module Normalizable
    extend ActiveSupport::Concern
    include ActionController::Renderers

    [:_render_option_json, :_render_with_renderer_json].each do |renderer_method|
      define_method renderer_method do |resource, options|
        context = respond_to?(:normalizr_context) ? normalizr_context : nil
        converter = NormalizrRuby::Converter.new(context)
        normalized_resource = converter.normalize(resource, options[:normalizr])
        super(normalized_resource, options.except(:normalizr))
      end
    end
  end
end
