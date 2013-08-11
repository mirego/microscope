module Microscope
  class Scope
    class BooleanScope < Scope
      def apply
        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope "#{field.name}", lambda { where("#{field.name}" => true) }
          scope "not_#{field.name}", lambda { where("#{field.name}" => false) }
        RUBY
      end
    end
  end
end
