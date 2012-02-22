

############################################################################################################
$                         = exports ? here
self                      = ( fetch 'library/barista' ).foo __filename
log                       = self.log
_   = $._                 = {}
$.$ = $$                  = {}
#-----------------------------------------------------------------------------------------------------------
jq_extend                 = ( require 'jquery' ).extend
# $.O                       = O_ADMIN = ( require '../options/ADMIN-options' ).O

#===========================================================================================================
#
#-----------------------------------------------------------------------------------------------------------
$$.new_list = $.new = ( x ) ->
  validate_argument_count_equals  1
  type_of_x = type_of x
  if type_of_x != 'list' and type_of_x != 'text'
    bye "expected a list or a text, got a #{type_of_x}"
  return $.shallow_copy x if type_of_x == 'list'
  #.........................................................................................................
  return x.split ''

#-----------------------------------------------------------------------------------------------------------
$.negate = ( me ) ->
  validate_isa_list me
  return _.negate me

#...........................................................................................................
_.negate = ( me ) ->
  for idx in [ 0 ... me.length ]
    me[ idx ] = negate me[ idx ]

#-----------------------------------------------------------------------------------------------------------
$.reverse = ( me ) ->
  validate_argument_count_equals  1
  validate_isa_list               me
  return _.reverse me

#...........................................................................................................
_.reverse = ( me ) ->
  return me.reverse()

#-----------------------------------------------------------------------------------------------------------
$.subtract = ( me, you ) ->
  validate_argument_count_equals  2
  validate_isa_list               me
  validate_isa_list               you
  return _.subtract me, you

#...........................................................................................................
_.subtract = ( me, you ) ->
  your_elements = new_set you
  remove        = LIST._.remove_key
  #.........................................................................................................
  for idx in [ me.length - 1 .. 0 ] by -1
    remove me, idx if has your_elements, me[ idx ]
  return me

#-----------------------------------------------------------------------------------------------------------
$.add = ( me, you ) ->
  validate_argument_count_equals  2
  validate_isa_list               me
  validate_isa_list               you
  return _.add me, you

#...........................................................................................................
_.add = ( me, you ) ->
  me.splice me.length, 0, you...
  return me

#-----------------------------------------------------------------------------------------------------------
$.shallow_copy = ( me ) ->
  validate_argument_count_equals 1
  validate_isa_list me
  return _.shallow_copy me

#...........................................................................................................
_.shallow_copy = ( me ) ->
  return me.slice()

#-----------------------------------------------------------------------------------------------------------
$.copy = ( me ) ->
  validate_argument_count_equals 1
  validate_isa_list me
  return _.copy me

#...........................................................................................................
_.copy = ( me ) ->
  return jq_extend true, [], me

#-----------------------------------------------------------------------------------------------------------
$.join = ( me, joiner = '' ) ->
  validate_argument_count_equals 2
  validate_isa_list me
  validate_isa_text joiner
  return _.join me, joiner

#...........................................................................................................
_.join = ( me, joiner ) ->
  return me.join joiner

#-----------------------------------------------------------------------------------------------------------
get_join_methods = ->
  names_and_joiners = [
    [ 'join_space',         ' '  ]
    [ 'join_tight',         ''   ]
    [ 'join_comma',         ','  ]
    [ 'join_commaspace',    ', ' ]
    [ 'join_lines',         '\n' ]
    [ 'join_fields',        '\t' ] ]
  #.........................................................................................................
  get_slow_method = ( fast_method ) ->
    return ( me ) ->
      validate_argument_count_equals 1
      validate_isa_list me
      return fast_method me
  #.........................................................................................................
  get_fast_method = ( joiner ) ->
    return ( me ) ->
      return me.join joiner
  #.........................................................................................................
  for facet in names_and_joiners
    [ name, joiner, ] = facet
    _[ name ] = fast_method = get_fast_method joiner
    $[ name ] = get_slow_method fast_method
#...........................................................................................................
get_join_methods()

#-----------------------------------------------------------------------------------------------------------
$.is_empty = ( me ) ->
  validate_argument_count_equals 1
  validate_isa_list me
  return _.is_empty me

