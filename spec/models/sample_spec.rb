require "rails_helper"

describe Sample do
  context "factories" do
    it "has a valid default factory" do
      expect(FactoryGirl.create(:sample)).to be_valid
    end

    it "has a valid dry_sample factory" do
      expect(FactoryGirl.create(:dry_sample)).to be_valid
    end

    it "has a valid wet_sample factory" do
      expect(FactoryGirl.create(:wet_sample)).to be_valid
    end
  end

  describe "validations" do
    describe "plant_id" do
      it "requires a plant_id to be valid" do
        expect(Sample.new(plant_id: nil)).to_not be_valid
      end
    end
  end

  describe "scopes" do
    describe ".recent" do
      let!(:plant1)  { FactoryGirl.create(:plant) }
      let!(:plant2)  { FactoryGirl.create(:plant2) }
      let!(:sample1) { FactoryGirl.create(:sample, plant: plant1) }
      let!(:sample2) { FactoryGirl.create(:sample, plant: plant2) }

      subject { Sample.recent }

      it "returns the 30 most recent samples" do
        expect(subject).to include(sample1, sample2)
      end
    end

    describe ".most_recent" do
      subject { Sample.most_recent }

      context "when samples exist" do
        let!(:plant1)  { FactoryGirl.create(:plant) }
        let!(:plant2)  { FactoryGirl.create(:plant2) }
        let!(:sample1) { FactoryGirl.create(:sample, plant: plant1) }
        let!(:sample2) { FactoryGirl.create(:sample, plant: plant2) }

        it "returns the most recent sample" do
          expect(subject).to_not include(sample1)
          expect(subject).to     include(sample2)
        end
      end

      context "when no samples exist" do
        it "returns an instance of NullSample" do
          expect(subject.size).to  eq(1)
          expect(subject.first).to be_an_instance_of(Sample::NullSample)
        end
      end
    end
  end

  describe "class methods" do
    describe ".null_sample" do
      let(:sample) { FactoryGirl.create(:sample) }

      subject { Sample.null_sample }

      it "returns an instance of a NullSample" do
        expect(subject).to be_an_instance_of(Sample::NullSample)
      end
    end
  end
end
