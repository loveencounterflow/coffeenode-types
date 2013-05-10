

.. .. image:: https://github.com/loveencounterflow/MULTIMIX/raw/master/artwork/multimix-small.png
..    :align: left

**CoffeeNode Types. You've waited for these guys. Now they're here. You've been warned**



🚀 TL;DR
============================================================================================================

The tiny JavaScript type checking library that *can*.


.. ☠ WTF?
.. ============================================================================================================

.. Type checking in JavaScript (and in CoffeeScript, which doesn't fix anything in this area) can be hard.
.. Error-prone. Mind-bending. Unsatisfactory. Misleading. It is not impossible to accomplish, but perplexing in
.. the details.

.. Case in point: ``NaN`` (which abbreviates 'Not A Number'). Do ``typeof NaN``, and learn that Mr. JS
.. Notanumber steadfastly believes he *is* a number. You never want to touch JavaScript's ``typeof`` again, not
.. if you're dealing with numbers. If you don't believe, look at this comparison of our ``type_of`` method with
.. JavaScript's ``typeof``—basically you can use ``typeof`` only to test whether something is a Boolean, a
.. function, a text, ``undefined``, or ... something else whatever:

.. ===============  ================= ===============
.. value            our ``type_of``   JS ``typeof``
.. ===============  ================= ===============
.. ``true``         ``boolean``       ``boolean``
.. ``->``           ``function``      ``function``
.. ``'text'``       ``text``          ``string``
.. ``undefined``    ``jsundefined``   ``undefined``
.. ``Infinity``     ``jsinfinity``    ``number``
.. ``NaN``          ``jsnotanumber``  ``number``
.. ``42``           ``number``        ``number``
.. ``[]``           ``list``          ``object``
.. ``new Date()``   ``jsdate``        ``object``
.. ``{}``           ``pod``           ``object``
.. ``global``       ``jsglobal``      ``object``
.. ``new RegExp()`` ``jsregex``       ``object``
.. ``new Error()``  ``jserror``       ``object``
.. ``arguments``    ``jsarguments``   ``object``
.. ``null``         ``null``          ``object``
.. ===============  ================= ===============

.. Turns out JavaScript's ``typeof`` operator is as useful as a cup of dandruff when it comes to telling
.. whether that value ``x`` is a list or what.

.. Likewise, the ``instanceof`` operator is deeply broken—with the effect that in JavaScript, ``42 instanceof
.. Number`` gives you ``false``, but ``typeof NaN == 'number'`` gives you ``true``. 💥OMFG💥. Don't worry, tho,
.. TYPES gives you a pair of boots to walk that mess.


.. 🎃 FTW!
.. ============================================================================================================

.. At its heart, TYPES uses the so-called  'Miller Device', which relies on analyzing the return value of
.. ``Object.prototype.toString x``. Some  additional checks are done where necessary, and some shortcuts are
.. taken where possible.

.. JavaScript types form a closed, not extensible set of names, as they have (almost) a
.. one-to-one mapping to data type implementations provided by the JavaScript Engine. They are divided into three
.. groups:

.. * The first and most important group comprises seven generic data types which are implemented in very
..   similar ways across all modern programming languages (C is an archaic language, not a modern
..   one); these are the classical JSON-compatible

..   * ``null``,
..   * ``boolean``,
..   * ``number`` (to the exclusion of ``NaN`` and ``Infinity``, which get their own types),
..   * ``text``,
..   * ``list``,
..   * ``pod`` (short for 'Plain Old Dictionary', i.e. what the JavaScript literature calls an 'object'),

..   plus the all-important

..   * ``function`` (which is not part of the JSON gamut of data types).

..   Yes, i call a text a 'text', not a 'string' (string of what?), and a list a 'list', not an 'array' (which
..   is better left to denote 'a list that can only have elements of a certain data type').

.. * Next up are those non-generic data types that are covered by the most important contemporary JavaScript
..   implementations, but are missing from other modern languages / have wildly diverging APIs / are covered
..   by libraries rather than being built into the language proper.

..   All names in this and the next group are prefixed by ``js``; note that we furthermore adopt the convention
..   to spell out all types in all-lower case and without any underscores or CamelCheese. This lends some
..   obscurity to these names, which is quite appropriate given that every single one of these has a fair
..   number of acid blog commentaries aimed at them (with the probable exclusion of ``jserror``).

..   The types include:

..   * ``jsundefined`` (it's OK to have a value to represent something that doesn't exist, but it's not cool
..     to make one value represent almost everything that can possibly go wrong in a programm);

..   * ``jsnotanumber`` (``NaN``, which appears as the result of some bogus
..     operations, such as adding a number and a text that does not 'look like' a number; this value is crazy
..     to the point it identifies itself as a number. Don't touch, move on); and, finally,

..   * ``jsinfinity``, (which appears as the result of some other bogus operations, such as dividing by zero
..     and calling ``Math.max()`` or ``Math.min()`` without arguments—something which should be forbidden: How
..     many apples does the biggest basket contain if there are no baskets to boot? In the strict sense, this
..     cannot be computed at all and in a conventional sense there are zero apples, but according to the weird
..     logic of JavaScript that you've grown to love, there are infinitely many! On the other hand, this data
..     type may have some utility, as positive and negative infinity can be used as entry values in series of
..     ``min`` / ``max`` comparisons);

..   * ``jsarguments`` (a strange thing that wants to be a list ever so badly; it is sometimes very practical
..     to have, but is missing from competing languages and will in a few years get removed from JavaScript,
..     too);

..   * ``jsdate`` (which is extremely difficult to handle correctly, and full of subtle bugs);

..   * ``jserror`` (the one data type in this group that looks OK);

..   * ``jsregex`` (also full of strange API decisions, bugs and unfixable shortcomings).

.. * In the last group are data types that are only available in some JavaScript VMs; these are

..   * ``jswindow`` and
..   * ``jsctx`` (only available in browsers; ``jsctx`` is the 'HTML canvas 2D drawing context');
..   * ``jsglobal`` (only in non-browser VMs, such as NodeJS); and, finally,
..   * ``jsarraybuffer`` (which belongs to a whole set of recent ECMA innovations[#]_)

.. .. [#] The other new kids on theblock in ES4 like ``Uint32Array`` and friends try hard to look like plain
..   old objects when you throw the Miller Device at them. Strangely enough.

.. In summary, ``TYPES.type_of x`` is your reliable friend when it comes to type checking.


.. LA VACHE 🐮 QUI RIT
.. ============================================================================================================

.. 🌞**Easing the chore of type-checking to the point of pure pleasure**🌞

.. **WTF??** You're already a MultiMix_ aficionado but don't know how to handle typing information? Read on!

.. **FTW!** ``TYPES`` gives you a whole slew of convenience methods to assist you in building readable and
.. terse yet semantically coded applications. For each of the types listed above there is a shortcut test
.. method that starts with ``isa_``:  ``isa_list``, ``isa_boolean``, ``isa_function``, ``isa_pod``,
.. ``isa_text``, ``isa_number``, ``isa_null``, ``isa_jsundefined``, ``isa_infinity``, ``isa_jsarguments``,
.. ``isa_jsnotanumber``, ``isa_jsdate``, ``isa_jsglobal``, ``isa_jsregex``, ``isa_jserror``, ``isa_jswindow``,
.. ``isa_jsctx`` and ``isa_jsarraybuffer``. So instead of ``( type_of x ) == 'text'``, you can say ``isa_text
.. x`` and you're done. But, it doesn't stop there:

.. There's also ``isa x, 'yourtypehere'`` and ``isa_of``. While all of the methods mentioned above—``type_of``
.. and the ``isa_$type`` family of methods—are of a generic nature and can be used in any kind of JavaScript
.. application environment, ``isa`` and ``isa_of`` are only suitable if you buy into the CoffeeNode philosophy.

.. To make a long story short, i do not believe in many tenets of classical object-oriented programming
.. anymore, be it class-based or prototype-based. Right now, mixins / traits seem to be the way to go, and when
.. you take a look at this module's sister library MultiMix_, you'll see that it's quite possible to assemble
.. complex, self-aware  objects from collections of other objects, something that is simpler yet more powerful
.. than classical OOP and rids you of classes and prototypes. Yay!

.. .. _MultiMix: https://github.com/loveencounterflow/MULTIMIX

.. A concommitant epiphany is that we should *not* mix methods and state in objects. Yes, that's right: no more
.. ``car.wheel_count = 4; car.passengers = [ 'Jim', 'John' ]; car.honk(); car.drive_to 'Paris'``! Instead,
.. adopt a library-oriented, data-centric way of life::

..   car = new_car
..     'wheel-count':      4
..     'passengers':       [ 'Jim', 'John' ]

..   AUTOMOTIVE.honk     car
..   AUTOMOTIVE.drive_to car, 'Paris'

.. This, in essence, exemplifies the philosophy of Library-oriented, Semantically inspired, Data-centric (LSD)
.. programming.[#]_

.. .. [#] And just because you're asking, yes, i plan to get rid of the explicit references to the
..   library out of the way so you'll be able to say::

..     honk     car
..     drive_to car, 'Paris'

..   where the 'free vocabulary' (here: ``honk``, ``drive_to``) is introduced from API specifications; it only
..   gets hooked up to library code the moment it is used. This will allow for a maximum of API /
..   implementation decoupling without introducing the atrocities of dependency injection.

.. It doesn't stop there, but you get the idea: build stateless libraries that contain all the methods you need
.. on the one hand, and stateful but dumb objects without methods on the other hand.

.. This is not the place to discuss the deeper motivation why i believe that doing things the LSD way is
.. superior; i just needed this example to motivate that in this model we can do meaningful **typing without
.. even touching any deep language feature** (say, JS prototypes or Python classes). The trick is to add a type
.. annotation in the object. Your ``car`` is now just a plain old dictionary that could look like ::

..   car =
..     '~isa':             'AUTOMOTIVE/limousine'
..     'wheel-count':      4
..     'passengers':       [ 'Jim', 'John' ]

.. where ``~isa`` tells you the name of the type of the object; the twiggle ``~`` in front of ``isa`` (which,
.. you guessed it, is just a contraction of '(this) is a (banana)') is a so-called *sigil* which serves to
.. delineate sub-namespaces (i follow the convention of reserving e.g. ``~`` for systematic, standardized
.. attributes, ``%`` for cached values and so on) to lower the risk of name collisions. So whatever kind of
.. value you have, you can always look at ``x[ '~isa' ]`` to tell what kind of thing this is.

.. By construction, the sample object is much more 'primitive' than you run-of-the-mill prototyped thing.
.. However, it is much more powerful. You might shout, *'WHAT, just a string of characters to type values?
.. Cannot work! What about accidental name clashes!?'*, and you would be right—except when working in an
.. context where you control naming, and except when (in a wider context) you start using URLs for typing
.. identification::

..   car =
..     '~isa':             'https://github.com/loveencounterflow/AUTOMOTIVE/limousine'
..     'wheel-count':      4
..     'passengers':       [ 'Jim', 'John' ]

.. I mean, URLs are just one-liners, but they still drive the world wide web, right? If they're good enough to
.. do that, they'll be good enough to identify objects i guess (plus, you get a handle to do distributed type /
.. method discovery).

.. Now we're in a position to understand what ``TYPES.isa`` and ``TYPES.isa_of`` do:

.. * if an object ``x`` does *not* have an ``~isa`` attribute, ``isa_of x`` returns whatever ``type_of x``
..   returns;

.. * if an object ``x`` *does* have an ``~isa`` attribute, ``isa_of x`` returns ``x[ '~isa' ]``;

.. * you can check whether ``x`` is what you expect it to be with ``isa x, 'FOO/bar'`` or ``( isa_of x ) ==
..   'FOO/bar'``.

.. And that's it![#]_

.. .. [#] While i do have some ideas about how to check a custom-typed object for its chain of derivation,
..   there isn't much in the way of working software there, so i just silently ignore that topic for the time
..   being. Practice has shown it is not important enough as to act as show stopper. I'll cross that bridge as
..   soon as i get there.

