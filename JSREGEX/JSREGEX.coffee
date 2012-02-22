

############################################################################################################
$                         = exports ? here
self                      = ( fetch 'library/barista' ).foo __filename
log                       = self.log
log_ruler                 = self.log_ruler
stop                      = self.STOP
_   = $._                 = {}
$.$ = $$                  = {}
#-----------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------
$.matches = ( me, probe ) ->
  validate_argument_count_equals  2
  validate_isa_jsregex            me
  validate_isa_text               probe
  return _.matches me, probe

#...........................................................................................................
_.matches = ( me, probe ) ->
  return me.test probe

#-----------------------------------------------------------------------------------------------------------
$.set_global = ( me, is_global ) ->
  """Given a JS regular expression object, return either a copy of it with the global flag set, or return
  the object itself if its global flag is already set."""
  validate_argument_count_equals  2
  validate_isa_jsregex            me
  validate_isa_boolean            is_global
  return _.set_global me, is_global

#...........................................................................................................
_.set_global = ( me, is_global ) ->
  return me if me.global == is_global
  flags = if is_global then [ 'g' ] else []
  flags.push 'm' if me.multiline
  flags.push 'i' if me.ignoreCase
  return new_jsregex me.source, flags.join ''

