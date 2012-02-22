
############################################################################################################
$                         = exports ? @
log                       = console.log
rpr                       = ( x ) -> return ( require 'util' ).inspect x, false, 22
#-----------------------------------------------------------------------------------------------------------
$                         = require './TYPES'
to_string                 = Object.prototype.toString
js_type_of                = ( x ) -> return to_string.call x


#...........................................................................................................
test = ->
  log 'list',         typeof []
  log 'boolean',      typeof true
  log 'jsdate',       typeof new Date()
  log 'function',     typeof ->
  log 'pod',          typeof {}
  log 'jsglobal',     typeof global
  log 'jsregex',      typeof new RegExp()
  log 'jserror',      typeof new Error()
  log 'text',         typeof 'text'
  log 'jsarguments',  typeof arguments
  log 'null',         typeof null
  log 'jsundefined',  typeof undefined
  log 'jsinfinity',   typeof Infinity
  log 'jsnotanumber', typeof NaN
  log 'number',       typeof 42
test()

`log( [] instanceof Array )`

#...........................................................................................................
test = ->
  log 'list',         []            instanceof Array
  log 'boolean',      true          instanceof Boolean
  log 'jsdate',       new Date()    instanceof Date
  # log 'function',     ->            instanceof Function
  log 'pod',          {}            instanceof Object
  log 'jsglobal',     global        instanceof Object
  log 'jsregex',      new RegExp()  instanceof RegExp
  log 'jserror',      new Error()   instanceof Error
  log 'text',         'text'        instanceof String
  log 'jsarguments',  arguments     instanceof Object
  log 'null',         null          instanceof Object
  log 'jsundefined',  undefined     instanceof Object
  log 'jsinfinity',   Infinity      instanceof Number
  log 'jsnotanumber', NaN           instanceof Number
  log 'number',       42            instanceof Number
test()

#...........................................................................................................
test = ->
  log 'list',         rpr $.type_of []
  log 'boolean',      rpr $.type_of true
  log 'jsdate',       rpr $.type_of new Date()
  log 'function',     rpr $.type_of ->
  log 'pod',          rpr $.type_of {}
  log 'jsglobal',     rpr $.type_of global
  log 'jsregex',      rpr $.type_of new RegExp()
  log 'jserror',      rpr $.type_of new Error()
  log 'text',         rpr $.type_of 'text'
  log 'jsarguments',  rpr $.type_of arguments
  log 'null',         rpr $.type_of null
  log 'jsundefined',  rpr $.type_of undefined
  log 'jsinfinity',     rpr $.type_of Infinity
  log 'jsnotanumber', rpr $.type_of NaN
  log 'number',       rpr $.type_of 42
# test()

#...........................................................................................................
test = ->
  log 'list',         ( $.isa_of []                 ) == $.type_of []
  log 'boolean',      ( $.isa_of true               ) == $.type_of true
  log 'jsdate',       ( $.isa_of new Date()         ) == $.type_of new Date()
  log 'function',     ( $.isa_of ->                 ) == $.type_of ->
  log 'pod',          ( $.isa_of {}                 ) == $.type_of {}
  log 'jsglobal',     ( $.isa_of global             ) == $.type_of global
  log 'jsregex',      ( $.isa_of new RegExp()         ) == $.type_of new RegExp()
  log 'jserror',      ( $.isa_of new Error()          ) == $.type_of new Error()
  log 'text',         ( $.isa_of 'text'             ) == $.type_of 'text'
  log 'jsarguments',    ( $.isa_of arguments          ) == $.type_of arguments
  log 'null',         ( $.isa_of null               ) == $.type_of null
  log 'jsundefined',    ( $.isa_of undefined          ) == $.type_of undefined
  log 'jsinfinity',     ( $.isa_of Infinity           ) == $.type_of Infinity
  log 'jsnotanumber', ( $.isa_of NaN                ) == $.type_of NaN
  log 'number',       ( $.isa_of 42                 ) == $.type_of 42
  log 'FOO/bar',      ( $.isa_of '~isa': 'FOO/bar'  ) == 'FOO/bar'
#test()


test = ->
  log 'ArrayBuffer',   ( js_type_of new ArrayBuffer()  ), $.type_of new ArrayBuffer()
  log 'Int8Array',     ( js_type_of new Int8Array()    ), $.type_of new Int8Array()
  log 'Uint8Array',    ( js_type_of new Uint8Array()   ), $.type_of new Uint8Array()
  log 'Int16Array',    ( js_type_of new Int16Array()   ), $.type_of new Int16Array()
  log 'Uint16Array',   ( js_type_of new Uint16Array()  ), $.type_of new Uint16Array()
  log 'Int32Array',    ( js_type_of new Int32Array()   ), $.type_of new Int32Array()
  log 'Uint32Array',   ( js_type_of new Uint32Array()  ), $.type_of new Uint32Array()
  log 'Float32Array',  ( js_type_of new Float32Array() ), $.type_of new Float32Array()
  log 'Float64Array',  ( js_type_of new Float64Array() ), $.type_of new Float64Array()
  log 'Buffer',        ( js_type_of new Buffer( 42 )   ), $.type_of new Buffer( 42 )
  log 'global',        ( js_type_of global             ), $.type_of global
  log 'process',       ( js_type_of process            ), $.type_of process
  log 'GLOBAL',        ( js_type_of GLOBAL             ), $.type_of GLOBAL
  log 'root',          ( js_type_of root               ), $.type_of root
  log 'setTimeout',    ( js_type_of setTimeout         ), $.type_of setTimeout
  log 'setInterval',   ( js_type_of setInterval        ), $.type_of setInterval
  log 'clearTimeout',  ( js_type_of clearTimeout       ), $.type_of clearTimeout
  log 'clearInterval', ( js_type_of clearInterval      ), $.type_of clearInterval
  log 'console',       ( js_type_of console            ), $.type_of console
  log 'DataView',      ( js_type_of new Int32Array new ArrayBuffer() ), $.type_of new Int32Array new ArrayBuffer()
test()
log ( new Int32Array new ArrayBuffer() ) instanceof DataView
log ( new Int32Array new ArrayBuffer() ) instanceof Int32Array

# log JSON.stringify
#   bar: 42,
#   foo: -> log 'helo world'
#   baz: [ 1,2,3,-> log 'helo world' ]

