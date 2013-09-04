require 'spec_helper'

describe Microscope do
  describe :acts_as_microscope do
    subject { User }

    before do
      run_migration do
        create_table(:users, force: true) do |t|
          # Boolean
          t.boolean :active, default: false
          t.boolean :admin, default: false
          t.boolean :moderator, default: false

          # DateTime
          t.datetime :published_at, default: nil
          t.datetime :removed_at, default: nil

          # Date
          t.date :started_on, default: nil
          t.date :ended_on, default: nil
        end
      end
    end

    describe :except do
      before do
        microscope 'User', except: [:admin, :removed_at, :ended_on]
      end

      it { should respond_to :active }
      it { should respond_to :not_active }
      it { should respond_to :moderator }
      it { should respond_to :not_moderator }
      it { should_not respond_to :admin }
      it { should_not respond_to :not_admin }
      it { should respond_to :published }
      it { should respond_to :not_published }
      it { should_not respond_to :removed }
      it { should_not respond_to :not_removed }
      it { should respond_to :started }
      it { should respond_to :not_started }
      it { should_not respond_to :ended }
      it { should_not respond_to :not_ended }

      context 'for single instance' do
        subject { User.new }

        it { should respond_to :published? }
        it { should respond_to :not_published? }
        it { should_not respond_to :removed? }
        it { should_not respond_to :not_removed? }
        it { should respond_to :started? }
        it { should respond_to :not_started? }
        it { should_not respond_to :ended? }
        it { should_not respond_to :not_ended? }
      end
    end

    describe :only do
      before do
        microscope 'User', only: [:admin, :removed_at, :ended_on]
      end

      it { should_not respond_to :active }
      it { should_not respond_to :not_active }
      it { should_not respond_to :moderator }
      it { should_not respond_to :not_moderator }
      it { should respond_to :admin }
      it { should respond_to :not_admin }
      it { should_not respond_to :published }
      it { should_not respond_to :not_published }
      it { should respond_to :removed }
      it { should respond_to :not_removed }
      it { should_not respond_to :started }
      it { should_not respond_to :not_started }
      it { should respond_to :ended }
      it { should respond_to :not_ended }

      context 'for single instance' do
        subject { User.new }

        it { should respond_to :removed? }
        it { should respond_to :not_removed? }
        it { should_not respond_to :published? }
        it { should_not respond_to :not_published? }
        it { should respond_to :ended? }
        it { should respond_to :not_ended? }
        it { should_not respond_to :started? }
        it { should_not respond_to :not_started? }
      end
    end

    describe 'except and only' do
      before do
        microscope 'User', only: [:admin, :started_on], except: [:active]
      end

      it { should_not respond_to :active }
      it { should_not respond_to :not_active }
      it { should_not respond_to :moderator }
      it { should_not respond_to :not_moderator }
      it { should respond_to :admin }
      it { should respond_to :not_admin }
      it { should respond_to :started }
      it { should respond_to :not_started }
      it { should_not respond_to :published }
      it { should_not respond_to :not_published }
      it { should_not respond_to :removed }
      it { should_not respond_to :not_removed }
      it { should_not respond_to :ended }
      it { should_not respond_to :not_ended }

      context 'for single instance' do
        subject { User.new }

        it { should respond_to :started? }
        it { should respond_to :not_started? }
        it { should_not respond_to :removed? }
        it { should_not respond_to :not_removed? }
        it { should_not respond_to :published? }
        it { should_not respond_to :not_published? }
        it { should_not respond_to :ended? }
        it { should_not respond_to :not_ended? }
      end
    end
  end
end
