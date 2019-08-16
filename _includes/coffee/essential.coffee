###
# Essential.js 1.1.20
# @author Cedric Ruiz
# @license MIT
# https://github.com/elclanrs/essential.js/
###

# Core
#
# coffeelint: disable=no_implicit_parens
# coffeelint: disable=space_operators
# coffeelint: disable=no_plusplus
# coffeelint: disable=spacing_after_comma

_ = {}
id = (x) -> x
K = (x) -> -> x
builtin = id.bind.bind id.call
toArray = builtin Array::slice
variadic = (as...) -> as

ncurry = (n, f, as=[]) -> (bs...) ->
  bs = as.concat bs
  if bs.length < n then ncurry n, f, bs else f bs...

λ = curry = (f) -> (as...) ->
  if f.length > as.length then ncurry f.length, f, as else f as...

apply = λ (f, as) -> f as...
applyNew = λ (f, as) -> new (f.bind [null, as...]...)

partial = (f, as...) -> (bs...) ->
  args = as.concat bs
  i = args.length
  while i--
    if args[i] is _
      args[i] = args.splice(-1)[0]
  f args...

flip = λ (f, x, y) -> f y, x
flip3 = λ (f, x, y, z) -> f z, y, x
nflip = (f) -> (as...) -> f as.reverse()...

unary = λ (f, x) -> f x
binary = λ (f, x, y) -> f x, y
nary = λ (n, f) -> (as...) -> f as[0...n]...

compose = (fs...) -> fs.reduce (f, g) -> (as...) -> f g as...
pcompose = (fs...) -> (xs) -> xs.map (x, i) -> fs[i]? x
sequence = nflip compose

over = λ (f, g, x, y) -> f g(x), g y

notF = (f) -> (as...) -> not f as...
eq = λ (x, y) -> y is x
notEq = λ (x, y) -> y isnt x

typeOf = (x) -> Object::toString.call(x).slice 8, -1
isType = λ (t, x) -> typeOf(x) is t

toObject = (xs) ->
  xs.reduce (acc, x, i) ->
    acc[xs[i-1]] = x if i % 2
    acc
  ,{}

extend = (a, bs...) ->
  for b in bs
    for own k, v of b
      a[k] = v
  a

deepExtend = (a, bs...) ->
  for b in bs
    for own k, v of b
      a[k] = if typeof v is 'object'
        deepExtend a[k], v
      else
        v
  a

deepClone = (obj) ->
  init = if isType 'Array', obj then [] else {}
  Object.keys(obj).reduce (acc, k) ->
    x = obj[k]
    mustClone = isType('Array', x) or isType 'Object', x
    acc[k] = if mustClone then deepClone x else x
    acc
  ,init

forOwn = λ (acc, f, obj) ->
  Object.keys(obj).forEach (k, i) -> acc = f acc, k, obj[k], i
  acc

fold = flip3 builtin Array::reduce
fold1 = λ (f, xs) -> fold xs[0], f, xs
foldr = flip3 builtin Array::reduceRight
foldr1 = λ (f, xs) -> foldr xs[0], f, xs
map = flip builtin Array::map
filter = flip builtin Array::filter
any = flip builtin Array::some
all = flip builtin Array::every
each = flip builtin Array::forEach
indexOf = flip builtin Array::indexOf
concat = builtin Array::concat

slice = λ (i, j, xs) -> if j? then xs[i...j] else xs[i..]

first = ([x, xs...]) -> x
last = ([xs..., x]) -> x
rest = slice 1, null
initial = slice 0, -1
take = slice 0
drop = partial slice, _, null, _

inArray = λ (xs, x) -> x in xs

remove = λ (x, xs) ->
  ys = xs[..]
  ys.splice xs.indexOf(x), 1
  ys

tails = (xs) -> xs.map (x, i) -> xs[i..]

uniqueBy = λ (f, xs) ->
  seen = []
  xs.filter (x) ->
    fx = f x
    return if fx in seen
    seen.push fx
    true

unique = uniqueBy id

dups = (xs) -> xs.filter (x, i) -> xs.indexOf(x) isnt i

flatten = (xs) ->
  while xs.some Array.isArray
    xs = Array::concat xs...
  xs

