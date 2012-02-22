


############################################################################################################
SUNDRY                    = require './SUNDRY'
isa_text                  = SUNDRY.isa_text
isa_nonnegative_integer   = SUNDRY.isa_nonnegative_integer
$                         = exports ? this
$._ = _                   = {}

#-----------------------------------------------------------------------------------------------------------
$.repeat = repeat = ( me, count ) ->
  validate_argument_count_equals    2
  validate_isa_text                 me
  validate_isa_nonnegative_integer  count
  return _.repeat me, count

#...........................................................................................................
_.repeat = ( me, count ) ->
  return ( new Array count + 1 ).join me

#-----------------------------------------------------------------------------------------------------------
$.push = ( me, you ) ->
  validate_argument_count_equals  2
  validate_isa_text               me
  validate_isa_text               you
  return _.push me, you

#...........................................................................................................
_.push = ( me, you ) ->
  return me + you

#-----------------------------------------------------------------------------------------------------------
$.starts_with = ( me, probe ) ->
  validate_argument_count_equals  2
  validate_isa_text               me
  validate_isa_text               probe
  return _.starts_with me, probe

#...........................................................................................................
_.starts_with = ( me, probe ) ->
  # from prototype 1.6.0_rc0
  return ( me.indexOf probe ) == 0

#-----------------------------------------------------------------------------------------------------------
$.ends_with = ends_with = ( me, search_text ) ->
  validate_argument_count_equals  2
  validate_isa_text               me
  validate_isa_text               search_text
  return _.ends_with me, search_text

#...........................................................................................................
_.ends_with = ( me, search_text ) ->
  # from prototype 1.6.0_rc0
  delta = me.length - search_text.length
  return delta >= 0 and me.lastIndexOf( search_text ) == delta

#-----------------------------------------------------------------------------------------------------------
$.drop_prefix = ( me, probe ) ->
  validate_argument_count_equals  2
  validate_isa_text               me
  validate_isa_text               probe
  return _.drop_prefix me, probe

#...........................................................................................................
_.drop_prefix = ( me, probe ) ->
  return me.substr probe.length if _.starts_with me, probe
  return me

#-----------------------------------------------------------------------------------------------------------
$.drop_suffix = ( me, probe ) ->
  validate_argument_count_equals  2
  validate_isa_text               me
  validate_isa_text               probe
  return _.drop_suffix me, probe

#...........................................................................................................
_.drop_suffix = ( me, probe ) ->
  return me.substr 0, me.length - probe.length if _.ends_with me, probe
  return me

#-----------------------------------------------------------------------------------------------------------
$.contains = ( me, probe ) ->
  validate_argument_count_equals  2
  validate_isa_text               me
  validate_isa_text               probe
  return _.contains me, probe

#...........................................................................................................
_.contains = ( me, probe ) ->
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
  validate_argument_count_equals  1
  validate_isa_text               me
  return _.contains_only_digits me

#...........................................................................................................
_.contains_only_digits = ( me ) ->
  return false if _.is_empty me
  return ( me.match /^[0-9]+$/ )?

#-----------------------------------------------------------------------------------------------------------
$.is_empty = ( me ) ->
  validate_argument_count_equals  1
  validate_isa_text               me
  return _.is_empty me

#...........................................................................................................
_.is_empty = ( me ) ->
  return me.length == 0

#-----------------------------------------------------------------------------------------------------------
$.split = ( me, probe ) ->
  """Given a text and a ``probe``, which must be a text, a native JavaScript regular expression, or a regex
  object, return a list of substrings that result from splitting the text apart at all those places where
  the probe matched. If the probe is some flavor of a regular expression and contains groups, then group
  contents will be included in the list; otherwise, they will be omitted.

  ``TEXT.split`` behaves exactly like the native (V8) ``String::split`` method, except for the fact that
  all occurrances of (nonsensical, unexpected, spurious, troublesome) occurrences of ``undefined`` elements
  in the result list are filtered out. See ``http://xregexp.com/tests/split.html`` for examples of when
  that would occur, and http://blog.stevenlevithan.com/archives/npcg-javascript for a discussion of the
  phenomenon."""
  validate_argument_count_equals  2
  validate_isa_text               me
  validate_isa_text_or_anyregex   probe if probe?
  return _.split me, probe

#...........................................................................................................
_.split = TAINT.TODO """will only split once when given a text probe; unexpected results when starts
  or ends with probe; will fail with 32bit codepoints""",
