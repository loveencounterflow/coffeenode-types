

# temporary
TAINT =
  TODO:     ( text, f ) -> f
  UNICODE:  ( text, f ) -> f



############################################################################################################
$                         = exports ? @
log                       = console.log
rpr                       = ( require 'util' ).inspect
#-----------------------------------------------------------------------------------------------------------
TYPES                     = require 'COFFEENODE/TYPES'

#-----------------------------------------------------------------------------------------------------------
$.repeat = ( me, count ) ->
  return ( new Array count + 1 ).join me

#-----------------------------------------------------------------------------------------------------------
$.push = ( me, you ) ->
  return me + you

#-----------------------------------------------------------------------------------------------------------
$.starts_with = ( me, probe ) ->
  # from prototype 1.6.0_rc0
  return ( me.indexOf probe ) == 0

#-----------------------------------------------------------------------------------------------------------
$.ends_with = ( me, search_text ) ->
  # from prototype 1.6.0_rc0
  delta = me.length - search_text.length
  return delta >= 0 and me.lastIndexOf( search_text ) == delta

#-----------------------------------------------------------------------------------------------------------
$.drop_prefix = ( me, probe ) ->
  return me.substr probe.length if @starts_with me, probe
  return me

#-----------------------------------------------------------------------------------------------------------
$.drop_suffix = ( me, probe ) ->
  return me.substr 0, me.length - probe.length if @ends_with me, probe
  return me

#-----------------------------------------------------------------------------------------------------------
$.contains = ( me, probe ) ->
  type_of_probe = type_of probe
  #.........................................................................................................
  if type_of_probe == 'text'
    return true if probe.length == 0
    return ( me.indexOf probe ) >= 0
  #.........................................................................................................
  if type_of_probe == 'regex'
    return ( me.match probe )?
  #.........................................................................................................
  validate_isa_text_or_regex probe

#-----------------------------------------------------------------------------------------------------------
$.contains_only_numbers = ( me ) ->
  bye "unable to apply ``contains-only-numbers()`` to a text; did you mean ``contains-only-digits()``?"

#-----------------------------------------------------------------------------------------------------------
$.contains_only_digits = ( me ) ->
  return false if @is_empty me
  return ( me.match /^[0-9]+$/ )?

#-----------------------------------------------------------------------------------------------------------
$.is_empty = ( me ) ->
  return me.length == 0

#-----------------------------------------------------------------------------------------------------------
$.split = TAINT.TODO """will only split once when given a text probe; unexpected results when starts
  or ends with probe; will fail with 32bit codepoints""",
( me, probe ) ->
  return @words_of me unless probe?
  probe = if isa_regex probe then probe[ '%self' ] else probe
  R     = me.split probe
  return R.filter ( element ) -> return element isnt undefined

#-----------------------------------------------------------------------------------------------------------
$.words_of = TAINT.TODO "might not recognize all Unicode whitespace codepoints", ( me ) ->
  return ( me.replace /^\s*(.*?)\s*$/g, '$1' ).split /\s+/g

#-----------------------------------------------------------------------------------------------------------
$.as_text = ( me ) ->
  return me

#-----------------------------------------------------------------------------------------------------------
$.trim = ( me, trimmer = null ) ->
  return @_trim_whitespace me unless trimmer?
  return @replace me, trimmer, ''

#-----------------------------------------------------------------------------------------------------------
$._trim_whitespace = ( me ) ->
  """Faster whitespace trimming; adapted from
  http://blog.stevenlevithan.com/archives/faster-trim-javascript."""
  me          = me.replace /^\s\s*/, ''
  whitespace  = /\s/
  i           = me.length
  while whitespace.test me.charAt --i
    null
  return me.slice 0, i + 1

#-----------------------------------------------------------------------------------------------------------
$.cut = TAINT.UNICODE """will split codepoints beyond u/ffff""",
  ( me, Q ) ->
    validate_isa_text me
    #.........................................................................................................
    [ Q, info, ] = analyze_named_arguments Q,
      'start':        0
      'rests':        null
    #.........................................................................................................
    start       = Q[ 'start' ]
    rests       = Q[ 'rests' ]
    #.........................................................................................................
    validate_isa_nonnegative_integer start
    #.........................................................................................................
    unless start < me.length
      bye "index error: text has last character at index #{rpr me.length - 1}, got index #{rpr start}"
    #.........................................................................................................
    R = me.substring start
    #.........................................................................................................
    if rests?
      validate_isa_list rests
      unless rests.length == 0 then bye """expected an empty list,
        got one with #{rpr rests.length} elements."""
      rests.push me.substring 0, start
      rests.push ''
    #.........................................................................................................
    return R

