module TransChords

  # methods that choose transformations

  def choose_transformation(*args)
    arguments = trans_arg_parser(args)
    if arguments.length === 2
      transformation =  transform_two_args(arguments[0], arguments[1])
    elsif arguments.length === 1
      transformation = transform_one_arg(arguments[0])
    end
    return transformation
    # return transform_one_arg(arguments[0]) unless arguments.length == 2
    # return transform_two_args(arguments[0], arguments[1]) unless arguments.length == 1
    # somehow I'm repeatedly calling transform_two_args after already calling transform_one_arg
  end

  def transform_one_arg(chord)
    (send(no_argument_trans.sample, chord)).flatten(1)
    # why do I need to flatten this?
  end

  def transform_two_args(chord, arg)
    (send(argument_req_trans.sample, chord, arg)).flatten(1)
    # why do I need to flatten this?
  end


  def trans_arg_parser(*args)
    # needs more testing - is this the problem?
    arguments = args.map { |x| x }
    raise "chord(array) required" unless arguments[0].class == Array
    raise "too many arguments(2 max)" if arguments.length > 2
    if arguments.length == 2
      raise "interval(integer) required" unless arguments[1].class == Integer || arguments[1].class.superclass == Integer
    end
    raise "at least one argument required" if arguments == []
    return arguments
  end

  def no_argument_trans
    # choose a transformation that does NOT take an argument
    trans_methods = TransChords.instance_methods
    trans_methods -= [ :choose_transformation, :trans_arg_parser, :no_argument_trans, :argument_req_trans, :trans_parsimonious_voice_leading ]
    # remove methods that choose methods
    # removed parsimonious vl for testing purposes.  Not working.
    trans_methods -= [ :trans_shift_pitch ]
    # remove methods that require an argument
    # keep this list updated with any methods that need a second argument (pitch shift, etc.)
    return trans_methods
  end

  def argument_req_trans
    # choose a transformation that does take an argument
    trans_methods = [ :trans_shift_pitch ]
    # keep this list updated with any methods that need a second argument (pitch shift, etc.)
    return trans_methods
  end

  #methods that execute transformations

  def trans_ascending(chord)
    chord.sort
  end

  def trans_descending(chord)
    chord.sort.reverse
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
      # 78 is throwing an error when called from choose_transformation
      # needs integration testing
      unique_token = true if trans_chord.uniq == trans_chord
    end
    return trans_chord
  end

end