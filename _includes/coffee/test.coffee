assert = require('assert')


it('test mocha', ->
  assert.equal(1, 1)
)


it('test user_repo', ->
  assert.equal(user_repo('https://github.com/wd15/pymks/tree/master/doc'),
                         'wd15/pymks')
)


it('test to_date', ->
  assert.equal(to_date('Tue Jan 31 12:01:55 EST 2017'),
               'Jan 31, 2017')
)


it('test get_software', ->
  assert.equal(get_software('moose',
                            [{name:'MOOSE', value:0},
                             {name:'fipy', value:1}]).value,
               0)
)


it('test get_data', ->
  assert.equal(get_software('name1',
                            [{name:'name0', value:0},
                             {name:'name1', value:1}]).value,
               1)
)


it('test memory_usage', ->
  assert.equal(
    memory_usage(
      {data:[{name:'memory_usage', values:[{value:'1000', unit:'MB'}]},
             {name:'other', value:1}]}
    ),
   '1000.0 MB')
)


it('test count_uploads_num', ->
  data = ->
    {example:{},
    a:{meta:{benchmark:{id:'1a.0'}}},
    b:{meta:{benchmark:{id:'1a.0'}}},
    c:{meta:{benchmark:{id:'2a.0'}}}
    }

  assert.equal(count_uploads_num(1, data()), 2)
)


it('test count_uploads_id', ->
  data = ->
    {example:{},
    a:{meta:{benchmark:{id:'1a', version:1}}},
    b:{meta:{benchmark:{id:'1a', version:1}}},
    c:{meta:{benchmark:{id:'2a', version:1}}},
    d:{meta:{benchmark:{id:'1a', version:0}}}
    }
  assert.equal(count_uploads_id('1a.1', data()), 2)
)


benchmark_data_in = ->
  [
    {
      title:'first'
      revisions:
        [
          {
            variations:['a', 'b']
            version:1
          }
          {
            variations:['a', 'b']
            version:0
          }
        ]
    }
    {
      title:'second'
      revisions:
        [
          {
            version:1
            variations:['a', 'b']
          }
          {
            version:0
            variations:['a', 'b']
          }
        ]
    }
  ]


it('test get_columns', ->
  assert.equal(get_columns()[5].data, 'num')
)


it('test get_benchmark_data', ->
  assert.deepEqual(
    get_benchmark_data(benchmark_data_in()).data[0].title
    'first'
  )
)


describe('test flat_key', ->
  it('with a list', ->
    assert.deepEqual(
      flat_key('b', {a:0, b:[0, 1]})
      [{a:0, b:0}, {a:0, b:1}]
    )
  )
  it('with a dict', ->
    assert.deepEqual(
      flat_key('b', {a:0, b:[{c:0}, {c:1}]})
      [{a:0, b:{c:0}}, {a:0, b:{c:1}}]
    )
  )
)


describe('test flat_key_from_list', ->
  it('with one key', ->
    assert.deepEqual(
      flat_key_from_list('b', [{a:0, b:[1, 2]}, {a:3, b:[4, 5]}])
      [{a:0, b:1}, {a:0, b:2}, {a:3, b:4}, {a:3, b:5}]
    )
  )
)


describe('test transform_data', ->
  it('with test data', ->
    data_out = ->
      [
        {
          title:'first'
          variations:'a'
          revisions:
            {
              variations:['a', 'b']
              version:1
            }
        }
        {
          title:'first'
          variations:'b'
          revisions:
            {
              variations:['a', 'b']
              version:1
            }
        }
        {
          title:'first'
          variations:'a'
          revisions:
            {
              variations:['a', 'b']
              version:0
            }
        }
        {
          title:'first'
          variations:'b'
          revisions:
            {
              variations:['a', 'b']
              version:0
            }
        }
        {
          title:'second'
          variations:'a'
          revisions:
            {
              variations:['a', 'b']
              version:1
            }
        }
        {
          title:'second'
          variations:'b'
          revisions:
            {
              variations:['a', 'b']
              version:1
            }
        }
        {
          title:'second'
          variations:'a'
          revisions:
            {
              variations:['a', 'b']
              version:0
            }
        }
        {
          title:'second'
          variations:'b'
          revisions:
            {
              variations:['a', 'b']
              version:0
            }
        }
      ]
    assert.deepEqual(
      transform_data(benchmark_data_in())
      data_out()
    )
  )
)


