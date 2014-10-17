class MakeChords

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
  end

  def trans_ascending(chord)
    chord.sort!
  end

  def trans_descending(chord)
    chord.sort.reverse!
  end

  def generate_score
    @base_chord = shift_pitch(generate_chord, @base_pitch)
    @score << @base_chord
  end

  def shift_pitch(chord, shift_amount)
    chord.each.collect do |member|
      member += shift_amount
    end
  end

  def print_score
    puts "Generated Score: #{@score.flatten.to_s}"
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
  chords.print_score_max_format
end