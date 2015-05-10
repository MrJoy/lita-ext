require 'lita'
require 'lita/handler'

module Lita
  class Handler
    def config_valid?
      valid = true
      self.class.config_options.each do |config_option|
        if config_option.required? and config[config_option.name].nil?
          log.error "#{self.class.name.split('::').last}: missing #{config_option.name} setting"
          valid = false
        end
      end
      valid
    end

    class ConfigOption < Struct.new(
      :name,
      :required,
      :type,
      :default
    )
      alias_method :required?, :required
    end

    class << self
      def inherited(subclass)
        handlers << subclass
        super
      end

      def handlers
        @handlers ||= []
      end

      def config(name, required: true, type: nil, types: nil, default: nil)
        eff_types = Array(type) + Array(types)
        config_options << ConfigOption.new(name, required, eff_types, default)
      end

      def config_options
        @config_options ||= []
      end

      def default_config(default)
        config_options.each do |config_option|
          default[config_option.name] = config_option.default
        end
      end
    end
  end
end
