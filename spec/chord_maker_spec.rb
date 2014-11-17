require 'spec_helper'

describe ChordMaker do

  before { @chords = ChordMaker.new }
  subject{ @chords }

  it "should have instance variables" do
    expect(@chords.base_pitch).to be_kind_of(Integer)
    expect(@chords.score).to be_kind_of(Array)
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

  describe "choose_form" do
    it "should return a random number when no argument is supplied" do
      expect(@chords.choose_form).to be_between(1, 6).inclusive
    end

    it "should return the passed number when an argument is supplied" do
      expect(@chords.choose_form( 4 )).to eq(4)
    end

    it "raises an error if the argument is not a number" do
      expect { @chords.choose_form("boo berries") }.to raise_error
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
      expect(@chords.score[0]).to be_kind_of(Array)
    end

    describe "generate_section" do
      before do
        allow(@chords).to receive(:no_argument_trans).and_return( [:trans_invert_1] )
        @phrase_length = 1
      end

      describe "first section" do
        before { @score = [] }

        it "should generate a phrase from @base_chord" do
          expect(@chords.generate_section[0]).to eq( [[ 61, 62, 63, 64 ]] )
        end
      end

      describe "subsequent sections" do
        before { @score = [[[ 1, 2, 3, 4 ]]] }

        it "should generate phrase from an altered chord" do
          expect(@chords.generate_section[1]).not_to eq( [[ 61, 62, 63, 64 ]] )
          # something is amiss...
        end
      end
    end

    describe "generate_phrase" do

      before { @base_chord = [ 1, 2, 3, 4 ] }
      before { subject.phrase_length = 2 }

      it "should assign chords 'phrase_length' number of times" do
        expect(@chords.generate_phrase(@base_chord).length).to eq(@chords.phrase_length)
      end

      it "should assign arrays of chords to phrase" do
        expect(@chords.generate_phrase(@base_chord)[0]).to be_kind_of(Array)
      end

      it "returns a phrase array containing mutltiple nested chord arrays" do
        expect(@chords.generate_phrase(@base_chord)).to eq( [ @base_chord, @base_chord ] )
      end
    end
  end

  describe "choose_phrase_length" do
    before { @chords.choose_phrase_length }
    it "should choose 3, 4, 6, or 8" do
      expect(@chords.phrase_length).to be_between(3, 8).inclusive
      expect(@chords.phrase_length).not_to be(5)
      expect(@chords.phrase_length).not_to be(7)
    end
  end



  describe "print_score_max_format" do
    before { @chords.score = [ 1, 2, 3, 4 ] }
    it "should display score as space-separated list" do
      expect(@chords.print_score_max_format).to eq( '1 2 3 4' )
    end
  end

end