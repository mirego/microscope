require 'spec_helper'

describe Microscope::Scope::BooleanScope do
  describe 'for a valid column name' do
    before do
      run_migration do
        create_table(:oh_users, force: true) do |t|
          t.boolean :active, default: false
        end
      end

      microscope 'User' do
        self.table_name = 'oh_users'
      end
    end

    describe 'positive scope' do
      before do
        @user1 = User.create(active: true)
        @user2 = User.create(active: false)
      end

      it { expect(User.active.length).to eql 1 }
      it { expect(User.active).to include(@user1) }
    end

    describe 'negative scope' do
      before do
        @user1 = User.create(active: false)
        @user2 = User.create(active: true)
      end

      it { expect(User.not_active.length).to eql 1 }
      it { expect(User.not_active).to include(@user1) }
      it { expect(User.unactive.to_a).to eql User.not_active.to_a }
    end
  end

  describe 'for a invalid column name' do
    before do
      run_migration do
        create_table(:users, force: true) do |t|
          t.boolean :public, default: false
        end
      end
    end

    it { expect { microscope 'User' }.to raise_error(Microscope::BlacklistedColumnsError) }
  end
end
