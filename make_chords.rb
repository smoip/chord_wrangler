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
    @phrase_length = [3, 4, 6, 8].shuffle.first
  end

  def choose_transformation(chord)
    trans_methods = [ :trans_ascending, :trans_descending, :trans_invert_1, :trans_invert_2, :trans_invert_3, :trans_parsimonious_voice_leading ]
    # consider refactor to pull all transform methods into a module or class
    # then instead of explicity naming all methods in array, use module_name.instance_methods to populate array with all extant methods
    # this methods will not work for methods that require multiple inputs (eg chord and shift amount)
    send(trans_methods.sample, chord)
  end

  def trans_ascending(chord)
    chord.sort!
  end

  def trans_descending(chord)
    chord.sort.reverse!
  end

  def trans_invert_1(chord)
    chord.rotate
  end

  def trans_invert_2(chord)
    chord.rotate(2)
  end

  def trans_invert_3(chord)
    chord.rotate(3)
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

  def trans_shift_pitch(chord, shift_amount)
    chord.each.collect do |member|
      member += shift_amount
    end
  end

  def trans_parsimonious_voice_leading(chord)
    unique_token = false
    until unique_token == true
      trans_chord = chord.dup
      changed_member = ( rand(chord.length) ) - 1
      change_amount = [ -1, 1, -2, 2 ].shuffle.first
      trans_chord[changed_member] += change_amount
      unique_token = true if trans_chord.uniq == trans_chord
    end
    return trans_chord
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