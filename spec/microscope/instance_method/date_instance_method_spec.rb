require 'spec_helper'

describe Microscope::InstanceMethod::DateInstanceMethod do
  before do
    run_migration do
      create_table(:events, force: true) do |t|
        t.date :start_date, default: nil
        t.date :started_on, default: nil
      end
    end

    microscope 'Event'
  end

  describe '#start_date being ignored' do
    specify do
      expect { Event.create(start_date: 2.months.ago) }.to_not raise_error
    end
  end

  describe '#started?' do
    context 'with positive result' do
      subject { Event.create(started_on: 2.months.ago) }
      it { should be_started }
      it { should_not be_not_started }
    end

    context 'with negative result' do
      subject { Event.create(started_on: 1.month.from_now) }
      it { should_not be_started }
      it { should be_not_started }
    end
  end

  describe '#started=' do
    before { subject.started = value }

    context 'with blank argument' do
      subject { Event.create(started_on: 2.months.ago) }
      let(:value) { '0' }

      it { should_not be_started }
    end

    context 'with present argument' do
      subject { Event.create }
      let(:value) { '1' }

      it { should be_started }
    end

    context 'with present argument, twice' do
      subject { Event.create(started_on: time) }
      let(:time) { 2.months.ago }
      let(:value) { '1' }

      it { expect(subject.started_on.day).to eql time.day }
      it { expect(subject.started_on.month).to eql time.month }
      it { expect(subject.started_on.year).to eql time.year }
    end
  end

  describe '#not_started?' do
    context 'with negative result' do
      subject { Event.create(started_on: 2.months.ago) }
      it { should_not be_not_started }
    end

    context 'with positive result' do
      subject { Event.create(started_on: 1.month.from_now) }
      it { should be_not_started }
    end
  end

  describe '#start!' do
    let(:stubbed_date) { Date.parse('2020-03-18 08:00:00') }
    before { Date.stub(:today).and_return(stubbed_date) }

    let(:event) { Event.create(started_on: nil) }
    it { expect { event.start! }.to change { event.reload.started_on }.from(nil).to(stubbed_date) }
  end

  describe '#start!' do
    let(:stubbed_date) { Date.parse('2020-03-18 08:00:00') }

    let(:event) { Event.create(started_on: stubbed_date) }
    it { expect { event.not_start! }.to change { event.reload.started_on }.from(stubbed_date).to(nil) }
    it { expect(event).to respond_to(:unstart!) }
  end
end