( me, probe ) ->
  return _.words_of me unless probe?
  probe = if isa_regex probe then probe[ '%self' ] else probe
  R     = me.split probe
  return R.filter ( element ) -> return element isnt undefined

#-----------------------------------------------------------------------------------------------------------
$.words_of = ( me ) ->
  validate_argument_count_equals  1
  validate_isa_text               me
  return _.words_of me

#...........................................................................................................
_.words_of = TAINT.TODO "might not recognize all Unicode whitespace codepoints", ( me ) ->
  return ( me.replace /^\s*(.*?)\s*$/g, '$1' ).split /\s+/g

#-----------------------------------------------------------------------------------------------------------
$.as_text = ( me ) ->
  """Deep copy (i.e. here identity) function."""
  validate_argument_count_equals  1
  validate_isa_text               me
  return me

#...........................................................................................................
_.as_text = ( me ) ->
  return me

#-----------------------------------------------------------------------------------------------------------
$.lines_of = ( me ) ->
  validate_argument_count_equals  1
  validate_isa_text               me
  return _.lines_of me

#...........................................................................................................
_.lines_of = TAINT.TODO "might not recognize all Unicode line-end codepoints",
( me ) ->
  return me.split /\n/g

#-----------------------------------------------------------------------------------------------------------
$.chrs_of = ( me ) ->
  validate_argument_count_equals  1
  validate_isa_text               me
  return _.chrs_of me

#...........................................................................................................
_.chrs_of = TAINT.UNICODE """will split codepoints beyond u/ffff""",
( me ) ->
  return ( me[ idx ] for idx in [ 0 ... me.length ] )

#-----------------------------------------------------------------------------------------------------------
$.trim = ( me, trimmer = null ) ->
  validate_argument_count     arguments, 'min': 1, 'max': 2
  validate_isa_text           me
  return _.trim_whitespace me unless trimmer?
  validate_isa_text_or_regex  trimmer
  return _.trim me, trimmer

#...........................................................................................................
_.trim = ( me, trimmer ) ->
  return _.replace me, trimmer, ''

#...........................................................................................................
_.trim_whitespace = ( me ) ->
  """Faster whitespace trimming; adapted from
  http://blog.stevenlevithan.com/archives/faster-trim-javascript."""
  me          = me.replace /^\s\s*/, ''
  whitespace  = /\s/
  i           = me.length
  while whitespace.test me.charAt --i
    null
  return me.slice 0, i + 1

#-----------------------------------------------------------------------------------------------------------
$.cut = cut = TAINT.UNICODE """will split codepoints beyond u/ffff""",
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
  #validate_argument_count arguments, 'min': 2, 'max': 3
  validate_isa_text       me
  return flush me, width, 'left', filler

#-----------------------------------------------------------------------------------------------------------
$.flush_right = ( me, width = 25, filler = ' ' ) ->
  return flush me, width, 'right', filler

#-----------------------------------------------------------------------------------------------------------
$.flush = flush = ( me, width, align, filler = ' ' ) ->
  """Given a text, a non-negative integer ``width``, and an optional, non-empty text ``filler`` (which
  defaults to a single space), return a string that starts with the text, and is padded with as many
  fillers as needed to make the string ``width`` characters long. If ``width`` is zero or smaller than
  the length of the text, the text is simply returned as-is. No clipping of text is ever done."""
  #.........................................................................................................
  #validate_argument_count           arguments, 'min': 3, 'max': 4
  validate_isa_text                 me
  validate_isa_nonnegative_integer  width
  validate_isa_nonempty_text        align
  validate_isa_nonempty_text        filler
  unless align == 'left' or align == 'right'
    bye "expected ``left`` or ``right`` for ``align``, got #{rpr align}"
  #.........................................................................................................
  filler_length     = filler.length
  text_length       = me.length
  #.........................................................................................................
  return me if text_length >= width
  padding = _.repeat filler, width - text_length
  return if align == 'left' then me + padding else padding + me

#-----------------------------------------------------------------------------------------------------------
$.ruler = repeat '━', 108

#-----------------------------------------------------------------------------------------------------------
$.lower_case = lower_case = TAINT.UNICODE """does work for ÄÖÜ; unknown behavior for more exotic chrs""",
( me ) ->
  _validate_argument_count_eq arguments, 1
  validate_isa_text me
  return _.lower_case me

