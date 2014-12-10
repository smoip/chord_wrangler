require_relative './trans_chords'

class ChordMaker

  include TransChords

  attr_accessor :base_pitch, :base_chord, :score, :phrase_length

  def initialize
    @base_pitch = 60
    @score = []
  end

  def generate_chord
    chord = []
    until chord.length == 4 do
      chord << choose_member
      chord.uniq!
    end
    return chord
  end

  def choose_member
    rand(11)
  end

  def choose_phrase_length
    @phrase_length ||= [3, 4, 6, 8].shuffle.first
  end

  def choose_form(*args)
    # chooses binary, ternary
    case args[0]
    when Fixnum || Integer
      return args[0]
    when nil
      return ( rand(5) + 1 )
    else
      raise "integer required"
    end
    # still need to implement passing arguments in from generate score
  end

  def base_chord
    @base_chord ||= trans_shift_pitch(generate_chord, @base_pitch)
  end

  def generate_score
    base_chord
    choose_phrase_length
    # change this back after test
    # choose_form.times do
    2.times do
      @score << generate_section
    end
    puts "score: #{@score}"
  end

  def generate_section
    section = []
    if @score == []
      chord = @base_chord
    else
      chord = choose_transformation(@score.last.last.last)
      # this might be the problem - allowing a nil argument to be passed - why?
      # maybe array.last can generate nil - check?
      # YES - calling .last on an emptry array returns nil
      # Examine your data structure
      # I need to see the output of a score object
      # ------> !!!! PAY ATTENTION TO ME!  I'M PROBABLY THE CULPRIT!
      # need to implement choosing between a one and two variable transform
    end
    section << generate_phrase(chord)
    return section
  end

  def generate_phrase(chord)
    phrase = []
    @phrase_length.times do
      phrase << chord
    end
    return phrase
  end

  def print_score
    puts "Generated Score: #{@score.flatten.to_s}"
  end

  def print_score_with_groupings
    puts "Generated Score(groupings shown): #{@score}"
  end

  def print_score_max_format
    max_score = @score.flatten.join(" ")
    puts "Generated Score(max format): #{max_score}"
    puts "Length(for max table): #{@score.flatten.length}"
    return max_score
  end

end

if __FILE__==$0
  chords = ChordMaker.new
  chords.generate_score
  chords.print_score_with_groupings
end