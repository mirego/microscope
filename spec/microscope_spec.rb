require 'spec_helper'

describe Microscope do
  describe :acts_as_microscope_without_database do
    specify do
      adapter = ENV['DB_ADAPTER'] || 'sqlite3'
      setup_database(adapter: adapter, database: 'microscope_test_that_does_not_exist')

      class User < ActiveRecord::Base
        acts_as_microscope
      end
    end
  end

  describe :acts_as_microscope do
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
        microscope 'User', except: %i(admin removed_at ended_on)
      end

      it { expect(User).to respond_to :active }
      it { expect(User).to respond_to :not_active }
      it { expect(User).to respond_to :moderator }
      it { expect(User).to respond_to :not_moderator }
      it { expect(User).to_not respond_to :admin }
      it { expect(User).to_not respond_to :not_admin }
      it { expect(User).to respond_to :published }
      it { expect(User).to respond_to :not_published }
      it { expect(User).to_not respond_to :removed }
      it { expect(User).to_not respond_to :not_removed }
      it { expect(User).to respond_to :started }
      it { expect(User).to respond_to :not_started }
      it { expect(User).to_not respond_to :ended }
      it { expect(User).to_not respond_to :not_ended }

      context 'for single instance' do
        let(:user) { User.new }

        it { expect(user).to respond_to :published? }
        it { expect(user).to respond_to :not_published? }
        it { expect(user).to_not respond_to :removed? }
        it { expect(user).to_not respond_to :not_removed? }
        it { expect(user).to respond_to :started? }
        it { expect(user).to respond_to :not_started? }
        it { expect(user).to_not respond_to :ended? }
        it { expect(user).to_not respond_to :not_ended? }
      end
    end

    describe :only do
      before do
        microscope 'User', only: %i(admin removed_at ended_on)
      end

      it { expect(User).to_not respond_to :active }
      it { expect(User).to_not respond_to :not_active }
      it { expect(User).to_not respond_to :moderator }
      it { expect(User).to_not respond_to :not_moderator }
      it { expect(User).to respond_to :admin }
      it { expect(User).to respond_to :not_admin }
      it { expect(User).to_not respond_to :published }
      it { expect(User).to_not respond_to :not_published }
      it { expect(User).to respond_to :removed }
      it { expect(User).to respond_to :not_removed }
      it { expect(User).to_not respond_to :started }
      it { expect(User).to_not respond_to :not_started }
      it { expect(User).to respond_to :ended }
      it { expect(User).to respond_to :not_ended }

      context 'for single instance' do
        let(:user) { User.new }

        it { expect(user).to respond_to :removed? }
        it { expect(user).to respond_to :not_removed? }
        it { expect(user).to_not respond_to :published? }
        it { expect(user).to_not respond_to :not_published? }
        it { expect(user).to respond_to :ended? }
        it { expect(user).to respond_to :not_ended? }
        it { expect(user).to_not respond_to :started? }
        it { expect(user).to_not respond_to :not_started? }
      end
    end

    describe 'except and only' do
      before do
        microscope 'User', only: %i(admin started_on), except: %i(active)
      end

      it { expect(User).to_not respond_to :active }
      it { expect(User).to_not respond_to :not_active }
      it { expect(User).to_not respond_to :moderator }
      it { expect(User).to_not respond_to :not_moderator }
      it { expect(User).to respond_to :admin }
      it { expect(User).to respond_to :not_admin }
      it { expect(User).to respond_to :started }
      it { expect(User).to respond_to :not_started }
      it { expect(User).to_not respond_to :published }
      it { expect(User).to_not respond_to :not_published }
      it { expect(User).to_not respond_to :removed }
      it { expect(User).to_not respond_to :not_removed }
      it { expect(User).to_not respond_to :ended }
      it { expect(User).to_not respond_to :not_ended }

      context 'for single instance' do
        let(:user) { User.new }

        it { expect(user).to respond_to :started? }
        it { expect(user).to respond_to :not_started? }
        it { expect(user).to_not respond_to :removed? }
        it { expect(user).to_not respond_to :not_removed? }
        it { expect(user).to_not respond_to :published? }
        it { expect(user).to_not respond_to :not_published? }
        it { expect(user).to_not respond_to :ended? }
        it { expect(user).to_not respond_to :not_ended? }
      end
    end
  end
end
