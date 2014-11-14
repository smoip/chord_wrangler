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

      before { @base_chord = [ 1, 2, 3, 4 ]}

      it "should assign chords 'phrase_length' number of times" do
        expect(@chords.generate_phrase(@base_chord).length).to eq(@chords.phrase_length)
      end

      it "should assign arrays of chords to phrase" do
        expect(@chords.generate_phrase(@base_chord)[0]).to be_kind_of(Array)
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

  describe "chord transformations" do
    let(:chord) { [1, 3, 5, 7] }



    describe "choose_transformation" do
      it "should return an altered chord array" do
        expect(@chords.choose_transformation(chord)).not_to eq(chord)
        expect(@chords.choose_transformation(chord)).to eq(chord)
        expect(@chords.choose_transformation(chord)).to be_kind_of(Array)
      end

      describe "transformation choice" do
        describe "trans_arg_parser" do
          it "returns an array of one argument" do
            expect(@chords.trans_arg_parser(chord)).to eq([ chord ])
          end
          it "returns an array of two arguments" do
            expect(@chords.trans_arg_parser(chord, 12)).to eq([ chord, 12 ])
          end
          it "raises an error if the first argument is not a an array" do
            expect { @chords.trans_arg_parser( 'foo' ) }.to raise_error
          end
          it "raises an error if the second argument (if present) is not an integer" do
            expect { @chords.trans_arg_parser( chord, 'foo' ) }.to raise_error
          end
          it "raises an error if there are more than two arguments" do
            expect { @chords.trans_arg_parser( chord, 1, 'foo' ) }.to raise_error
          end
        end

        describe "no_argument_trans" do
          it "should choose a method name" do
            expect(@chords.no_argument_trans[0]).to be_kind_of(Symbol)
          end
          it "should not choose a method which chooses methods" do
            expect(@chords.no_argument_trans).not_to include( :choose_transformation, :trans_arg_parser, :no_argument_trans, :argument_req_trans )
          end
          it "should not choose a method which requires an argument" do
            expect(@chords.no_argument_trans).not_to include( :trans_shift_pitch )
          end
        end

        describe "argument_req_trans" do
          it "should choose a method name" do
            expect(@chords.argument_req_trans[0]).to be_kind_of(Symbol)
          end
          it "should not choose a method which does NOT require an argument" do
            expect(@chords.argument_req_trans).not_to include( :trans_ascending )
          end
        end
      end
    end

    describe "trans_shift_pitch" do
      it "should add the base_pitch to a given chord array" do
        expect(@chords.trans_shift_pitch( chord, 60 )).to eq( [61, 63, 65, 67] )
      end
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
      it "should rotate the collection by 1 (first inversion)" do
        expect(@chords.trans_invert_1(chord)).to eq( [ 3, 5, 7, 1 ] )
      end
    end

    describe "trans_invert_2" do
      it "should rotate the collection by 2 (second inversion)" do
        expect(@chords.trans_invert_2(chord)).to eq( [ 5, 7, 1, 3 ] )
      end
    end

    describe "trans_invert_3" do
      it "should rotate the collection by 3 (third inversion)" do
        expect(@chords.trans_invert_3(chord)).to eq( [ 7, 1, 3, 5 ] )
      end
    end

    describe "trans_parsimonious_voice_leading" do
      it "should alter one chord member" do
        expect(@chords.trans_parsimonious_voice_leading(chord)).not_to eq(chord)
      end
      it "should check for uniqueness" do
        expect(@chords.trans_parsimonious_voice_leading(chord).uniq.length).to eq(chord.length)
      end
    end
  end

  describe "print_score_max_format" do
    before { @chords.score = [ 1, 2, 3, 4 ] }
    it "should display score as space-separated list" do
      expect(@chords.print_score_max_format).to eq( '1 2 3 4' )
    end
  end

end