#-----------------------------------------------------------------------------------------------------------
$.flush_left = ( me, width = 25, filler = ' ' ) ->
  return @flush me, width, 'left', filler

#-----------------------------------------------------------------------------------------------------------
$.flush_right = ( me, width = 25, filler = ' ' ) ->
  return @flush me, width, 'right', filler

#-----------------------------------------------------------------------------------------------------------
$.flush = ( me, width, align, filler = ' ' ) ->
  """Given a text, a non-negative integer ``width``, and an optional, non-empty text ``filler`` (which
  defaults to a single space), return a string that starts with the text, and is padded with as many
  fillers as needed to make the string ``width`` characters long. If ``width`` is zero or smaller than
  the length of the text, the text is simply returned as-is. No clipping of text is ever done."""
  #.........................................................................................................
  unless align == 'left' or align == 'right'
    bye "expected ``left`` or ``right`` for ``align``, got #{rpr align}"
  #.........................................................................................................
  filler_length     = filler.length
  text_length       = me.length
  #.........................................................................................................
  return me if text_length >= width
  padding = @repeat filler, width - text_length
  return if align == 'left' then me + padding else padding + me

#-----------------------------------------------------------------------------------------------------------
$.lower_case = TAINT.UNICODE """does work for ÄÖÜ; unknown behavior for more exotic chrs""",
( me ) ->
  return me.toLowerCase()

#-----------------------------------------------------------------------------------------------------------
$.upper_case = TAINT.UNICODE """does work for ÄÖÜ; unknown behavior for more exotic chrs""",
( me ) ->
  return me.toUpperCase()

#-----------------------------------------------------------------------------------------------------------
$.length_of = TAINT.UNICODE """will incorrectly count codepoints above u/ffff as two chrs""",
( me ) ->
  return me.length

#-----------------------------------------------------------------------------------------------------------
$.replace = ( me, probe, replacement ) ->
  if isa_text probe then probe = new_jsregex ( REGEX.escape probe ), 'g'
  return me.replace probe, replacement

#-----------------------------------------------------------------------------------------------------------
$.lines_of = TAINT.TODO "might not recognize all Unicode line-endings",
( me ) ->
  return me.split /\n/g

#-----------------------------------------------------------------------------------------------------------
$.chrs_of = TAINT.UNICODE """will split codepoints beyond u/ffff""",
( me ) ->
  return ( me[ idx ] for idx in [ 0 ... me.length ] )

#-----------------------------------------------------------------------------------------------------------
$.reverse = ( me ) ->
  return ( @chrs_of me ).reverse().join ''

#-----------------------------------------------------------------------------------------------------------
$.add = ( me_and_you... ) ->
  return me_and_you.join ''

#-----------------------------------------------------------------------------------------------------------
$.equals = $.matches = ( me, probe ) ->
  return false if ( type_of probe ) != 'text'
  return me == probe

#-----------------------------------------------------------------------------------------------------------
$.as_html = ( me ) ->
  return HTML.h me

#-----------------------------------------------------------------------------------------------------------
$.partition = TAINT.UNICODE "will split codepoints beyond u/ffff", ( me, partitioner ) ->
  #.........................................................................................................
  n           = partitioner
  m           = me.length
  idx         = - n
  max_idx     = m - n
  remainder   = m % n
  R           = []
  #.........................................................................................................
  unless remainder == 0
    bye "expected length of text to be a multiple of #{n}, got text with #{m} characters"
  #.........................................................................................................
  for idx in [ 0 .. max_idx ] by n
    R.push @slice me, idx, idx + n
  #.........................................................................................................
  return R

#-----------------------------------------------------------------------------------------------------------
$.slice = ( me, start, stop ) ->
  # short form ``?=`` buggy; see https://github.com/jashkenas/coffee-script/issues/1627
  # but ok here since these are variables from the method signature
  start    ?= 0
  stop     ?= me.length
  return '' if start >= stop
  return me.slice start, stop


#===========================================================================================================
# RANDOMIZATION
#-----------------------------------------------------------------------------------------------------------
$.shuffle = ( me ) ->
  return ( LIST.shuffle @chrs_of me ).join ''



