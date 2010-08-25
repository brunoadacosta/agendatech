require 'spec_helper'

describe Grupo do
  it { should validate_presence_of :nome }

  describe "uniqueness of name" do
    before(:each) { Grupo.create(:nome => 'GURU-SP') }
    it { should validate_uniqueness_of :nome }
  end

  describe "#aprovar!" do
    let(:grupo) { described_class.create(:nome => 'GURU-SP', :aprovado => false) }
    subject { grupo }

    before(:each) { grupo.aprovar! }
    its(:aprovado) { should be_true }
  end

  describe "#reprovar!" do
    let(:grupo) { described_class.create(:nome => 'GURU-SP', :aprovado => true) }
    subject { grupo }

    before(:each) { grupo.reprovar! }
    its(:aprovado) { should be_false }
  end
end
