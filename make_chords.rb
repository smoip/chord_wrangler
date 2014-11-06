require_relative './trans_chords'

class MakeChords

  include TransChords

  attr_accessor :base_pitch, :base_chord, :score, :phrase_length

  def initialize
    @base_pitch = 60
    @base_chord = []
    @score = []
    @phrase_length = 0
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
    @phrase_length = [3, 4, 6, 8].shuffle.first
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
  end

  def generate_score
    @base_chord = trans_shift_pitch(generate_chord, @base_pitch)
    self.choose_phrase_length
    @score << self.generate_phrase(@base_chord)
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
  chords = MakeChords.new
  chords.generate_score
  chords.print_score_with_groupings
end