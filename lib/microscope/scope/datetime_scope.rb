module Microscope
  class Scope
    class DatetimeScope < Scope
      def initialize(*args)
        super

        @now = 'Time.now'
        @now_suffix = '_now'
        @specific_suffix = '_at'
        @cropped_field_regex = /_at$/
        @formatted_time = 'time'
      end

      def apply
        return unless @field.name =~ @cropped_field_regex

        validate_field_name!(cropped_field, @field.name)
        model.class_eval(apply_scopes)
      end

    private

      def apply_scopes
        <<-RUBY
          scope "#{cropped_field}_before", lambda { |time| where('#{quoted_field} < ?', #{@formatted_time}) }
          scope "#{cropped_field}_before_or#{@specific_suffix}", lambda { |time| where('#{quoted_field} <= ?', #{@formatted_time}) }
          scope "#{cropped_field}_before#{@now_suffix}", lambda { where('#{quoted_field} < ?', #{@now}) }
          scope "#{cropped_field}_before_or#{@now_suffix}", lambda { where('#{quoted_field} <= ?', #{@now}) }

          scope "#{cropped_field}_after", lambda { |time| where('#{quoted_field} > ?', #{@formatted_time}) }
          scope "#{cropped_field}_after_or#{@specific_suffix}", lambda { |time| where('#{quoted_field} >= ?', #{@formatted_time}) }
          scope "#{cropped_field}_after#{@now_suffix}", lambda { where('#{quoted_field} > ?', #{@now}) }
          scope "#{cropped_field}_after_or#{@now_suffix}", lambda { where('#{quoted_field} >= ?', #{@now}) }

          scope "#{cropped_field}_between", lambda { |range| where("#{@field.name}" => range) }

          scope "#{cropped_field}", lambda { where('#{quoted_field} IS NOT NULL AND #{quoted_field} <= ?', #{@now}) }
          scope "not_#{cropped_field}", lambda { where('#{quoted_field} IS NULL OR #{quoted_field} > ?', #{@now}) }
          scope "un#{cropped_field}", lambda { not_#{cropped_field} }
        RUBY
      end
    end
  end
end
