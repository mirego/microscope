require 'spec_helper'

describe Microscope::Scope::DateScope do
  subject { Event }

  before do
    run_migration do
      create_table(:events, force: true) do |t|
        t.date :started_on, default: nil
        t.date :published_date, default: nil
      end
    end

    microscope 'Event'
  end

  describe 'before scope' do
    before do
      @event = Event.create(started_on: 2.months.ago)
      Event.create(started_on: 1.month.from_now)
    end

    it { expect(Event.started_before(1.month.ago).to_a).to eql [@event] }
  end

  describe 'before_today scope' do
    before do
      @event = Event.create(started_on: 2.months.ago)
      Event.create(started_on: 1.month.from_now)
    end

    it { expect(Event.started_before_today.to_a).to eql [@event] }
  end

  describe 'after scope' do
    before do
      @event = Event.create(started_on: 2.months.from_now)
      Event.create(started_on: 1.month.ago)
    end

    it { expect(Event.started_after(1.month.from_now).to_a).to eql [@event] }
  end

  describe 'after_today scope' do
    before do
      @event = Event.create(started_on: 2.months.from_now)
      Event.create(started_on: 1.month.ago)
    end

    it { expect(Event.started_after_today.to_a).to eql [@event] }
  end

  describe 'between scope' do
    before do
      Event.create(started_on: 1.month.ago)
      @event = Event.create(started_on: 3.months.ago)
      Event.create(started_on: 5.month.ago)
    end

    it { expect(Event.started_between(4.months.ago..2.months.ago).to_a).to eql [@event] }
  end

  describe 'super-boolean positive scope' do
    before do
      @event1 = Event.create(started_on: 1.month.ago)
      @event2 = Event.create(started_on: 3.months.ago)
      Event.create(started_on: 2.months.from_now)
      Event.create(started_on: nil)
    end

    it { expect(Event.started.to_a).to eql [@event1, @event2] }
  end

  describe 'super-boolean negative scope' do
    before do
      Event.create(started_on: 1.month.ago)
      Event.create(started_on: 3.months.ago)
      @event1 = Event.create(started_on: 2.months.from_now)
      @event2 = Event.create(started_on: nil)
    end

    it { expect(Event.not_started.to_a).to eql [@event1, @event2] }
  end

  describe 'boolean instance method' do
    context 'for positive record' do
      subject { Event.create(started_on: 3.months.ago) }
      it { should be_started }
    end

    context 'for negative record' do
      subject { Event.create(started_on: 2.months.from_now) }
      it { should_not be_started }
    end
  end

  context 'for field that does not match the pattern' do
    subject { Event }

    it { should_not respond_to(:published_date) }
    it { should_not respond_to(:not_published_date) }
  end
end
