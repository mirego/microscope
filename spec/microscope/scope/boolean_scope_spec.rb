require 'spec_helper'

describe Microscope::Scope::BooleanScope do
  subject { User }

  before do
    run_migration do
      create_table(:users, force: true) do |t|
        t.boolean :active, default: false
      end
    end

    microscope 'User'
  end

  describe 'positive scope' do
    before { @user1 = User.create(active: true) }

    its(:active) { should have(1).items }
    its(:active) { should include(@user1) }
    its(:not_active) { should be_empty }
  end

  describe 'negative scope' do
    before { @user1 = User.create(active: false) }

    its(:not_active) { should have(1).items }
    its(:not_active) { should include(@user1) }
    its(:active) { should be_empty }
  end
end
