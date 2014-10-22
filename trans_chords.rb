module TransChords

  def choose_transformation(chord)
    trans_methods = TransChords.instance_methods
    trans_methods -= [ :choose_transformation ]
    # this approach will not work for methods that require multiple inputs (eg chord and shift amount)
    # arbitrary number of arguments and cases which direct number of arguments to appropriate methods?
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

end