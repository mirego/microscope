require 'spec_helper'

describe Microscope::Scope do
  describe :inject_scopes do
    subject { User }

    before do
      run_migration do
        create_table(:users, force: true) do |t|
          t.boolean :active, default: false
          t.boolean :admin, default: false
          t.boolean :moderator, default: false
        end
      end
    end

    describe :except do
      before do
        microscope 'User', except: [:admin]
      end

      it { should respond_to :active }
      it { should respond_to :not_active }
      it { should respond_to :moderator }
      it { should respond_to :not_moderator }
      it { should_not respond_to :admin }
      it { should_not respond_to :not_admin }
    end

    describe :only do
      before do
        microscope 'User', only: [:admin]
      end

      it { should_not respond_to :active }
      it { should_not respond_to :not_active }
      it { should_not respond_to :moderator }
      it { should_not respond_to :not_moderator }
      it { should respond_to :admin }
      it { should respond_to :not_admin }
    end

    describe 'except and only' do
      before do
        microscope 'User', only: [:admin], except: [:active]
      end

      it { should_not respond_to :active }
      it { should_not respond_to :not_active }
      it { should_not respond_to :moderator }
      it { should_not respond_to :not_moderator }
      it { should respond_to :admin }
      it { should respond_to :not_admin }
    end
  end
end
