module Microscope
  module Mixin
    extend ActiveSupport::Concern

    included do
      define_microscrope_scopes
    end

    module ClassMethods
      def define_microscrope_scopes
        except = @microscope_options[:except] || []
        model_columns = self.columns.dup.reject { |c| except.include?(c.name.to_sym) }

        if only = @microscope_options[:only]
          model_columns = model_columns.select { |c| only.include?(c.name.to_sym) }
        end

        boolean_fields = model_columns.select { |c| c.type == :boolean }.map(&:name)
        boolean_fields.each do |field|
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            scope field, lambda { where(field => true) }
            scope "not_#{field}", lambda { where(field => false) }
          RUBY
        end

        datetime_fields = model_columns.select { |c| c.type == :datetime }.map(&:name)
        datetime_fields.each do |field|
          cropped_field = field.gsub(/_at$/, '')
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            scope "#{cropped_field}_before", lambda { |time| where(["#{field} < ?", time]) }
            scope "#{cropped_field}_before_or_at", lambda { |time| where(["#{field} <= ?", time]) }
            scope "#{cropped_field}_before_now", lambda { where(["#{field} < ?", Time.now]) }

            scope "#{cropped_field}_after", lambda { |time| where(["#{field} > ?", time]) }
            scope "#{cropped_field}_after_or_at", lambda { |time| where(["#{field} >= ?", time]) }
            scope "#{cropped_field}_after_now", lambda { where(["#{field} > ?", Time.now]) }

            scope "#{cropped_field}_between", lambda { |range| where(field => range) }
          RUBY
        end
      end
    end
  end
end