#...........................................................................................................
_.is_empty = ( me ) ->
  return me.length == 0


# #-----------------------------------------------------------------------------------------------------------
# $.join_lines = ( me ) ->
#   validate_argument_count_equals 1
#   validate_isa_list me
#   return _.join_lines me

# #...........................................................................................................
# _.join_lines = ( me, joiner ) ->
#   return me.join '\n'

#===========================================================================================================
# FILLING
#-----------------------------------------------------------------------------------------------------------
$.fill = ( me, value ) ->
  validate_argument_count_equals    2
  validate_isa_list                 me
  validate_isnt_undefined           value
  return _.fill me, value

#...........................................................................................................
_.fill = ( me, value ) ->
  for idx in [ 0 ... me.length ]
    me[ idx ] = value
  return me


#===========================================================================================================
# FILTERING
#-----------------------------------------------------------------------------------------------------------
$.filter = ( me, sieve ) ->
  validate_argument_count arguments, 'min': 2, 'max': 3
  validate_isa_list                 me
  validate_isa_function             sieve
  return _.filter me, sieve

#...........................................................................................................
_.filter = ( me, sieve ) ->
  me.splice 0, me.length, ( me.filter sieve )...
  return me


#===========================================================================================================
# STACKS: WORKING ON THE RIGHT END
#-----------------------------------------------------------------------------------------------------------
$.push = ( me, value ) ->
  validate_argument_count_equals  2
  validate_isa_mutable_list       me
  validate_isnt_undefined         value
  return _.push me, value

#...........................................................................................................
_.push = ( me, value ) ->
  me.push value
  return me

#-----------------------------------------------------------------------------------------------------------
$.pop = ( me ) ->
  validate_argument_count_equals 1
  validate_isa_list           me
  return _.pop me

#-----------------------------------------------------------------------------------------------------------
_.pop = ( me ) ->
  return me.pop()


#===========================================================================================================
# QUEUES: WORKING ON THE LEFT END
#-----------------------------------------------------------------------------------------------------------
$.insert = ( me, value ) ->
  validate_argument_count_equals  2
  validate_isa_list               me
  validate_isnt_undefined         value
  return _.insert me, value

#...........................................................................................................
_.insert = ( me, value ) ->
  me.unshift value
  return me

#-----------------------------------------------------------------------------------------------------------
$.pull = ( me ) ->
  validate_argument_count_equals  1
  validate_isa_list               me
  return _.pull me

#...........................................................................................................
_.pull = ( me, value ) ->
  return me.shift()

#===========================================================================================================
# SEARCHING
#-----------------------------------------------------------------------------------------------------------
$.idx_of = ( me, probe ) ->
  validate_argument_count_equals  2
  validate_isa_list               me
  return _.idx_of me, probe

#...........................................................................................................
_.idx_of = ( me, probe ) ->
  return me.indexOf probe

# #-----------------------------------------------------------------------------------------------------------
# $.starts_with = ( me, probe ) ->
#   validate_argument_count_equals 2
#   validate_isa_list me
#   validate_isa_list probe
#   return _.starts_with me, probe

# #-----------------------------------------------------------------------------------------------------------
# $.ends_with = ( me, probe ) ->
#   validate_argument_count_equals 2
#   validate_isa_list me
#   validate_isa_list probe
#   return _.ends_with me, probe

# #-----------------------------------------------------------------------------------------------------------
# _.starts_with = ( me, probe ) ->
#   my_length       = me.length
#   probe_length    = probe.length
#   return false if my_length < probe_length
#   #.........................................................................................................
#   for idx in [ 0 ... ( min my_length, probe_length ) ]
#     return false if not equals me[ idx ], probe[ idx ]
#   #.........................................................................................................
#   return true

# #-----------------------------------------------------------------------------------------------------------
# _.starts_with = ( me, probe ) ->
#   my_length       = me.length
#   probe_length    = probe.length
#   return false if my_length < probe_length
#   #.........................................................................................................
#   for idx in [ 0 ... ( min my_length, probe_length) ]
#     return false if not equals me[ my_length - idx - 1 ], probe[ probe_length - idx - 1 ]
#   #.........................................................................................................
#   return true



