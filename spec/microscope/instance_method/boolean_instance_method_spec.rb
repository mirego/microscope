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
    it { expect(animal).to respond_to(:un_feed!) }
  end
end
