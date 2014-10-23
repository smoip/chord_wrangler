module TransChords

  def choose_transformation(*args)
    arguments = self.trans_arg_parser(args)
    if arguments.length == 1
      trans_methods = no_argument_trans
      send(trans_methods.sample, arguments[0])
    else
      trans_methods = argument_req_trans
      send(trans_methods.sample, arguments[0], arguments[1])
    end
    #  Needs testing.  Gross
  end

  def trans_arg_parser(*args)
    arguments = []
    args.each do |x|
      arguments << x
    end
    raise 'chord required' if arguments[0] == 0 || arguments[0] == nil
    raise 'too many arguments' if arguments.length > 2
    # Catch these?
    return arguments
  end

  def no_argument_trans
    trans_methods = TransChords.instance_methods
    trans_methods -= [ :choose_transformation, :trans_arg_parser, :trans_shift_pitch ]
    # keep this list updated with any methods that need a second argument (pitch shift, etc.)
    return trans_methods
    # testing
  end

  def argument_req_trans
    trans_methods = [ :trans_shift_pitch ]
    return trans_methods
    # testing
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