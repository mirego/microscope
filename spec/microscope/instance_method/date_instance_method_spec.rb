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
      let(:event) { Event.create(started_on: 2.months.ago) }
      it { expect(event).to be_started }
      it { expect(event).to_not be_not_started }
    end

    context 'with negative result' do
      let(:event) { Event.create(started_on: 1.month.from_now) }
      it { expect(event).to_not be_started }
      it { expect(event).to be_not_started }
    end
  end

  describe '#started=' do
    before { event.started = value }

    context 'with blank argument' do
      let(:event) { Event.create(started_on: 2.months.ago) }
      let(:value) { '0' }

      it { expect(event).to_not be_started }
    end

    context 'with present argument' do
      let(:event) { Event.create }
      let(:value) { '1' }

      it { expect(event).to be_started }
    end

    context 'with present argument, twice' do
      let(:event) { Event.create(started_on: time) }
      let(:time) { 2.months.ago }
      let(:value) { '1' }

      it { expect(event.started_on.day).to eql time.day }
      it { expect(event.started_on.month).to eql time.month }
      it { expect(event.started_on.year).to eql time.year }
    end
  end

  describe '#not_started?' do
    context 'with negative result' do
      let(:event) { Event.create(started_on: 2.months.ago) }
      it { expect(event).to_not be_not_started }
      it { expect(event).to respond_to(:unstarted?) }
    end

    context 'with positive result' do
      let(:event) { Event.create(started_on: 1.month.from_now) }
      it { expect(event).to be_not_started }
    end
  end

  describe '#mark_as_started!' do
    let(:stubbed_date) { Date.parse('2020-03-18 08:00:00') }
    before { allow(Date).to receive(:today).and_return(stubbed_date) }

    let(:event) { Event.create(started_on: nil) }
    it { expect { event.mark_as_started! }.to change { event.reload.started_on }.from(nil).to(stubbed_date) }
  end

  describe '#mark_as_not_started!' do
    let(:stubbed_date) { Date.parse('2020-03-18 08:00:00') }

    let(:event) { Event.create(started_on: stubbed_date) }
    it { expect { event.mark_as_not_started! }.to change { event.reload.started_on }.from(stubbed_date).to(nil) }
  end

  describe '#mark_as_started' do
    let(:stubbed_date) { Date.parse('2020-03-18 08:00:00') }
    before { allow(Date).to receive(:today).and_return(stubbed_date) }

    let(:event) { Event.create(started_on: nil) }
    it { expect { event.mark_as_started }.to_not change { event.reload.started_on } }
    it { expect { event.mark_as_started }.to change { event.started_on }.from(nil).to(stubbed_date) }
  end

  describe '#mark_as_not_started' do
    let(:stubbed_date) { Date.parse('2020-03-18 08:00:00') }

    let(:event) { Event.create(started_on: stubbed_date) }
    it { expect { event.mark_as_not_started }.to_not change { event.reload.started_on } }
    it { expect { event.mark_as_not_started }.to change { event.started_on }.from(stubbed_date).to(nil) }
    it { expect(event).to respond_to(:mark_as_unstarted) }
  end
end
