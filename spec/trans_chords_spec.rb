require 'spec_helper'

describe "chord transformations" do
  let(:subject) { ChordMaker.new }
  let(:chord) { [1, 3, 5, 7] }

  describe "choose_transformation" do
    it "should return a one-dimensional array with the same number of elements as the input chord" do
      expect(subject.choose_transformation(chord).length).to eq( chord.length )
      expect(subject.choose_transformation(chord)[0][0]).to eq( nil )
       # on to something with line 10 failing...
    end
    it "should return an altered chord array" do
      expect(subject.choose_transformation(chord)).not_to eq( chord )
    end

    describe "transformation choice" do
      describe "trans_arg_parser" do
        it "returns an array of one argument" do
          expect(subject.trans_arg_parser(chord)).to eq([ chord ])
        end
        it "returns an array of two arguments" do
          expect(subject.trans_arg_parser(chord, 12)).to eq([ chord, 12 ])
        end
        it "raises an error if the first argument is not a an array" do
          expect { subject.trans_arg_parser( 'foo' ) }.to raise_error
        end
        it "raises an error if the second argument (if present) is not an integer" do
          expect { subject.trans_arg_parser( chord, 'foo' ) }.to raise_error
        end
        it "raises an error if there are more than two arguments" do
          expect { subject.trans_arg_parser( chord, 1, 'foo' ) }.to raise_error
        end
      end

      describe "no_argument_trans" do
        it "should choose a valid method name" do
          expect(subject.no_argument_trans).to include( :trans_ascending )
        end
        it "should not choose a method which chooses methods" do
          expect(subject.no_argument_trans).not_to include( :choose_transformation, :trans_arg_parser, :no_argument_trans, :argument_req_trans )
        end
        it "should not choose a method which requires an argument" do
          expect(subject.no_argument_trans).not_to include( :trans_shift_pitch )
        end
      end

      describe "argument_req_trans" do
        it "should choose a method name" do
          expect(subject.argument_req_trans[0]).to be_kind_of(Symbol)
        end
        it "should not choose a method which does NOT require an argument" do
          expect(subject.argument_req_trans).not_to include( :trans_ascending )
        end
      end
    end
  end

  describe "trans_shift_pitch" do
    it "should add the base_pitch to a given chord array" do
      expect(subject.trans_shift_pitch( chord, 60 )).to eq( [61, 63, 65, 67] )
    end
  end

  describe "trans_alberti" do
  end

  describe "trans_ascending" do
    it "should put members in ascending order" do
      expect(subject.trans_ascending( [9, 1, 4, 3] )).to eq( [1, 3, 4, 9] )
    end
  end

  describe "trans_descending" do
    it "should put members in descending order" do
      expect(subject.trans_descending( [9, 1, 4, 3] )).to eq( [9, 4, 3, 1] )
    end
  end

  describe "trans_invert_1" do
    it "should rotate the collection by 1 (first inversion)" do
      expect(subject.trans_invert_1(chord)).to eq( [ 3, 5, 7, 1 ] )
    end
  end

  describe "trans_invert_2" do
    it "should rotate the collection by 2 (second inversion)" do
      expect(subject.trans_invert_2(chord)).to eq( [ 5, 7, 1, 3 ] )
    end
  end

  describe "trans_invert_3" do
    it "should rotate the collection by 3 (third inversion)" do
      expect(subject.trans_invert_3(chord)).to eq( [ 7, 1, 3, 5 ] )
    end
  end

  describe "trans_parsimonious_voice_leading" do
    it "should alter one chord member" do
      expect(subject.trans_parsimonious_voice_leading(chord)).not_to eq(chord)
    end
    it "should check for uniqueness" do
      expect(subject.trans_parsimonious_voice_leading(chord).uniq.length).to eq(chord.length)
    end
  end
end