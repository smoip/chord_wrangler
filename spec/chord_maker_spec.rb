require 'spec_helper'

describe ChordMaker do

  subject{ ChordMaker.new }

  it "should have instance variables" do
    expect(subject.base_pitch).to be_kind_of(Integer)
    expect(subject.score).to be_kind_of(Array)
  end

  describe "generate_chord" do

    it "should return an array" do
      expect(subject.generate_chord).to be_kind_of(Array)
    end

    it "should have four unique members" do
      test_chord = subject.generate_chord

      expect(test_chord.length).to eq(4)
      expect(test_chord.uniq).to eq(test_chord)
    end
  end

  describe "choose_member" do
    it "should choose a number between 0 and 11" do
      expect(subject.choose_member).to be_between(0, 11).inclusive
    end
  end

  describe "choose_form" do
    it "should return a random number when no argument is supplied" do
      expect(subject.choose_form).to be_between(1, 6).inclusive
    end

    it "should return the passed number when an argument is supplied" do
      expect(subject.choose_form( 4 )).to eq(4)
    end

    it "raises an error if the argument is not a number" do
      expect { subject.choose_form("boo berries") }.to raise_error
    end
  end

  describe "generate_score" do
    before do
      subject.base_pitch = 60
      allow(subject).to receive(:generate_chord).and_return( [1, 2, 3, 4] )
      subject.generate_score
    end

    it "should shift base_chord to base_pitch" do
      expect(subject.base_chord).to eq( [61, 62, 63, 64] )
    end
    it "should assign chords to score" do
      expect(subject.score[0]).to be_kind_of(Array)
      # don't test on Type - also this test doesn't do much right now
    end

    describe "generate_section" do
      before do
        allow(subject).to receive(:no_argument_trans).and_return( [:trans_invert_1] )
        subject.phrase_length = 1
      end

      describe "first section" do
        before { subject.score = [] }

        it "should generate a phrase from base_chord" do
          expect(subject.generate_section).to eq( [ [ subject.base_chord ] ] )
        end
      end

      describe "subsequent sections" do
        before { subject.score = [[[[ 1, 2, 3, 4 ]]]] }

        it "should generate phrase from an altered chord" do
          expect(subject.generate_section).not_to eq( [[[ 1, 2, 3, 4 ]]] )
          # problem is in choose_transformation
          # nesting checks out now
        end
      end
    end

    describe "generate_phrase" do

      before { subject.base_chord = [ 1, 2, 3, 4 ] }
      before { subject.phrase_length = 2 }

      it "should assign chords 'phrase_length' number of times" do
        expect(subject.generate_phrase(subject.base_chord).length).to eq(subject.phrase_length)
      end

      it "should assign arrays of chords to phrase" do
        expect(subject.generate_phrase(subject.base_chord)[0]).to be_kind_of(Array)
      end

      it "returns a phrase array containing mutltiple nested chord arrays" do
        expect(subject.generate_phrase(subject.base_chord)).to eq( [ subject.base_chord, subject.base_chord ] )
      end
    end
  end

  describe "choose_phrase_length" do
    before { subject.choose_phrase_length }
    it "should choose 3, 4, 6, or 8" do
      expect(subject.phrase_length).to be_between(3, 8).inclusive
      expect(subject.phrase_length).not_to be(5)
      expect(subject.phrase_length).not_to be(7)
    end
  end



  describe "print_score_max_format" do
    before { subject.score = [ 1, 2, 3, 4 ] }
    it "should display score as space-separated list" do
      expect(subject.print_score_max_format).to eq( '1 2 3 4' )
    end
  end

end