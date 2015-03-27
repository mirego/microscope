module ModelMacros
  # Create a new microscope model
  def microscope(klass_name, options = {}, &block)
    spawn_model klass_name, ActiveRecord::Base do
      instance_exec(&block) if block
      acts_as_microscope options
    end
  end

protected

  # Create a new model class
  def spawn_model(klass_name, parent_klass, &block)
    Object.instance_eval { remove_const klass_name } if Object.const_defined?(klass_name)
    Object.const_set(klass_name, Class.new(parent_klass))
    Object.const_get(klass_name).class_eval(&block) if block_given?
  end
end
