require 'spec_helper'

describe Microscope::InstanceMethod::DateInstanceMethod do
  before do
    run_migration do
      create_table(:events, force: true) do |t|
        t.date :started_on, default: nil
      end
    end

    microscope 'Event'
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
end
