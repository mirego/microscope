require 'spec_helper'

describe Microscope::InstanceMethod::BooleanInstanceMethod do
  before do
    run_migration do
      create_table(:animals, force: true) do |t|
        t.boolean :fed, default: false
      end
    end

    microscope 'Animal'
  end

  describe '#feed!' do
    let(:animal) { Animal.create(fed: false) }
    it { expect { animal.feed! }.to change { animal.reload.fed? }.from(false).to(true) }
  end

  describe '#not_feed!' do
    let(:animal) { Animal.create(fed: true) }
    it { expect { animal.not_feed! }.to change { animal.reload.fed? }.from(true).to(false) }
    it { expect(animal).to respond_to(:unfeed!) }
  end

  describe '#mark_as_fed' do
    let(:animal) { Animal.create(fed: false) }
    it { expect { animal.mark_as_fed }.to_not change { animal.reload.fed? } }
    it { expect { animal.mark_as_fed }.to change { animal.fed? }.from(false).to(true) }
  end

  describe '#mark_as_not_fed' do
    let(:animal) { Animal.create(fed: true) }
    it { expect { animal.mark_as_not_fed }.to_not change { animal.reload.fed? } }
    it { expect { animal.mark_as_not_fed }.to change { animal.fed? }.from(true).to(false) }
    it { expect(animal).to respond_to(:mark_as_unfed) }
  end
end
