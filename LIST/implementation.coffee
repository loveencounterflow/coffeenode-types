
# temporary
TAINT =
  UNICODE: ( text, f ) -> f



############################################################################################################
$                         = exports ? @
log                       = console.log
rpr                       = ( x ) -> return ( require 'util' ).inspect x, false, 22
#-----------------------------------------------------------------------------------------------------------

#===========================================================================================================
#
#-----------------------------------------------------------------------------------------------------------
$.new = ( x ) ->
  type_of_x = type_of x
  if type_of_x != 'list' and type_of_x != 'text'
    bye "expected a list or a text, got a #{type_of_x}"
  return $.shallow_copy x if type_of_x == 'list'
  #.........................................................................................................
  return x.split ''

#-----------------------------------------------------------------------------------------------------------
$.negate = ( me ) ->
  for idx in [ 0 ... me.length ]
    me[ idx ] = negate me[ idx ]

#-----------------------------------------------------------------------------------------------------------
$.reverse = ( me ) ->
  return me.reverse()

#-----------------------------------------------------------------------------------------------------------
$.subtract = ( me, you ) ->
  your_elements = new_set you
  remove        = LIST._.remove_key
  #.........................................................................................................
  for idx in [ me.length - 1 .. 0 ] by -1
    remove me, idx if has your_elements, me[ idx ]
  return me

#-----------------------------------------------------------------------------------------------------------
$.add = ( me, you ) ->
  me.splice me.length, 0, you...
  return me

#-----------------------------------------------------------------------------------------------------------
$.shallow_copy = ( me ) ->
  return me.slice()

#-----------------------------------------------------------------------------------------------------------
$.copy = ( me ) ->
  return jq_extend true, [], me

#-----------------------------------------------------------------------------------------------------------
$.join = ( me, joiner ) ->
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
  get_method = ( joiner ) ->
    return ( me ) ->
      return me.join joiner
  #.........................................................................................................
  for facet in names_and_joiners
    [ name, joiner, ] = facet
    $[ name ] = get_method joiner
#...........................................................................................................
get_join_methods()

#-----------------------------------------------------------------------------------------------------------
$.is_empty = ( me ) ->
  return me.length == 0


#===========================================================================================================
# FILLING
#-----------------------------------------------------------------------------------------------------------
$.fill = ( me, value ) ->
  for idx in [ 0 ... me.length ]
    me[ idx ] = value
  return me


#===========================================================================================================
# FILTERING
#-----------------------------------------------------------------------------------------------------------
$.filter = ( me, sieve ) ->
  me.splice 0, me.length, ( me.filter sieve )...
  return me


#===========================================================================================================
# STACKS: WORKING ON THE RIGHT END
#-----------------------------------------------------------------------------------------------------------
$.push = ( me, value ) ->
  me.push value
  return me

#-----------------------------------------------------------------------------------------------------------
$.pop = ( me ) ->
  return me.pop()


#===========================================================================================================
# QUEUES: WORKING ON THE LEFT END
#-----------------------------------------------------------------------------------------------------------
$.insert = ( me, value ) ->
  me.unshift value
  return me

#-----------------------------------------------------------------------------------------------------------
$.pull = ( me, value ) ->
  return me.shift()

#===========================================================================================================
# SEARCHING
#-----------------------------------------------------------------------------------------------------------
$.idx_of = ( me, probe ) ->
  return me.indexOf probe


#===========================================================================================================
# SORTING
#-----------------------------------------------------------------------------------------------------------
$.sort = ( me, Q ) ->
  """Javascript sorts in an 'undiscerning' and 'lexicographical' fashion, so we need to correct both these
  faults."""
  #.........................................................................................................
  [ Q, info ] = analyze_named_arguments Q,
    'sorter':         null
    'direction':      'ascending'
  sorter      = Q[ 'sorter'     ]
  direction   = Q[ 'direction'  ]
  # unless not sorter? then bye "argument ``sorter`` not implemented"
  unless direction == 'ascending' then bye "``direction: 'descending`` not implemented"
  #.........................................................................................................
  return _sort me, sorter, direction
  bye "not implemented"
  return me

#...........................................................................................................
_sort = TAINT.UNICODE "will not work properly for 32bit codepoints",
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
  me.length = 0
  return me

