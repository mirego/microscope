require 'spec_helper'

describe Microscope::InstanceMethod::DatetimeInstanceMethod do
  before do
    run_migration do
      create_table(:events, force: true) do |t|
        t.datetime :started_at, default: nil
      end
    end

    microscope 'Event'
  end

  describe '#started?' do
    context 'with positive result' do
      let(:event) { Event.create(started_at: 2.months.ago) }
      it { expect(event).to be_started }
    end

    context 'with negative result' do
      let(:event) { Event.create(started_at: 1.month.from_now) }
      it { expect(event).to_not be_started }
    end
  end

  describe '#started=' do
    before { event.started = value }

    context 'with blank argument' do
      let(:event) { Event.create(started_at: 2.months.ago) }
      let(:value) { '0' }

      it { expect(event).to_not be_started }
    end

    context 'with present argument' do
      let(:event) { Event.create }
      let(:value) { '1' }

      it { expect(event).to be_started }
    end

    context 'with present argument, twice' do
      let(:event) { Event.create(started_at: time) }
      let(:time) { 2.months.ago.beginning_of_hour }
      let(:value) { '1' }

      it { expect(event.started_at).to eql time }
    end
  end

  describe '#not_started?' do
    context 'with negative result' do
      let(:event) { Event.create(started_at: 2.months.ago) }
      it { expect(event).to_not be_not_started }
      it { expect(event).to respond_to(:unstarted?) }
    end

    context 'with positive result' do
      let(:event) { Event.create(started_at: 1.month.from_now) }
      it { expect(event).to be_not_started }
    end
  end

  describe '#mark_as_started!' do
    let(:stubbed_date) { Time.parse('2020-03-18 08:00:00') }
    before { allow(Time).to receive(:now).and_return(stubbed_date) }

    let(:event) { Event.create(started_at: nil) }
    it { expect { event.mark_as_started! }.to change { event.reload.started_at }.from(nil).to(stubbed_date) }
    it { expect(event).to respond_to(:mark_as_started!) }
  end

  describe '#mark_as_not_started!' do
    let(:stubbed_date) { Time.parse('2020-03-18 08:00:00') }

    let(:event) { Event.create(started_at: stubbed_date) }
    it { expect { event.mark_as_not_started! }.to change { event.reload.started_at }.from(stubbed_date).to(nil) }
    it { expect(event).to respond_to(:mark_as_unstarted!) }
    it { expect(event).to respond_to(:mark_as_not_started!) }
  end

  describe '#mark_as_started' do
    let(:stubbed_date) { Time.parse('2020-03-18 08:00:00') }
    before { allow(Time).to receive(:now).and_return(stubbed_date) }

    let(:event) { Event.create(started_at: nil) }
    it { expect { event.mark_as_started }.to_not change { event.reload.started_at } }
    it { expect { event.mark_as_started }.to change { event.started_at }.from(nil).to(stubbed_date) }
  end

  describe '#mark_as_not_started' do
    let(:stubbed_date) { Time.parse('2020-03-18 08:00:00') }

    let(:event) { Event.create(started_at: stubbed_date) }
    it { expect { event.mark_as_not_started }.to_not change { event.reload.started_at } }
    it { expect { event.mark_as_not_started }.to change { event.started_at }.from(stubbed_date).to(nil) }
  end
end
