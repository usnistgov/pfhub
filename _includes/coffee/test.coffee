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


it('test count_uploads', ->
  data = ->
    {example:{},
    a:{meta:{benchmark:{id:'1a.0'}}},
    b:{meta:{benchmark:{id:'1a.0'}}},
    c:{meta:{benchmark:{id:'2a.0'}}}
    }

  assert.equal(count_uploads(1, data()), 2)
)


it('test get_columns', ->
  assert.equal(get_columns()[0].data, 'num')
)


it('test get_benchmark_data', ->
  assert.deepEqual(get_benchmark_data({a:1}).data, {a:1})
)


describe('test flat key', ->
  it('with a list', ->
    assert.deepEqual(
      flat_key({a:0, b:[0, 1]}, 'b')
      [{a:0, b:0}, {a:0, b:1}]
    )
  )
  it('with a dict', ->
    assert.deepEqual(
      flat_key({a:0, b:[{c:0}, {c:1}]}, 'b')
      [{a:0, b:{c:0}}, {a:0, b:{c:1}}]
    )
  )
)
