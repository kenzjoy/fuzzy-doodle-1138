require 'rails_helper'

RSpec.describe Mechanic, type: :model do
  it { should have_many(:mechanic_rides) }
end