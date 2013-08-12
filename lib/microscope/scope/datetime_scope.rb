module Microscope
  class Scope
    class DatetimeScope < Scope
      def apply
        @cropped_field = field.name.gsub(/_at$/, '')

        apply_before_scopes
        apply_after_scopes
        apply_between_scopes
        apply_boolean_scopes
      end

    protected

      def apply_before_scopes
        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope "#{@cropped_field}_before", lambda { |time| where("#{field.name} < ?", time) }
          scope "#{@cropped_field}_before_or_at", lambda { |time| where("#{field.name} <= ?", time) }
          scope "#{@cropped_field}_before_now", lambda { where("#{field.name} < ?", Time.now) }
        RUBY
      end

      def apply_after_scopes
        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope "#{@cropped_field}_after", lambda { |time| where("#{field.name} > ?", time) }
          scope "#{@cropped_field}_after_or_at", lambda { |time| where("#{field.name} >= ?", time) }
          scope "#{@cropped_field}_after_now", lambda { where("#{field.name} > ?", Time.now) }
        RUBY
      end

      def apply_between_scopes
        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope "#{@cropped_field}_between", lambda { |range| where("#{field.name}" => range) }
        RUBY
      end

      def apply_boolean_scopes
        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          scope "#{@cropped_field}", lambda { where("#{field.name} IS NOT NULL AND #{field.name} <= ?", Time.now) }
          scope "not_#{@cropped_field}", lambda { where("#{field.name} IS NULL OR #{field.name} > ?", Time.now) }
        RUBY
      end
    end
  end
end
