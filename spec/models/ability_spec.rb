require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for admin' do
    let(:user) { create :user, :admin }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :read, Computer }
    it { should be_able_to :reservation, Computer }
    it { should be_able_to :payment, Computer }

    it { should be_able_to :reserve, Computer }
    it { should be_able_to :pay, Computer }

    #it { should_not be_able_to :reserve, Computer, user_id: other.id }

    it { should be_able_to :create, SoftwareRequest }

    it { should be_able_to :replenish, :account }

  end

end
