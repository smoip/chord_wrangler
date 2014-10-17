require 'spec_helper'

describe MakeChords do

  before { @chords = MakeChords.new }
  subject{ @chords }

  it "should have instance variables" do
    expect(@chords.base_pitch).to be_kind_of(Integer)
    expect(@chords.base_chord).to be_kind_of(Array)
    expect(@chords.score).to be_kind_of(Array)
    expect(@chords.phrase_length).to be_kind_of(Integer)
  end

  describe "generate_chord" do

    it "should return an array" do
      expect(@chords.generate_chord).to be_kind_of(Array)
    end

    it "should have four unique members" do
      test_chord = @chords.generate_chord

      expect(test_chord.length).to eq(4)
      expect(test_chord.uniq).to eq(test_chord)
    end
  end

  describe "choose_member" do
    it "should choose a number between 0 and 11" do
      expect(@chords.choose_member).to be_between(0, 11).inclusive
    end
  end

  describe "generate_score" do
    before do
      @chords.base_pitch = 60
      allow(@chords).to receive(:generate_chord).and_return( [1, 2, 3, 4] )
      @chords.generate_score
    end

    it "should shift base_chord to base_pitch" do
      expect(@chords.base_chord).to eq( [61, 62, 63, 64] )
    end
    it "should assign chords to score" do
      expect(@chords.generate_score[0]).to be_kind_of(Array)
    end
  end

  describe "shift_pitch" do
    it "should add the base_pitch to a given chord array" do
      expect(@chords.shift_pitch( [1, 2, 3, 4], 60 )).to eq( [61, 62, 63, 64] )
    end
  end

  describe "choose_phrase_length" do
    it "should choose 3, 4, 6, or 8" do
      expect(@chords.choose_phrase_length).to be_between(3, 8).inclusive
      expect(@chords.choose_phrase_length).not_to be(5, 7)
    end
  end

  describe "chord transformations" do
    describe "transform_chord" do
    end

    describe "trans_alberti" do
    end

    describe "trans_ascending" do
      it "should put members in ascending order" do
        expect(@chords.trans_ascending( [9, 1, 4, 3] )).to eq( [1, 3, 4, 9] )
      end
    end

    describe "trans_descending" do
      it "should put members in descending order" do
        expect(@chords.trans_descending( [9, 1, 4, 3] )).to eq( [9, 4, 3, 1] )
      end
    end

    describe "trans_invert_1" do
    end

    describe "trans_invert_2" do
    end

    describe "trans_invert_3" do
    end
  end

  describe "print_score_max_format" do
    before { @chords.score = [ 1, 2, 3, 4 ] }
    it "should display score as space-separated list" do
      expect(@chords.print_score_max_format).to eq( '1 2 3 4' )
    end
  end

end