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
        return unless @field_name =~ @cropped_field_regex
        @cropped_field = @field_name.gsub(@cropped_field_regex, '')

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
          scope "#{@cropped_field}_before", lambda { |time| where("`#{@table_name}`.`#{@field_name}` < ?", time) }
          scope "#{@cropped_field}_before_or_at", lambda { |time| where("`#{@table_name}`.`#{@field_name}` <= ?", time) }
          scope "#{@cropped_field}_before#{@now_suffix}", lambda { where("`#{@table_name}`.`#{@field_name}` < ?", #{@now}) }
        RUBY
      end

      def after_scopes
        <<-RUBY
          scope "#{@cropped_field}_after", lambda { |time| where("`#{@table_name}`.`#{@field_name}` > ?", time) }
          scope "#{@cropped_field}_after_or_at", lambda { |time| where("`#{@table_name}`.`#{@field_name}` >= ?", time) }
          scope "#{@cropped_field}_after#{@now_suffix}", lambda { where("`#{@table_name}`.`#{@field_name}` > ?", #{@now}) }
        RUBY
      end

      def between_scopes
        <<-RUBY
          scope "#{@cropped_field}_between", lambda { |range| where("#{@field_name}" => range) }
        RUBY
      end

      def boolean_scopes
        <<-RUBY
          scope "#{@cropped_field}", lambda { where("`#{@table_name}`.`#{@field_name}` IS NOT NULL AND `#{@table_name}`.`#{@field_name}` <= ?", #{@now}) }
          scope "not_#{@cropped_field}", lambda { where("`#{@table_name}`.`#{@field_name}` IS NULL OR `#{@table_name}`.`#{@field_name}` > ?", #{@now}) }
        RUBY
      end
    end
  end
end
