require 'spec_helper'

describe Microscope::InstanceMethod::BooleanInstanceMethod do
  before do
    run_migration do
      create_table(:events, force: true) do |t|
        t.boolean :started, default: false
      end
    end

    microscope 'Event'
  end

  describe '#start!' do
    let(:event) { Event.create(started: false) }
    it { expect { event.start! }.to change { event.reload.started }.from(false).to(true) }
  end
end
