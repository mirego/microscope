module Microscope
  module Mixin
    extend ActiveSupport::Concern

    included do
      define_microscrope_scopes
    end

    module ClassMethods
      def define_microscrope_scopes
        excluded_fields = @microscope_options[:except] || []
        model_columns = self.columns.dup.reject { |c| excluded_fields.include?(c.name.to_sym) }

        boolean_fields = model_columns.select { |c| c.type == :boolean }.map(&:name)
        class_eval do
          boolean_fields.each do |field|
            scope field, where(field => true)
            scope "not_#{field}", where(field => false)
          end
        end

        datetime_fields = model_columns.select { |c| c.type == :datetime }.map(&:name)
        class_eval do
          datetime_fields.each do |field|
            cropped_field = field.gsub(/_at$/, '')

            scope "#{cropped_field}_before", lambda { |time| where(["#{field} < ?", time]) }
            scope "#{cropped_field}_before_or_at", lambda { |time| where(["#{field} <= ?", time]) }
            scope "#{cropped_field}_before_now", lambda { where(["#{field} < ?", Time.now]) }

            scope "#{cropped_field}_after", lambda { |time| where(["#{field} > ?", time]) }
            scope "#{cropped_field}_after_or_at", lambda { |time| where(["#{field} >= ?", time]) }
            scope "#{cropped_field}_after_now", lambda { where(["#{field} > ?", Time.now]) }

            scope "#{cropped_field}_between", lambda { |range| where(field => range) }
          end
        end
      end
    end
  end
end
