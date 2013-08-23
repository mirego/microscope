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
    before do
      @user1 = User.create(active: true)
      @user2 = User.create(active: false)
    end

    its(:active) { should have(1).items }
    its(:active) { should include(@user1) }
  end

  describe 'negative scope' do
    before do
      @user1 = User.create(active: false)
      @user2 = User.create(active: true)
    end

    its(:not_active) { should have(1).items }
    its(:not_active) { should include(@user1) }
  end
end
