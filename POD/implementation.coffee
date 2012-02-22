

# temporary
TAINT =
  BUG: ( text, f ) -> f


############################################################################################################
$                         = exports ? @
log                       = console.log
rpr                       = ( x ) -> return ( require 'util' ).inspect x, false, 22
#-----------------------------------------------------------------------------------------------------------
#jq_extend                 = ( require 'jquery' ).extend

_as_hash_key = ( x ) -> x

#-----------------------------------------------------------------------------------------------------------
$.new_pod = ->
  R = Object.create null # thx to http://www.devthought.com/2012/01/18/an-object-is-not-a-hash for this one
  # later: process arguments here
  return R

#-----------------------------------------------------------------------------------------------------------
$.has = ( me, probe ) ->
  return me[ _as_hash_key probe ] isnt undefined

#-----------------------------------------------------------------------------------------------------------
$.contains = ( me, probe ) ->
  for name, value of me
    return true if equals probe, value
  #.........................................................................................................
  return false

#-----------------------------------------------------------------------------------------------------------
$.is_empty = ( me ) ->
  return ( @length_of me ) == 0

#-----------------------------------------------------------------------------------------------------------
$.invert = ( me ) ->
  for [ name, value, ] in @facets_of me
    delete me[ name ]
    me[ value ] = _as_hash_key name
  return me

#-----------------------------------------------------------------------------------------------------------
$.morph = ( me, morpher, Q ) ->
  """Given a POD and a ``morpher`` function, call the morpher for each facet of the POD and modify
  it according to the return value of morpher. Calls take the form ::

    morpher pod, old-name, old-value

  so the morpher must accept exactly three arguments.

  The conventions are as follows:

  * ``morpher( old-name, old-value )`` may return a single ``null`` to signal that the respective facet
    should be left untouched.

  * In all other cases, the morpher must return a facet as a list ``[ new-name, new-value, ]``.

  * If ``new-name`` is ``null``, then the respective facet will again be deleted.

  * If ``new-name`` differs from the original name, then that facet will be deleted and a new facet with
    the new name and value will be created. This may cause an error in case the new name is already
    present in the POD; it is important to know that this error will be thrown *before* the deletion occurs,
    so if you catch the error the old name/value pair will still be present. You can, however, opt-in
    to allow name collisions by calling this method as ``morph pod, morpher, 'allow-overwrite': yes``; if you
    do that then the morpher will *not* be called again with this name/value pair.

  * Otherwise, the old value will simply be overwritten with the new value (which may mean it is not
    changed at all).

  Upon completion, the POD is returned as is the custom.

  Hint: you may swap named options and the morpher; this can make it syntactically more convenient to call
  ``morph()``. You can write::

    morpher = ( pod, old_name, old_value ) ->
      return [ 'foo', old_value * 2, ]      if old_name == 'bro'
      return null

    morph p, morpher, 'allow-overwrite': yes

  as well as::

    morph p, 'allow-overwrite': yes, ( pod, old_name, old_value ) ->
      return [ 'foo', old_value * 2, ]      if old_name == 'bro'
      return null
      """
  #.........................................................................................................
  validate_argument_count   arguments, 'min': 2, 'max': 3
  validate_isa_pod          me
  [ morpher, Q, ] = [ Q, morpher, ] if isa_function Q
  validate_isa_function     morpher
  Q = validate_Q Q,
    'allow-overwrite':  no
  return @morph me, morpher, Q[ 'allow-overwrite' ]


#===========================================================================================================
# POD LENGTH
#-----------------------------------------------------------------------------------------------------------
get_function_length_of = ->
  """**Implementation Note** This is an implementation of the Fastest Way to count the number of member
  facets of a POD, which is surprisingly difficult to do right in JavaScript (but nobody is really surprised
  by that fact). Different environments have different facilities under the hood, so we choose the best
  available. This will be:

  * ``( Object.keys x ).length`` for ES5-compatible environments; works in nodejs, Chrome, IE9, FF4, and
    Safari 5;

  * ``x.__count__`` for Firefoxen before version 4 (untested); and

  * a 'manual' iteration count (attention, might be slow) for browsers that are not real browsers."""
  _test = { x: 42, y: 108 }
  #...........................................................................................................
  # Fastest and widely available method for ES5-compatible environments; works in nodejs, Chrome, IE9, FF4,
  # and Safari 5:
  if ( Object.keys? _test )?.length == 2
    return ( me ) ->
      return ( Object.keys me ).length
  #...........................................................................................................
  # Fast method for Firefoxen before version 4:
  if _test.__count__ == 2
    return ( me ) ->
      return me.__count__
  #...........................................................................................................
  # Browsers that are not real browsers will have to do it themselves; notice that this might mean iterating
  # over a lot of POD members if you insist to keep a huge MongoDB all in memory:
  return ( me ) ->
    R = 0
    for name of me
      R += 1
    return R