union = compose unique, flatten, variadic
intersection = compose unique, dups, flatten, variadic

flatMap = λ (xs, f) ->
  xs.reduce (acc, x) ->
    acc.concat f x
  ,[]

pluck = λ (x, xs) ->
  String(x).split('.').reduce (acc, x) ->
    return unless acc?
    acc[x]
  ,xs

deepPluck = λ (x, xs) ->
  out = []
  while xs = pluck x, xs
    out.push xs
  out

where = λ (obj, xs) ->
  xs.filter (x) ->
    Object.keys(obj).every (k) -> obj[k] is x[k]

deepWhere = λ (match, xs) ->
  find = λ (match, obj) ->
    Object.keys(obj).every (k) ->
      mustFind = [obj[k], match[k]].every (x) ->
        isType 'Object', x or isType 'Array', x
      if mustFind
        return find match[k], obj[k]
      match[k] is obj[k]
  xs.filter find match

values = (obj) -> (v for own _, v of obj)
pairs = forOwn [], (acc, k, v) -> acc.concat [[k, v]]

interleave = λ ([x, xs...], ys) ->
  unless x?
    return ys
  [x].concat interleave ys, xs

intersperse = λ (x, xs) ->
  out = [xs[0]]
  for y, i in xs[1..]
    out.push x, y
  out

intercalate = compose flatten, intersperse

zip = (xss...) -> xss[0].map (_, i) -> xss.map pluck i
zipWith = (f, xss...) -> apply(zip, xss).map partial apply, f

zipObject = compose toObject, flatten, zip

unzipObject = forOwn [[],[]], (acc, k, v, i) ->
  acc[0][i] = k ; acc[1][i] = v
  acc

range = λ (m, n) -> [m..n]

shuffle = (xs) ->
  ys = xs[..]
  for _, i in ys
    j = Math.random() * (i + 1) |0
    [ys[i], ys[j]] = [ys[j], ys[i]]
  ys

sortBy = λ (f, xs) ->
  xs.sort (x, y) ->
    fx = f x
    fy = f y
    switch
      when fx > fy then 1
      when fx < fy then -1
      else 0

groupBy = λ (f, xs) ->
  xs.reduce (acc, x) ->
    fx = f x
    acc[fx] = (acc[fx] or []).concat [x]
    acc
  ,{}

countBy = sequence groupBy, forOwn {}, (acc, k, v) ->
  acc[k] = v.length
  acc

format = λ (xs, x) ->
  x.replace /%(\d+)/g, (_, i) -> xs[--i] or ''

template = λ (obj, x) ->
  x.replace /#\{(.+?)\}/g, (_, k) -> obj[k] or ''

gmatch = λ (re, x) ->
  out = []
  x.replace re, (as...) -> out.push.apply out, as[1...-2]
  out

permutations = (xs) ->
  unless xs.length
    return [[]]
  out = []
  for x in xs
    for ys in permutations remove x, xs
      out.push [x].concat ys
  out

combinations = (xs) ->
  combine = (n, xs) ->
    if n is 0
      return [[]]
    flatMap tails(xs), ([y, xs_...]) ->
      combine(n - 1, xs_).map (ys) ->
        [y, ys...]
  flatMap [1..xs.length], (n) -> combine n, xs

powerset = ([x, xs...]) ->
  unless x?
    return [[]]
  xss = powerset xs
  interleave xss, xss.map binary concat, [x]

# Fantasy
#
# fmap = λ (f, ma) -> ma.map f
# ap = λ (mf, ma) -> ma.ap mf
# chain = λ (f, ma) -> ma.chain f

# liftA = λ (ctor, f, ms) ->
#   ms.reduce(
#     (acc, ma) -> acc.ap ma
#     ctor.of f
#   )

# seqM = λ (ctor, ms) ->
#   ms.reduceRight(
#     (ma, mb) ->
#       ma.chain (a) ->
#         mb.map (b) ->
#           [b].concat a
#     ctor.of []
#   )

