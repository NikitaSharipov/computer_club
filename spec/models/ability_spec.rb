require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for admin' do
    let(:user) { create :user, :admin }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    #let(:other) { create :user }

    it { should_not be_able_to :manage, :all }

    it { should be_able_to :read, Computer }
    it { should be_able_to :payment, Computer }

    it { should be_able_to :pay, Computer }

    it { should be_able_to :index, Reservation }
    it { should be_able_to :date, Reservation }

    it { should be_able_to :create, Reservation, user_id: user.id }
    #it { should_not be_able_to :create, Reservation, user_id: other.id }

    it { should be_able_to :create, SoftwareRequest }

    it { should be_able_to :replenish, :account }

  end

end
