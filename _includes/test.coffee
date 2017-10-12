assert = require('assert')

it('test mocha', ->
  assert.equal(1, 1)
)

it('test user_repo', ->
  assert.equal(user_repo('https://github.com/wd15/pymks/tree/master/doc'),
                         'wd15/pymks')
)