#...........................................................................................................
_.lower_case = TAINT.UNICODE """does work for ÄÖÜ; unknown behavior for more exotic chrs""",
( me ) ->
  return me.toLowerCase()

#-----------------------------------------------------------------------------------------------------------
$.upper_case = TAINT.UNICODE """does work for ÄÖÜ; unknown behavior for more exotic chrs""",
( me ) ->
  _validate_argument_count_eq arguments, 1
  validate_isa_text me
  return _.upper_case me

#...........................................................................................................
_.upper_case = TAINT.UNICODE """does work for ÄÖÜ; unknown behavior for more exotic chrs""",
( me ) ->
  return me.toUpperCase()

#===========================================================================================================
# RANDOMIZATION
#-----------------------------------------------------------------------------------------------------------
$.shuffle = ( me ) ->
  validate_argument_count_equals  1
  validate_isa_text               me
  return _.shuffle me

#...........................................................................................................
_.shuffle = ( me ) ->
  return ( LIST._.shuffle _.chrs_of me ).join ''


#===========================================================================================================
# UNSORTED
#-----------------------------------------------------------------------------------------------------------
$.length_of = ( me ) ->
  validate_argument_count_equals  1
  validate_isa_text               me
  return _.length_of me

#...........................................................................................................
_.length_of = TAINT.UNICODE """will incorrectly count codepoints above u/ffff as two chrs""",
( me ) ->
  return me.length

#-----------------------------------------------------------------------------------------------------------
$.replace = ( me, probe, replacement ) ->
  validate_argument_count_equals      3
  validate_isa_text                   me
  validate_isa_text_or_regex          probe
  validate_isa                        replacement, [ 'text', 'function', ]
  return _.replace me, probe, replacement

#...........................................................................................................
_.replace = ( me, probe, replacement ) ->
  if isa_text probe then probe = new_jsregex ( REGEX.escape probe ), 'g'
  return me.replace probe, replacement

#-----------------------------------------------------------------------------------------------------------
$.equals = ( me, probe ) ->
  #.........................................................................................................
  validate_argument_count_equals  2
  validate_isa_text               me
  return _.equals me, probe

#...........................................................................................................
_.equals = _.matches = ( me, probe ) ->
  return false if ( type_of probe ) != 'text'
  return me == probe

# #-----------------------------------------------------------------------------------------------------------
# $.new_list = TAINT.UNICODE  "will split codepoints beyond u/ffff into two surrogates",
# ( me ) ->
#   validate_argument_count_equals  1
#   validate_isa_text               me
#   return _.new_list me

# #...........................................................................................................
# _.new_list = TAINT.UNICODE  "will split codepoints beyond u/ffff into two surrogates",
# ( me ) ->
#   R         = []
#   push      = LIST.push
#   for idx in [ 0 ... $.length_of me ]
#     push R, me[ idx ]
#   return R

#-----------------------------------------------------------------------------------------------------------
$.as_html = ( me ) ->
  validate_argument_count_equals  1
  validate_isa_text               me
  return _.as_html me

#...........................................................................................................
_.as_html = ( me ) ->
  return HTML.h me

#-----------------------------------------------------------------------------------------------------------
$.partition = TAINT.UNICODE "will split codepoints beyond u/ffff",
( me, partitioner ) ->
  validate_argument_count_equals  2
  validate_isa_text               me
  validate_isa_positive_integer   partitioner
  return _.partition me, partitioner

#...........................................................................................................
_.partition = ( me, partitioner ) ->
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
    R.push _.slice me, idx, idx + n
  #.........................................................................................................
  return R

#-----------------------------------------------------------------------------------------------------------
$.slice = TAINT.TODO """must implement argument analysis: start, stop, min, max, delta;
  must implement negative indices""",
( me, start, stop ) ->
  validate_argument_count_equals            3
  validate_isa_text                         me
  validate_isa_nonnegative_integer_or_null  start
  validate_isa_nonnegative_integer_or_null  stop
  return _.slice me, start, stop

#...........................................................................................................
_.slice = ( me, start, stop ) ->
  # short form ``?=`` buggy; see https://github.com/jashkenas/coffee-script/issues/1627
  # but ok here since these are variables from the method signature
  start    ?= 0
  stop     ?= me.length
  return '' if start >= stop
  return me.slice start, stop