#===========================================================================================================
# SORTING
#-----------------------------------------------------------------------------------------------------------
$.sort = ( me, Q ) ->
  """Javascript sorts in an 'undiscerning' and 'lexicographical' fashion, so we need to correct both these
  faults."""
  validate_argument_count arguments, 'min': 1, 'max': 2
  validate_isa_list me
  #.........................................................................................................
  [ Q, info ] = analyze_named_arguments Q,
    'sorter':         null
    'direction':      'ascending'
  sorter      = Q[ 'sorter'     ]
  direction   = Q[ 'direction'  ]
  # unless not sorter? then bye "argument ``sorter`` not implemented"
  unless direction == 'ascending' then bye "``direction: 'descending`` not implemented"
  #.........................................................................................................
  return _.sort me, sorter, direction
  bye "not implemented"
  return me

#...........................................................................................................
_.sort = TAINT.UNICODE "will not work properly for 32bit codepoints",
( me, sorter, direction = 'ascending' ) ->
  # unless not sorter? then bye "argument ``sorter`` not implemented"
  unless direction == 'ascending' then bye "``direction: 'descending`` not implemented"
  return me if me.length < 2
  type = type_of me[ 0 ]
  #.........................................................................................................
  get_sorter = ( me, type ) ->
    #.......................................................................................................
    if type == 'text'
      return ( a, b ) ->
        unless isa_text a then bye "unable to order a #{type} and a #{type_of a}"
        unless isa_text b then bye "unable to order a #{type} and a #{type_of b}"
        return if a == b then 0 else ( if a < b then return -1 else 1 )
    #.......................................................................................................
    if type == 'number'
      return ( a, b ) ->
        unless isa_number a then bye "unable to order a #{type} and a #{type_of a}"
        unless isa_number b then bye "unable to order a #{type} and a #{type_of b}"
        return a - b
    #.......................................................................................................
    bye "sorting not implemented for elements of type #{rpr type}"
  #.........................................................................................................
  # short form ``?=`` buggy; see https://github.com/jashkenas/coffee-script/issues/1627
  # but ok here since this is a variable from the method signature
  sorter ?= get_sorter me, type
  #.........................................................................................................
  return me.sort sorter

#===========================================================================================================
# OTHER STUFF
#-----------------------------------------------------------------------------------------------------------
$.clear = ( me ) ->
  validate_argument_count   arguments, 1
  validate_isa_list         me
  return _.clear me

#...........................................................................................................
_.clear = ( me ) ->
  me.length = 0
  return me

`
// Array Remove - By John Resig (MIT Licensed)
// http://ejohn.org/blog/javascript-array-remove/
_clear = function(array, from, to) {
  var rest = array.slice((to || from) + 1 || array.length);
  array.length = from < 0 ? array.length + from : from;
  return array.push.apply(array, rest);
};
`


#-----------------------------------------------------------------------------------------------------------
$.slice = slice = TAINT.TODO """must implement argument analysis: start, stop, min, max, delta;
  must implement negative indices""",
( list, start, stop ) ->
  validate_isa_list                         list
  validate_isa_nonnegative_integer_or_null  start
  validate_isa_nonnegative_integer_or_null  stop
  return [] if start >= stop
  return list.slice start, stop

#-----------------------------------------------------------------------------------------------------------
$.partition = partition = ( list, partitioner ) ->
  # type        = type_of partitioner
  # return ( partition_with_callback list, partitioner ) if type == 'function'
  validate_isa_positive_integer partitioner
  #.........................................................................................................
  n           = partitioner
  m           = list.length
  idx         = - n
  max_idx     = m - n
  remainder   = m % n
  R           = []
  #.........................................................................................................
  unless remainder == 0 then bye """expected list length to be a multiple of #{n};
    got list with #{m} elements"""
  #.........................................................................................................
  for idx in [ 0 .. max_idx ] by n
    R.push $.slice list, idx, idx + n
  #.........................................................................................................
  return R


#-----------------------------------------------------------------------------------------------------------
$.equals = ( me, probe ) ->
  #.........................................................................................................
  validate_argument_count_equals  2
  validate_isa_list               me
  return _.equals me, probe

