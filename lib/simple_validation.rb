module SimpleValidation
  def self.included(base)
    base.class_eval do
      base.extend SimpleValidation::ClassMethods
    end
  end

  module ClassMethods
    def validate(method_name)
      validation_methods << method_name
    end

    def validation_methods
      @validation_methods ||= []
    end
  end

  def valid?
    self.class.validation_methods.each do |method_name|
      send method_name
    end

    errors.empty?
  end

  def invalid?
    not valid?
  end

  def add_error(error)
    errors << error unless errors.include?(error)
  end

  def add_errors(more_errors)
    errors.concat(more_errors)
  end

  def errors
    @errors ||= []
  end
end