describe('test benchmark_id', ->
  it('with sample data', ->
    data = ->
      {
        num:1
        variations:'a'
        revisions:{version:0, url:'http://wow.com'}
      }
    assert.deepEqual(
      benchmark_id({}, {}, data())
      '<a href="http://wow.com" target="_blank">\n1a.0\n</a>'
    )
  )
)


describe('test make_http', ->
  it('with no http', ->
    assert.deepEqual(make_http('wow').substr(0, 4), '/pfh')
  )
  it('with http', ->
    assert.deepEqual(make_http('http://wow'), 'http://wow')
  )
)


describe('test commit', ->
  it('with test data', ->
    data_in = ->
      {revisions:{commit:{sha:'abcd', url:'a/b'}}}
    data_out = ->
      '<a href="{{ site.links.github }}/\
      blob/abcd/a/b" target="_blank">\nabcd\n</a>'
    assert.deepEqual(commit({}, {}, data_in()), data_out())
  )
)


describe('test filter_num_revision', ->
  data_in = ->
    {num:1, revisions:{version:1}}
  it('with true data', ->
    assert.deepEqual(filter_num_revision([1], 1)(data_in()), true)
  )
  it('with false data', ->
    assert.deepEqual(filter_num_revision([0], 1)(data_in()), false)
  )
  it('with null data', ->
    assert.deepEqual(filter_num_revision(null, null)(data_in()), true)
  )
)


describe('test to_list', ->
  it('simple test', ->
    assert.deepEqual(
      to_list('my_key', {a:{b:1}, c:{b:2}})
      [{my_key:'a', b:1}, {my_key:'c', b:2}]
    )
  )
)


describe('test pluck_arr', ->
  it('simple test', ->
    assert.deepEqual(
      pluck_arr('a', [{a:1}, {a:2}])
      [1, 2]
    )
  )
  it('missing key', ->
    assert.deepEqual(
      pluck_arr('a', [{a:1}, {b:2}])
      [1, null]
    )
  )
)


describe('test get', ->
  it('simple test', ->
    assert.deepEqual(
      get(1, [1, 2, 3])
      2
    )
  )
  it('simple test', ->
    assert.deepEqual(
      get_or(5, 'wow', [1, 2, 3])
      'wow'
    )
  )
)

describe('test map_undef', ->
  it('simple test', ->
    assert.deepEqual(
      map_undef(((x) -> x), [1, undefined, 3, null, 0])
      [1, 3, 0]
    )
  )
)

describe('test github_to_raw', ->
  slug = ->
    'jah5759/benchmark_results'
  path = ->
    '1_spinodal_decomp/1a_square_periodic/1a_square_periodic_out.csv'
  slug_long = ->
    'longusernamelongusername/benchmark_results'
  raw_base = ->
    'https://raw.githubusercontent.com'
  it('with github.com address', ->
    assert.deepEqual(
      github_to_raw(
        "https://github.com/#{slug()}/blob/benchmark_results/#{path()}"
      )
      "#{raw_base()}/#{slug()}/benchmark_results/#{path()}"
    )
  )
  it('without github.com address', ->
    assert.deepEqual(
      github_to_raw(
        'https://bitly.com/'
      )
      'https://bitly.com/'
    )
  )
  it('with GitHub.com address', ->
    assert.deepEqual(
      github_to_raw(
        "https://GitHub.com/#{slug()}/blob/benchmark_results/#{path()}"
      )
      "#{raw_base()}/#{slug()}/benchmark_results/#{path()}"
    )
  )
  it('with www.github.com address', ->
    assert.deepEqual(
      github_to_raw(
        "https://www.github.com/#{slug()}/blob/benchmark_results/#{path()}"
      )
      "#{raw_base()}/#{slug()}/benchmark_results/#{path()}"
    )
  )
  it('with long user name', ->
    assert.deepEqual(
      github_to_raw(
        "https://www.github.com/#{slug_long()}/blob/benchmark_results/#{path()}"
      )
      "#{raw_base()}/#{slug_long()}/benchmark_results/#{path()}"
    )
  )
  it('with http not https', ->
    assert.deepEqual(
      github_to_raw(
        "http://github.com/#{slug()}/blob/benchmark_results/#{path()}"
      )
      "#{raw_base()}/#{slug()}/benchmark_results/#{path()}"
    )
  )
)

