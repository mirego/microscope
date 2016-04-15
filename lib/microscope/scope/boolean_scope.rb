module Microscope
  class Scope
    class BooleanScope < Scope
      def apply
        validate_field_name!(@field.name, @field.name)

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope "#{@field.name}", lambda { where("#{@field.name}" => true) }
          scope "not_#{@field.name}", lambda { where("#{@field.name}" => false) }
          scope "un#{@field.name}", lambda { not_#{@field.name} }
        RUBY
      end
    end
  end
end
