chai = require('chai')
expect = chai.expect
should = chai.should()
assert = chai.assert

makeQuery = require('../../source/request-helpers/makeQuery')
{schema, model, name, validator} = require('../../resources/shells/schema')

describe 'test makeQuery', () ->

  it 'makes a default query', () ->
    query = makeQuery(model, {}, {}, { callerId: { $eq: 1 } })
#    console.log(query)
    query._conditions.callerId['$eq'].should.be.equal(1)
    return

  it 'makes a combined find limited to the required fields', () ->
    query = makeQuery(model, {find: '{"id": 1}'}, {caller: 2}, { callerId: { $eq: 1 } })
#    console.log(query)
    query._conditions.id.should.be.equal(1)
    query._conditions.caller.should.be.equal(2)
    return

  it 'makes a combined query limited to the required fields', () ->
    query = makeQuery(model, {query: '{"id": 1}'}, {caller: 2}, { callerId: { $eq: 1 } })
    #    console.log(query)
    query._conditions.id.should.be.equal(1)
    query._conditions.caller.should.be.equal(2)
    return

  it 'makes a combined query limited to the required fields and skip, limit, sort', () ->
    query = makeQuery(model, {find: '{"id": 1}', skip: 12, limit: 10,
    sort: '{"id": -1}', select: '{"id": true}'}, {caller: 2}, { callerId: { $eq: 1 } })
#    console.log(query)
    query._conditions.id.should.be.equal(1)
    query._conditions.caller.should.be.equal(2)
    query.options.limit.should.be.equal(10)
    query.options.skip.should.be.equal(12)
    query.options.sort.id.should.be.equal(-1)
    query._fields.id.should.be.true
    return

  it 'makes a combined query limited to the required fields and offset, take, orderby', () ->
    query = makeQuery(model, {find: '{"id": 1}', offset: 12, take: 10, orderby: '{"id": 1}',
    projection: '{"id": true}'}, {caller: 2}, { callerId: { $eq: 1 } })
    #    console.log(query)
    query._conditions.id.should.be.equal(1)
    query._conditions.caller.should.be.equal(2)
    query.options.limit.should.be.equal(10)
    query.options.skip.should.be.equal(12)
    query.options.sort.id.should.be.equal(1)
    query._fields.id.should.be.true
    return

