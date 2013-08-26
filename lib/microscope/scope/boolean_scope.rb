module Microscope
  class Scope
    class BooleanScope < Scope
      def apply
        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope "#{@field_name}", lambda { where("#{@field_name}" => true) }
          scope "not_#{@field_name}", lambda { where("#{@field_name}" => false) }
        RUBY
      end
    end
  end
end
