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
          scope field, lambda { where(field => true) }
          scope "not_#{field}", lambda { where(field => false) }
        end

        datetime_fields = model_columns.select { |c| c.type == :datetime }.map(&:name)
        datetime_fields.each do |field|
          cropped_field = field.gsub(/_at$/, '')

          scope "#{cropped_field}_before", lambda { |time| where("#{field} < ?", time) }
          scope "#{cropped_field}_before_or_at", lambda { |time| where("#{field} <= ?", time) }
          scope "#{cropped_field}_before_now", lambda { where("#{field} < ?", Time.now) }

          scope "#{cropped_field}_after", lambda { |time| where("#{field} > ?", time) }
          scope "#{cropped_field}_after_or_at", lambda { |time| where("#{field} >= ?", time) }
          scope "#{cropped_field}_after_now", lambda { where("#{field} > ?", Time.now) }

          scope "#{cropped_field}_between", lambda { |range| where(field => range) }

          scope "#{cropped_field}", lambda { where("#{field} NOT NULL AND DATE(#{field}) <= DATE(?)", Time.now) }
          scope "not_#{cropped_field}", lambda { where("#{field} IS NULL OR DATE(#{field}) > DATE(?)", Time.now) }
        end

        date_fields = model_columns.select { |c| c.type == :date }.map(&:name)
        date_fields.each do |field|
          cropped_field = field.gsub(/_on$/, '')

          scope "#{cropped_field}_before", lambda { |time| where("#{field} < ?", time) }
          scope "#{cropped_field}_before_or_on", lambda { |time| where("#{field} <= ?", time) }
          scope "#{cropped_field}_before_today", lambda { where("#{field} < ?", Date.today) }

          scope "#{cropped_field}_after", lambda { |time| where("#{field} > ?", time) }
          scope "#{cropped_field}_after_or_at", lambda { |time| where("#{field} >= ?", time) }
          scope "#{cropped_field}_after_today", lambda { where("#{field} > ?", Date.today) }

          scope "#{cropped_field}_between", lambda { |range| where(field => range) }

          scope "#{cropped_field}", lambda { where("#{field} NOT NULL AND DATE(#{field}) <= DATE(?)", Date.today) }
          scope "not_#{cropped_field}", lambda { where("#{field} IS NULL OR DATE(#{field}) > DATE(?)", Date.today) }
        end
      end
    end
  end
end
