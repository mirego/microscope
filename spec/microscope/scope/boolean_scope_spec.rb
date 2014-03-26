require 'spec_helper'

describe Microscope::Scope::BooleanScope do
  before do
    run_migration do
      create_table(:users, force: true) do |t|
        t.boolean :active, default: false
      end
    end

    microscope 'User'
  end

  describe 'positive scope' do
    before do
      @user1 = User.create(active: true)
      @user2 = User.create(active: false)
    end

    it { expect(User.active).to have(1).items }
    it { expect(User.active).to include(@user1) }
  end

  describe 'negative scope' do
    before do
      @user1 = User.create(active: false)
      @user2 = User.create(active: true)
    end

    it { expect(User.not_active).to have(1).items }
    it { expect(User.not_active).to include(@user1) }
    it { expect(User.unactive.to_a).to eql User.not_active.to_a }
  end
end