#...........................................................................................................
_.equals = ( me, probe ) ->
  return false if not isa_list probe
  return false if me.length != probe.length
  #.........................................................................................................
  for idx in [ 0 ... me.length ]
    #.......................................................................................................
    my_element      = me[    idx ]
    your_element    = probe[ idx ]
    return false if ( type_of my_element ) != ( type_of your_element )
    return false if not equals my_element, your_element
  #.........................................................................................................
  return true


#===========================================================================================================
# KEYS AND VALUES
#-----------------------------------------------------------------------------------------------------------
$.keys_of = ( me ) ->
  validate_argument_count_equals 1
  validate_isa_list me
  return _.keys_of me

#...........................................................................................................
_.keys_of = ( me ) ->
  return ( idx for idx in [ 0 ... me.length ] )

#-----------------------------------------------------------------------------------------------------------
$.values_of = ( me ) ->
  validate_argument_count_equals 1
  validate_isa_list me
  return _.values_of me

#...........................................................................................................
_.values_of = ( me ) ->
  return shallow_copy me

#-----------------------------------------------------------------------------------------------------------
$.facets_of = ( me ) ->
  validate_argument_count_equals 1
  validate_isa_list me
  return _.facets_of me

#...........................................................................................................
_.facets_of = ( me ) ->
  return ( [ idx, me[ idx ], ] for idx in [ 0 ... me.length ] )

#-----------------------------------------------------------------------------------------------------------
$.extend = ( me, you ) ->
  validate_argument_count_equals  2
  validate_isa_list               me
  validate_isa_list               you
  return _.extend me, you

#...........................................................................................................
_.extend = ( me, you ) ->
  me.push.apply me, you
  return me

#-----------------------------------------------------------------------------------------------------------
$.flatten = ( me ) ->
  validate_argument_count_equals 1
  validate_isa_list me
  return _.flatten me

#...........................................................................................................
_.flatten = ( me ) ->
  buffer  = _.shallow_copy me
  _.clear me
  #.........................................................................................................
  for element in buffer
    #.......................................................................................................
    if isa_list element
      _.extend me, _.flatten element
      continue
    #.......................................................................................................
    _.push me, element
  #.........................................................................................................
  return me


#===========================================================================================================
# RANDOMIZATION
#-----------------------------------------------------------------------------------------------------------
$.shuffle = ( me ) ->
  """Shuffles the elements of a list randomly. After the call, the elements of will be—most of the time—
  be reordered (but this is not guaranteed, as there is a realistic probability for recurrence of orderings
  with short lists).

  Implementation gleaned from
  http://stackoverflow.com/questions/962802/is-it-correct-to-use-javascript-array-sort-method-for-shuffling;
  this is an implementation of the Fisher-Yates shuffle algorithm."""
  validate_argument_count_equals  1
  validate_isa_list               me
  return _.shuffle me

#...........................................................................................................
_.shuffle = ( me ) ->
  this_idx = me.length
  return me if this_idx < 2
  #.........................................................................................................
  loop
    this_idx       -= 1
    return me if this_idx < 1 # < 0 ???
    that_idx = random_integer 0, this_idx
    [ me[ that_idx ], me[ this_idx ] ] = [ me[ this_idx ], me[ that_idx ] ]
  #.........................................................................................................
  return me


#===========================================================================================================
# BASICS
#-----------------------------------------------------------------------------------------------------------
$.length_of = ( me ) ->
  validate_argument_count_equals 1
  validate_isa_list me
  return me.length

#...........................................................................................................
_.length_of = ( me ) ->
  return me.length

#-----------------------------------------------------------------------------------------------------------
$.last_idx_of = ( me ) ->
  """Returns the last (highest) index that can be used with the ``get`` method; always equals ``( length_of
  me ) - 1``. Note that it is *not* guaranteed that ``get me, last_idx_of me`` will succeed---it will fail
  for empty lists. Generally, use ``if has me, idx then get me, idx else null`` or similar to harden a
  ``get`` operation against noisy failure."""
  validate_argument_count_equals 1
  validate_isa_list me
  return me.length - 1

#...........................................................................................................
_.last_idx_of = ( me ) ->
  return me.length - 1

