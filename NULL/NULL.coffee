
############################################################################################################
$                         = exports ? here
# self                      = ( fetch 'library/barista' ).foo __filename
# log                       = self.log
_ = $._                   = {}
$                         = exports ? this
$.$ = $$                  = {}
#-----------------------------------------------------------------------------------------------------------
jq_extend                 = ( require 'jquery' ).extend

#-----------------------------------------------------------------------------------------------------------
$.equals = ( me, you ) ->
  validate_argument_count_equals  2
  validate_isa_null               me
  validate_isnt_undefined         you
  return _.equals me, you

#...........................................................................................................
_.equals = ( me, you ) ->
  return ( me is null ) and ( you is null )
