require 'spec_helper'

describe Microscope::InstanceMethod::BooleanInstanceMethod do
  before do
    run_migration do
      create_table(:events, force: true) do |t|
        t.boolean :sent, default: false
      end
    end

    microscope 'Event'
  end

  describe '#start!' do
    let(:event) { Event.create(sent: false) }
    it { expect { event.send! }.to change { event.reload.sent }.from(false).to(true) }
  end
end
