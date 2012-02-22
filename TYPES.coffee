
############################################################################################################
$                         = exports ? @
log                       = console.log
rpr                       = ( x ) -> return ( require 'util' ).inspect x, false, 22
#-----------------------------------------------------------------------------------------------------------
njs_util                  = require 'util'
to_string                 = Object.prototype.toString
js_type_of                = ( x ) -> return to_string.call x


#===========================================================================================================
# TYPE ELUCIDATION
#-----------------------------------------------------------------------------------------------------------
coffeenode_type_by_js_type =
  '[object Array]':                     'list'
  '[object Boolean]':                   'boolean'
  '[object Function]':                  'function'
  '[object Null]':                      'null'
  '[object String]':                    'text'
  '[object Object]':                    'pod'
  #.........................................................................................................
  '[object Undefined]':                 'jsundefined'
  '[object Arguments]':                 'jsarguments'
  '[object Date]':                      'jsdate'
  '[object Error]':                     'jserror'
  '[object global]':                    'jsglobal'
  '[object RegExp]':                    'jsregex'
  '[object DOMWindow]':                 'jswindow'
  '[object CanvasRenderingContext2D]':  'jsctx'
  '[object ArrayBuffer]':               'jsarraybuffer'
  #.........................................................................................................
  '[object Number]': ( x ) ->
    return 'jsnotanumber' if isNaN x
    return 'jsinfinity'   if x == Infinity or x == -Infinity
    return 'number'

#-----------------------------------------------------------------------------------------------------------
$.type_of = ( x ) ->
  """Given any kind of value ``x``, return its type."""
  #.........................................................................................................
  validate_argument_count_equals 1
  R = coffeenode_type_by_js_type[ js_type_of x ]
  unless R? then throw new Error "unable to determine type of #{rpr x}"
  return if @isa_function R then R x else R

#...........................................................................................................
type_of = ( x ) ->
  """Slightly faster version of ``Y/type_of`` for internal use"""
  #.........................................................................................................
  R = coffeenode_type_by_js_type[ js_type_of x ]
  return if ( js_type_of R ) == '[object Function]' then R x else R



#===========================================================================================================
# TYPE TESTING
#-----------------------------------------------------------------------------------------------------------
# It is outright incredible, some would think frightening, how much manpower has gone into reliable
# JavaScript type checking. Here is the latest and greatest for a language that can claim to be second
# to none when it comes to things that should be easy but aren’t: the ‘Miller Device’ by Mark Miller of
# Google (http://www.caplet.com), popularized by James Crockford of Yahoo!.
#
# http://ajaxian.com/archives/isarray-why-is-it-so-bloody-hard-to-get-right
# http://blog.360.yahoo.com/blog-TBPekxc1dLNy5DOloPfzVvFIVOWMB0li?p=916 # page gone
# http://zaa.ch/past/2009/1/31/the_miller_device_on_null_and_other_lowly_unvalues/ # moved to:
# http://zaa.ch/post/918977126/the-miller-device-on-null-and-other-lowly-unvalues
#...........................................................................................................
$.isa_list          = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object Array]'
$.isa_boolean       = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object Boolean]'
$.isa_function      = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object Function]'
$.isa_pod           = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object Object]'
$.isa_text          = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object String]'
$.isa_number        = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object Number]' and isFinite x
$.isa_null          = ( x ) -> vaceq 1; return x is null
$.isa_jsundefined   = ( x ) -> vaceq 1; return x is undefined
$.isa_infinity      = ( x ) -> vaceq 1; return x == Infinity or x == -Infinity
#...........................................................................................................
$.isa_jsarguments   = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object Arguments]'
$.isa_jsnotanumber  = ( x ) -> vaceq 1; return isNaN x
$.isa_jsdate        = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object Date]'
$.isa_jsglobal      = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object global]'
$.isa_jsregex       = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object RegExp]'
$.isa_jserror       = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object Error]'
$.isa_jswindow      = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object DOMWindow]'
$.isa_jsctx         = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object CanvasRenderingContext2D]'
$.isa_jsarraybuffer = ( x ) -> vaceq 1; return ( js_type_of x ) == '[object ArrayBuffer]'

#-----------------------------------------------------------------------------------------------------------
# Replace some of our ``isa_*`` methods by the ≈6× faster methods provided by NodeJS ≥ 0.6.0, where
# available:
$.isa_list      = njs_util.isArray  if njs_util.isArray?
$.isa_jsregex   = njs_util.isRegExp if njs_util.isRegExp?
$.isa_jsdate    = njs_util.isDate   if njs_util.isDate?

#===========================================================================================================
# ISA HANDLING
#-----------------------------------------------------------------------------------------------------------
$.isa_of = ( x ) ->
  """Given a single argument ``x``, return the value of its ``~isa`` member, if it has any; otherwise,
  return ``Y/type_of x``."""
  #.........................................................................................................
  validate_argument_count_equals 1
  #.........................................................................................................
  return 'null'         if x is null
  return 'jsundefined'  if x is undefined
  #.........................................................................................................
  R = x[ '~isa' ]
  return R if R?
  #.........................................................................................................
  return type_of x

#-----------------------------------------------------------------------------------------------------------
$.isa = ( x, probe ) ->
  """Given any value ``x`` and a non-empty text ``probe``, return whether ``Y/isa_of x`` equals
  ``probe``."""
  validate_name probe
  return ( @isa_of x ) == probe

#-----------------------------------------------------------------------------------------------------------
$.set_isa = ( x, name ) ->
  validate_name probe
  x[ '~isa' ] = name

#-----------------------------------------------------------------------------------------------------------
$.full_type_of = ( x ) ->
  """Given a single argument ``x``, retrieve both its type and its isa specifier; if they are equal, return
  the type; otherwise, return type and specifier separated by a slash."""
  #.........................................................................................................
  validate_argument_count_equals 1
  return ( @_full_type_of x )[ 2 ]

#...........................................................................................................
$._full_type_of = ( x ) ->
  #.........................................................................................................
  type      = @type_of x
  specifier = @isa_of x
  full_type = if type == specifier then type else "#{type}/#{specifier}"
  #.........................................................................................................
  return [ type, specifier, full_type, ]


#===========================================================================================================
# HELPERS
#-----------------------------------------------------------------------------------------------------------
vaceq = validate_argument_count_equals = ( count ) ->
  a = arguments.callee.caller.arguments
  unless a.length == count then throw new Error "expected #{count} arguments, got #{a.length}"

#-----------------------------------------------------------------------------------------------------------
validate_name = ( x ) ->
  unless ( type_of x ) == 'text'  then throw new Error "expected a text, got a #{type_of x}"
  unless x.length > 0             then throw new Error "expected a non-empty text, got an empty one"