#-----------------------------------------------------------------------------------------------------------
$.first_idx_of = ( me ) ->
  """Returns the first index that can be used with the ``get`` method; this is always zero for plain old
  lists (but may be another value for specialized variants). Note that it is *not* guaranteed that ``get me,
  first_idx_of me`` will succeed---it will fail for empty lists. Generally, use ``if has me, idx then get
  me, idx else null`` or similar to harden a ``get`` operation against noisy failure."""
  validate_argument_count_equals 1
  validate_isa_list me
  return _.first_idx_of me

#...........................................................................................................
_.first_idx_of = ( me ) ->
  length = me.length
  return if length == 0 then null else 0

#-----------------------------------------------------------------------------------------------------------
$.smallest_idx_of = ( me ) ->
  """Returns the smallest index that can be used with the ``get`` method; this is always the negative length
  for plain old lists (but may be another value for specialized variants). Both the 'first' index and the
  'smallest' index point to the first element of a list, but whereas the first is always zero, the smallest
  index will always be negative. Note that it is *not* guaranteed that ``get me, smallest_idx_of me`` will
  succeed---it will fail for empty lists. Generally, use ``if has me, idx then get me, idx else null`` or
  similar to harden a ``get`` operation against noisy failure."""
  validate_argument_count_equals 1
  validate_isa_list me
  return _.smallest_idx_of me

#...........................................................................................................
_.smallest_idx_of = ( me ) ->
  length = me.length
  return if length == 0 then null else -length

#-----------------------------------------------------------------------------------------------------------
get_positive_idx = ( me, idx ) ->
  smallest_idx  = _.smallest_idx_of me
  last_idx      = _.last_idx_of     me
  unless smallest_idx <= idx <= last_idx
    if me.length == 1 then bye "expected index to be 0, got #{idx}"
    bye "expected index to fall between #{smallest_idx} and #{last_idx}, got #{idx}"
  return if idx >= 0 then idx else me.length + idx

#-----------------------------------------------------------------------------------------------------------
$.get = ( me, idx ) ->
  validate_argument_count_equals 2
  validate_isa_list     me
  validate_isa_integer  idx
  return _.get me, idx

#...........................................................................................................
_.get = ( me, idx ) ->
  if me.length == 0 then bye "unable to retrieve an element from an empty list"
  return me[ get_positive_idx me, idx ]

#-----------------------------------------------------------------------------------------------------------
$.set = ( me, idx, value ) ->
  validate_argument_count_equals 3
  validate_isa_list       me
  validate_isa_integer    idx
  validate_isnt_undefined value
  return _.set me, idx, value

#...........................................................................................................
_.set = ( me, idx, value ) ->
  if me.length == 0 then bye "unable to ``set()`` an element in an empty list"
  me[ get_positive_idx me, idx ] = value
  return me


#===========================================================================================================
# CONTAINMENT AND MEMBERSHIP
#-----------------------------------------------------------------------------------------------------------
$.contains = ( me, probe ) ->
  validate_argument_count_equals  2
  validate_isa_list               me
  validate_isnt_undefined         probe
  return _.contains me, probe

#...........................................................................................................
_.contains = ( me, probe ) ->
  #.........................................................................................................
  # If ``List.indexOf`` reports a hit, we definitely know it is so and return ``true``:
  return true if ( me.indexOf probe ) > -1
  #.........................................................................................................
  # We know the miss is authoritative if ``probe`` can be equality-tested with JS's ``===`` operator:
  type_of_probe = type_of probe
  return false if simple_equality_types[ type_of_probe ]
  #.........................................................................................................
  # Otherwise, we have to check manually, but we can skip all values whose type is in the 'simple equality'
  # list:
  for name, value of me
    type_of_value = type_of value
    continue if type_of_value isnt type_of_probe
    continue if simple_equality_types[ type_of_value ]
    # This check could be made much faster if there was a way to get the resulting Δ-method for the constant
    # type of ``probe`` (it should be easy to implement):
    return true if equals probe, value
  #.........................................................................................................
  return false