#-----------------------------------------------------------------------------------------------------------
$.length_of = get_function_length_of()


#===========================================================================================================
# EQUALITY
#-----------------------------------------------------------------------------------------------------------
$.equals = ( me, probe ) ->
  return false if not TYPES.isa_pod probe
  return false if ( @length_of me ) != @length_of probe
  #.........................................................................................................
  for name, value of me
    return false if not equals probe[ name ], value
  #.........................................................................................................
  return true


#===========================================================================================================
# DELETION
#-----------------------------------------------------------------------------------------------------------
$.remove_key = ( me, name ) ->
  name    = _as_hash_key name
  R       = me[ name ]
  delete    me[ name ]
  return R

#-----------------------------------------------------------------------------------------------------------
$.clear = ( me ) ->
  for name of me
    delete me[ name ]
  return me


#===========================================================================================================
# KEYS AND VALUES
#-----------------------------------------------------------------------------------------------------------
$.keys_of = $.names_of = ( me ) ->
  return ( _from_hash_key key for key of me )

#-----------------------------------------------------------------------------------------------------------
$.values_of = ( me ) ->
  return ( value for name, value of me )

#-----------------------------------------------------------------------------------------------------------
$.facets_of = ( me ) ->
  return ( [ ( _from_hash_key name ), value, ] for name, value of me )


#===========================================================================================================
# COPYING
#-----------------------------------------------------------------------------------------------------------
$.copy = TAINT.BUG "will copy the momentary value, not the definition of properties (in the narrow sense)",
( x ) ->
  return jq_extend true, {}, x

#-----------------------------------------------------------------------------------------------------------
$.shallow_copy = ( x ) ->
  R = {}
  #.........................................................................................................
  for name of x
    descriptor = Object.getOwnPropertyDescriptor x, name
    #.......................................................................................................
    if descriptor?.get? or descriptor?.set?
      Object.defineProperty R, name,
        enumerable: descriptor.enumerable
        get:        descriptor.get
        set:        descriptor.set
    else
      R[ name ] = x[ name ]
  #.........................................................................................................
  return R


#===========================================================================================================
# UPDATING AND MERGING
#-----------------------------------------------------------------------------------------------------------
$.update = ( me, you ) ->
  #.........................................................................................................
  for name, value of you
    me[ _as_hash_key name ] = value
  #.........................................................................................................
  return me

#-----------------------------------------------------------------------------------------------------------
$.merge = ( me, you ) ->
  #.........................................................................................................
  for name, value of you
    continue if @has me, name
    me[ _as_hash_key name ] = value
  #.........................................................................................................
  return me


#===========================================================================================================
# VALIDATION
#-----------------------------------------------------------------------------------------------------------
$.validate = ( Q, description ) ->
  R = analyze_named_arguments Q, description
  #.........................................................................................................
  if isa_list R
    R             = R[ 0 ]
    # R[ '~info' ]  = R[ 1 ]
  #.........................................................................................................
  return R

#-----------------------------------------------------------------------------------------------------------
$.validate_isa_name = ( x ) ->
  _validate_argument_count_eq           arguments, 1
  validate_isa_nonempty_text            x
  validate_isa_text_without_whitespace  x

#-----------------------------------------------------------------------------------------------------------
$.validate_has = ( me, name ) ->
  validate_argument_count_equals  2
  validate_isa_pod                me
  validate_isa_name               name
  unless @has me, name then bye "expected the POD to have name #{rpr name}, but it does not"

#===========================================================================================================
# GET AND SET
#-----------------------------------------------------------------------------------------------------------
$.get = ( me, name ) ->
  R = me[ _as_hash_key name ]
  if R == null then bye "unknown name: #{rpr name}"
  return R

#-----------------------------------------------------------------------------------------------------------
$.set = ( me, name, value ) ->
  me[ _as_hash_key name ] = value
  return me



