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
      subject { Event.create(started_at: 2.months.ago) }
      it { should be_started }
    end

    context 'with negative result' do
      subject { Event.create(started_at: 1.month.from_now) }
      it { should_not be_started }
    end
  end

  describe '#started=' do
    before { subject.started = value }

    context 'with blank argument' do
      subject { Event.create(started_at: 2.months.ago) }
      let(:value) { '0' }

      it { should_not be_started }
    end

    context 'with present argument' do
      subject { Event.create }
      let(:value) { '1' }

      it { should be_started }
    end

    context 'with present argument, twice' do
      subject { Event.create(started_at: time) }
      let(:time) { 2.months.ago }
      let(:value) { '1' }

      it { expect(subject.started_at).to eql time }
    end
  end

  describe '#not_started?' do
    context 'with negative result' do
      subject { Event.create(started_at: 2.months.ago) }
      it { should_not be_not_started }
    end

    context 'with positive result' do
      subject { Event.create(started_at: 1.month.from_now) }
      it { should be_not_started }
    end
  end

  describe '#start!' do
    let(:stubbed_date) { Time.parse('2020-03-18 08:00:00') }
    before { Time.stub(:now).and_return(stubbed_date) }

    let(:event) { Event.create(started_at: nil) }
    it { expect { event.start! }.to change { event.reload.started_at }.from(nil).to(stubbed_date) }
    it { expect(event).to respond_to(:start!) }
  end
end