#-----------------------------------------------------------------------------------------------------------
$.key_of = ( me, probe ) ->
  validate_argument_count_equals  2
  validate_isa_list               me
  validate_isnt_undefined         probe
  return _.key_of me, probe

#...........................................................................................................
_.key_of = ( me, probe ) ->
  R = me.indexOf probe
  return if R > -1 then R else null

#-----------------------------------------------------------------------------------------------------------
$.has = ( me, probe ) ->
  validate_argument_count_equals  2
  validate_isa_list               me
  validate_isnt_undefined         probe
  return _.has me, probe

#...........................................................................................................
_.has = ( me, probe ) ->
  return false unless isa_number probe
  length = me.length
  return - length <= probe < length

#-----------------------------------------------------------------------------------------------------------
$.first_of = ( me ) ->
  validate_argument_count_equals  1
  validate_isa_list               me
  return _.first_of me

#...........................................................................................................
_.first_of = ( me ) ->
  return me[ _.first_idx_of me ]

#-----------------------------------------------------------------------------------------------------------
$.last_of = ( me ) ->
  validate_argument_count_equals  1
  validate_isa_list               me
  return _.last_of me

#...........................................................................................................
_.last_of = ( me ) ->
  return me[ _.last_idx_of me ]

#-----------------------------------------------------------------------------------------------------------
$.all_of = ( me, test ) ->
  validate_argument_count_equals  2
  validate_isa_list               me
  validate_isa_function           test
  return _.all_of me, test

#...........................................................................................................
_.all_of = ( me, test ) ->
  for element in me
    return false unless test element
  return true

#-----------------------------------------------------------------------------------------------------------
$.any_of = ( me, test ) ->
  validate_argument_count_equals  2
  validate_isa_list               me
  validate_isa_function           test
  return _.any_of me, test

#...........................................................................................................
_.any_of = ( me, test ) ->
  for element in me
    return true unless test element
  return false



#===========================================================================================================
# CONTAINMENT AND MEMBERSHIP
#-----------------------------------------------------------------------------------------------------------
$.has = ( me, probe ) ->
  validate_argument_count_equals  2
  validate_isa_list               me
  validate_isnt_undefined         probe
  return _.has me, probe

#...........................................................................................................
_.has = ( me, probe ) ->
  return false unless isa_number probe
  length = me.length
  return - length <= probe < length


#===========================================================================================================
# DELETIONS
#-----------------------------------------------------------------------------------------------------------
$.remove_value = ( me, probe ) ->
  validate_argument_count_equals  2
  validate_isa_list               me
  validate_isnt_undefined         probe
  return _.remove_value me, probe

#...........................................................................................................
_.remove_value = ( me, probe ) ->
  idx = key_of me, probe
  if idx is null
    bye "expected probe #{rpr probe} to be in list, but it isn't"
  return _.remove_key me, idx

#-----------------------------------------------------------------------------------------------------------
$.remove_key = ( me, idx ) ->
  validate_argument_count_equals  2
  $.validate_isa_idx_of           me, idx
  return _.remove_key me, idx

#...........................................................................................................
_.remove_key = ( me, idx ) ->
  me.splice( idx, 1 )[ 0 ]
  return me

#-----------------------------------------------------------------------------------------------------------
$.remove_slice = ( me, Q ) ->
  validate_argument_count_equals  2
  validate_isa_pod                Q
  Q = validate_Q Q,
    'start':      0
    'stop':       me.length
  { start
    stop } = Q
  log Q
  validate_isa_nonnegative_integer_or_null  start
  validate_isa_nonnegative_integer_or_null  stop
  return _.remove_slice me, start, stop

#...........................................................................................................
_.remove_slice = ( me, start, stop ) ->
  me.splice( start, stop - start )
  return me


#===========================================================================================================
# VALIDATION
#-----------------------------------------------------------------------------------------------------------
$.validate_isa_idx_of = ( me, x ) ->
  validate_argument_count_equals            2
  validate_isa_list                         me
  validate_isa_nonnegative_integer_or_null  x
  unless ( $.first_idx_of me ) <= x <= ( $.last_idx_of me )
    bye "expected an index between min: #{$.first_idx_of me} and max: #{$.last_idx_of me}, got #{x}"