# # Exports
# #
# module.exports = {
#   # Core
#   _, id, K,
#   builtin, toArray,
#   variadic, apply, applyNew,
#   ncurry, λ, curry, partial,
#   flip, flip3, nflip,
#   unary, binary, nary,
#   compose, pcompose, sequence, over,
#   notF, not:notF, eq, notEq, typeOf, isType,
#   toObject, extend, deepExtend, deepClone, forOwn,
#   fold, fold1, foldr, foldr1, map, filter, any, all, each, indexOf, concat,
#   slice, first, last, rest, initial, take, drop,
#   inArray, remove, tails, uniqueBy, unique, dups,
#   flatten, union, intersection, flatMap,
#   pluck, deepPluck, where, deepWhere,
#   values, pairs, interleave, intersperse, intercalate,
#   zip, zipWith, zipObject, unzipObject,
#   range, shuffle,
#   sortBy, groupBy, countBy,
#   format, template, gmatch, permutations, combinations, powerset,
#   # Fantasy
#   fmap, ap, chain, liftA, seqM
# }

# module.exports.expose = partial extend, _, module.exports

# coffeelint: enable=space_operators
# coffeelint: enable=no_plusplus
# coffeelint: enable=spacing_after_comma
# coffeelint: enable=no_implicit_parens

# More functions NOT from essential.coffee


do_ = (f) ->
  (x) ->
    f(x)
    x


copy_ = sequence(JSON.stringify, JSON.parse)


flat_key = curry(
  (key, data) ->
    ### Flatten a sublist of a dictionary

    For example {a:0, b:[0, 1]} goes to [{a:0, b:0}, {a:0, b:1}] or
    {a:0, b:[{c:0, c:1}]} goes to [{a:0, b:{c:0}}, {a:0, b:{c:1}}]

    Args:
      key: the key that contains the list to flatten
      data: the dictionary to flatten

    Returns:
      a list of dictionaries
    ###
    f = (x) ->
      extend(copy_(data), {"#{key}":x})
    map(f, data[key])
)


flat_key_from_list = curry(
  (key, data) ->
    ### Flatten a list of dictionaries

    For example

      [{a:0, b:[1, 2]}, {a:3, b:[4, 5]}]

    goes to

      [{a:0, b:1}, {a:0, b:2}, {a:3, b:4}, {a:3, b:5}]

    Args:
      key: the key that contains the list to flatten
      data: the list of dictionaries to flatten

    Returns:
      a list of flattened dictionaries
    ###
    concat.apply(_, map(flat_key(key), data))
)


to_list = curry(
  (key, dict) ->
    ### Make a dictionary into a list

    For example

      {a:{b:1}, c:{b:2}}

    goes to

      [{key:a, b:1}, {key:c, b:2}]
    ###
    (Object.assign({}, v, {"#{key}":k}) for k, v of dict)
)


pluck_arr = curry(
  (key, arr) ->
    ### Pluck a value from a list of dictionaries.

    For example

      [{a:1}, {a:2}]

    goes to

      [1, 2]
    ###
    map((x) -> x[key])(arr)
)


pluck_arr_list = curry(
  (keys, arr) ->
    ### Pluck a value from a list of dictionaries using a list of keys

    For example

      pluck_arr_list(
        [{a:1, b:2}, {a:2, b:3}]
        ['x', 'b']

    should return

      [2, 3]
    ###
    sequence(
      map((x) -> pluck_arr(x, arr))
      filter((x) -> x[0]?)
      first
    )(keys)
)


get = curry(
  (key, dict) ->
    ### Get an element of an object
    ###
    dict[key]
)


get_last = (x) ->
  [..., last] = x
  last


get_or = curry(
  (key, def, dict) ->
    get(key, dict) or def
)



debug = curry(
  (message, x) ->
    console.log(message)
    console.log(x)
    x
)

map_undef = curry(
  (func, object) ->
    sequence(
      map(func)
      filter((x) -> x?)
    )(object)
)


transpose = (matrix) ->
  (t[i] for t in matrix) for i in [0...matrix[0].length]


modify_keys = curry(
  (f, x) ->
    ### Modify keys in dict
    ###
    x_ = {}
    for k, v of x
      x_[f(k)] = v
    x_
)

make_array = (x) ->
  if typeof(x) is 'object'
    x
  else
    [x]

unzip = (x) ->
  zip(x...)

juxt = curry(
  (fs, x) ->
    (f(x) for f in fs)
)
