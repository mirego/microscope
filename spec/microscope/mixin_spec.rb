require 'spec_helper'

describe Microscope::Mixin do
  describe :acts_as_microscope do
    subject { User }

    before do
      run_migration do
        create_table(:users, force: true) do |t|
          t.boolean :active, default: false
          t.boolean :admin, default: false
        end
      end

      microscope 'User', except: [:admin]
    end

    it { should respond_to :active }
    it { should respond_to :not_active }
    it { should_not respond_to :admin }
    it { should_not respond_to :not_admin }
  end

  describe 'Boolean scopes' do
    subject { User }

    before do
      run_migration do
        create_table(:users, force: true) do |t|
          t.boolean :active, default: false
        end
      end

      microscope 'User'
    end

    describe 'positive scope' do
      before { @user1 = User.create(active: true) }

      its(:active) { should have(1).items }
      its(:active) { should include(@user1) }
      its(:not_active) { should be_empty }
    end

    describe 'negative scope' do
      before { @user1 = User.create(active: false) }

      its(:not_active) { should have(1).items }
      its(:not_active) { should include(@user1) }
      its(:active) { should be_empty }
    end
  end

  describe 'DateTime scopes' do
    subject { Event }

    before do
      run_migration do
        create_table(:events, force: true) do |t|
          t.datetime :started_at, default: false
        end
      end

      microscope 'Event'
    end

    describe 'before scope' do
      before do
        @event = Event.create(started_at: 2.months.ago)
        Event.create(started_at: 1.month.from_now)
      end

      it { expect(Event.started_before(1.month.ago).to_a).to eql [@event] }
    end

    describe 'before_now scope' do
      before do
        @event = Event.create(started_at: 2.months.ago)
        Event.create(started_at: 1.month.from_now)
      end

      it { expect(Event.started_before_now.to_a).to eql [@event] }
    end

    describe 'after scope' do
      before do
        @event = Event.create(started_at: 2.months.from_now)
        Event.create(started_at: 1.month.ago)
      end

      it { expect(Event.started_after(1.month.from_now).to_a).to eql [@event] }
    end

    describe 'after_now scope' do
      before do
        @event = Event.create(started_at: 2.months.from_now)
        Event.create(started_at: 1.month.ago)
      end

      it { expect(Event.started_after_now.to_a).to eql [@event] }
    end

    describe 'between scope' do
      before do
        Event.create(started_at: 1.month.ago)
        @event = Event.create(started_at: 3.months.ago)
        Event.create(started_at: 5.month.ago)
      end

      it { expect(Event.started_between(4.months.ago..2.months.ago).to_a).to eql [@event] }
    end
  end
end
