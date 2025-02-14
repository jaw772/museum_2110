require './lib/patron'
require './lib/exhibit'
require './lib/museum'

RSpec.describe Museum do
  let!(:dmns){Museum.new("Denver Museum of Nature and Science")}
  let!(:gems_and_minerals){Exhibit.new({name: "Gems and Minerals", cost: 0})}
  let!(:dead_sea_scrolls){Exhibit.new({name: "Dead Sea Scrolls", cost: 10})}
  let!(:imax){Exhibit.new({name: "IMAX",cost: 15})}
  let(:patron_1){Patron.new("Bob", 20)}
  let(:patron_2){Patron.new("Sally", 20)}
  let(:patron_3){Patron.new("Johnny", 5)}

  describe '#initialize' do
    it "exists" do
      expect(dmns).to be_a Museum
    end

    it "has attributes" do
      expect(dmns.name).to eq "Denver Museum of Nature and Science"
    end
  end

  describe 'exhibits' do
    it "is an attribute" do
      expect(dmns.exhibits).to eq []
    end

    it "adds exhibits" do
      dmns.add_exhibit(gems_and_minerals)
      dmns.add_exhibit(dead_sea_scrolls)
      dmns.add_exhibit(imax)
      expect(dmns.exhibits).to eq [gems_and_minerals, dead_sea_scrolls, imax]
    end
  end

  describe "patrons" do
    it "adds interests to patrons" do
      patron_1.add_interest("Dead Sea Scrolls")
      patron_1.add_interest("Gems and Minerals")
      expect(patron_1.interests).to eq ["Dead Sea Scrolls", "Gems and Minerals"]
      patron_2.add_interest("IMAX")
      expect(patron_2.interests).to eq ["IMAX"]
    end

    it "recommends exhibits " do
      dmns.add_exhibit(gems_and_minerals)
      dmns.add_exhibit(dead_sea_scrolls)
      dmns.add_exhibit(imax)
      patron_1.add_interest("Dead Sea Scrolls")
      patron_1.add_interest("Gems and Minerals")
      patron_2.add_interest("IMAX")

      expect(dmns.recommend_exhibits(patron_1)).to eq [dead_sea_scrolls, gems_and_minerals]
      expect(dmns.recommend_exhibits(patron_2)).to eq [imax]
    end

    it '::patrons' do
      expect(dmns.patrons).to eq []
    end

    it "admits patrons" do
      dmns.admit(patron_1)
      dmns.admit(patron_2)
      dmns.admit(patron_3)
      expect(dmns.patrons).to eq [patron_1, patron_2, patron_3]
    end

    it "sorts patrons by exhibit" do
      dmns.add_exhibit(gems_and_minerals)
      dmns.add_exhibit(dead_sea_scrolls)
      dmns.add_exhibit(imax)
      dmns.admit(patron_1)
      dmns.admit(patron_2)
      dmns.admit(patron_3)
      patron_1.add_interest("Gems and Minerals")
      patron_2.add_interest("Dead Sea Scrolls")
      patron_3.add_interest("Dead Sea Scrolls")

      expected = {
        gems_and_minerals => [patron_1],
        dead_sea_scrolls => [patron_2, patron_3],
        imax => []
      }
      expect(dmns.patrons_by_exhibit_interest).to eq expected
    end
  end
end