# `
# // Array Remove - By John Resig (MIT Licensed)
# // http://ejohn.org/blog/javascript-array-remove/
# _clear = function(array, from, to) {
#   var rest = array.slice((to || from) + 1 || array.length);
#   array.length = from < 0 ? array.length + from : from;
#   return array.push.apply(array, rest);
# };
# `


#-----------------------------------------------------------------------------------------------------------
$.slice = ( me, start, stop ) ->
  return [] if start >= stop
  return me.slice start, stop

#-----------------------------------------------------------------------------------------------------------
$.partition = ( me, partitioner ) ->
  #.........................................................................................................
  n           = partitioner
  m           = me.length
  idx         = - n
  max_idx     = m - n
  remainder   = m % n
  R           = []
  #.........................................................................................................
  unless remainder == 0 then bye """expected list length to be a multiple of #{n};
    got list with #{m} elements"""
  #.........................................................................................................
  for idx in [ 0 .. max_idx ] by n
    R.push @slice me, idx, idx + n
  #.........................................................................................................
  return R


#-----------------------------------------------------------------------------------------------------------
$.equals = ( me, probe ) ->
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
  return ( idx for idx in [ 0 ... me.length ] )

#-----------------------------------------------------------------------------------------------------------
$.values_of = ( me ) ->
  return shallow_copy me

#-----------------------------------------------------------------------------------------------------------
$.facets_of = ( me ) ->
  return ( [ idx, me[ idx ], ] for idx in [ 0 ... me.length ] )

#-----------------------------------------------------------------------------------------------------------
$.extend = ( me, you ) ->
  me.push.apply me, you
  return me

#-----------------------------------------------------------------------------------------------------------
$.flatten = ( me ) ->
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
  return me.length

#-----------------------------------------------------------------------------------------------------------
$.last_idx_of = ( me ) ->
  return me.length - 1

#-----------------------------------------------------------------------------------------------------------
$.first_idx_of = ( me ) ->
  length = me.length
  return if length == 0 then null else 0

#-----------------------------------------------------------------------------------------------------------
$.smallest_idx_of = ( me ) ->
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
  if me.length == 0 then bye "unable to retrieve an element from an empty list"
  return me[ get_positive_idx me, idx ]

#-----------------------------------------------------------------------------------------------------------
$.set = ( me, idx, value ) ->
  if me.length == 0 then bye "unable to ``set()`` an element in an empty list"
  me[ get_positive_idx me, idx ] = value
  return me


#===========================================================================================================
# CONTAINMENT AND MEMBERSHIP
#-----------------------------------------------------------------------------------------------------------
$.contains = ( me, probe ) ->
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
  R = me.indexOf probe
  return if R > -1 then R else null

#-----------------------------------------------------------------------------------------------------------
$.has = ( me, probe ) ->
  return false unless isa_number probe
  length = me.length
  return - length <= probe < length

#-----------------------------------------------------------------------------------------------------------
$.first_of = ( me ) ->
  return me[ _.first_idx_of me ]

#-----------------------------------------------------------------------------------------------------------
$.last_of = ( me ) ->
  return me[ _.last_idx_of me ]

#-----------------------------------------------------------------------------------------------------------
$.all_of = ( me, test ) ->
  for element in me
    return false unless test element
  return true

#-----------------------------------------------------------------------------------------------------------
$.any_of = ( me, test ) ->
  for element in me
    return true unless test element
  return false



#===========================================================================================================
# CONTAINMENT AND MEMBERSHIP
#-----------------------------------------------------------------------------------------------------------
$.has = ( me, probe ) ->
  return false unless isa_number probe
  length = me.length
  return - length <= probe < length


#===========================================================================================================
# DELETIONS
#-----------------------------------------------------------------------------------------------------------
$.remove_value = ( me, probe ) ->
  idx = key_of me, probe
  if idx is null
    bye "expected probe #{rpr probe} to be in list, but it isn't"
  return _.remove_key me, idx

#-----------------------------------------------------------------------------------------------------------
$.remove_key = ( me, idx ) ->
  me.splice( idx, 1 )[ 0 ]
  return me

#-----------------------------------------------------------------------------------------------------------
$.remove_slice = ( me, start, stop ) ->
  me.splice( start, stop - start )
  return me


