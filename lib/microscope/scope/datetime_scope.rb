module Microscope
  class Scope
    class DatetimeScope < Scope
      def initialize(*args)
        super

        @now = 'Time.now'
        @now_suffix = '_now'
        @cropped_field_regex = /_at$/
      end

      def apply
        @cropped_field = field.name.gsub(@cropped_field_regex, '')

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          #{before_scopes}
          #{after_scopes}
          #{between_scopes}
          #{boolean_scopes}
        RUBY
      end

    private

      def before_scopes
        <<-RUBY
          scope "#{@cropped_field}_before", lambda { |time| where("#{field.name} < ?", time) }
          scope "#{@cropped_field}_before_or_at", lambda { |time| where("#{field.name} <= ?", time) }
          scope "#{@cropped_field}_before#{@now_suffix}", lambda { where("#{field.name} < ?", #{@now}) }
        RUBY
      end

      def after_scopes
        <<-RUBY
          scope "#{@cropped_field}_after", lambda { |time| where("#{field.name} > ?", time) }
          scope "#{@cropped_field}_after_or_at", lambda { |time| where("#{field.name} >= ?", time) }
          scope "#{@cropped_field}_after#{@now_suffix}", lambda { where("#{field.name} > ?", #{@now}) }
        RUBY
      end

      def between_scopes
        <<-RUBY
          scope "#{@cropped_field}_between", lambda { |range| where("#{field.name}" => range) }
        RUBY
      end

      def boolean_scopes
        <<-RUBY
          scope "#{@cropped_field}", lambda { where("#{field.name} IS NOT NULL AND #{field.name} <= ?", #{@now}) }
          scope "not_#{@cropped_field}", lambda { where("#{field.name} IS NULL OR #{field.name} > ?", #{@now}) }
        RUBY
      end
    end
  end
end