describe('test get_github_repo_link', ->
  it('no path', ->
    assert.deepEqual(
      get_github_repo_link(
        {url:'https://github.com/wd15/pfhub', version:'version'}
      ).text,
      'git:wd15/pfhub@version'
    )
  )
  it('with path', ->
    assert.deepEqual(
      get_github_repo_link(
        {
          url:'https://github.com/wd15/pfhub/tree/master/_code'
          version:'version'
        }
      ).text,
      'git:wd15/pfhub:/_code@version'
    )
  )
)


describe('test get_github_gist_link', ->
  it('gist', ->
    assert.deepEqual(
      get_github_gist_link(
        {
          url:'https://gist.github.com/wd15/7e06a3141a6fbf317b1daf39ef1b0fbb'
          version:'fc9134b08a9c'
        }
      ).text,
      'gist:wd15/7e06a314@fc9134b0'
    )
  )
)


describe('test get_bitbucket_link', ->
  it('gist', ->
    assert.deepEqual(
      get_bitbucket_link(
        {url:'https://bitbucket.org/ajokisaari/coral/', version:'e8fc74f'}
      ).text,
      'git:ajokisaari/coral@e8fc74f'
    )
  )
)


describe('test get_generic_link', ->
  it('gist', ->
    assert.deepEqual(
      get_generic_link(
        {url:'https://bitbucket.org/ajokisaari/coral/', version:'e8fc74f'}
      ).text,
      'file:https://bitbucket.org/ajokisaari/coral/@e8fc74f'
    )
  )
)


describe('test get_link', ->
  it('broken link', ->
    assert.deepEqual(
      get_link(
        {url:'https://www.google.com', version:'e8fc74f'}
      ),
      null
    )
  )
)


describe('test get_last', ->
  it('last element', ->
    assert.deepEqual(
      get_last([1, 2, 3])
      3
    )
  )
)


describe('test transpose', ->
  it('4 x 4', ->
    assert.deepEqual(
      transpose([[1, 2], [3, 4]])
      [[1, 3], [2, 4]]
    )
  )
)


describe('test pluck_arr_list', ->
  it('simple', ->
    assert.deepEqual(
      pluck_arr_list(['x', 'b'], [{a:1, b:2}, {a:2, b:3}]),
      [2, 3]
    )
  )
  it('failure', ->
    assert.deepEqual(
      pluck_arr_list(['x', 'b'], [{a:1, b:2}, {a:2, x:1}]),
      [2, undefined]
    )
  )
)


describe('test modify_keys', ->
  it('simple', ->
    assert.deepEqual(
      modify_keys(
        (x) -> x.replace(/\s/g, '_')
        {'white space':1}
      )
      {'white_space':1}
    )
  )
)


describe('test make_array', ->
  it('change', ->
    assert.deepEqual(
      make_array('hi')
      ['hi']
    )
  )
  it('no change', ->
    assert.deepEqual(
      make_array(['hi'])
      ['hi']
    )
  )
)


describe('test unzip', ->
  it('simple', ->
    assert.deepEqual(
      unzip([['a', 1], ['b', 2], ['c', 3]])
      [['a', 'b', 'c'], [1, 2, 3]]
    )
  )
)


describe('test juxt', ->
  it('simple', ->
    assert.deepEqual(
      juxt([
        (x) -> x * 2
        (x) -> x / 2
        ], 2.0)
      [4.0, 1.0]
    )
  )
)


describe('test reorder', ->
  it('simple', ->
    assert.deepEqual(
      reorder(
        [0, 0]
        'data'
        'x'
        'y'
        [
          {
            name:'data'
            values:
              [{x:0.0, y:1.0}, {x:1.0, y:0.0}, {x:-1.0, y:0.0}]
          }
        ]
      )
      [[1, 0, -1], [0, 1, 0]]
    )
  )
)
