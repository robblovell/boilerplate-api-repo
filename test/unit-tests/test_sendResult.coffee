chai = require('chai')
expect = chai.expect
should = chai.should()
assert = chai.assert

SendResult = require('../../source/request-helpers/sendResult')

sendResult = new SendResult(false)

describe 'test sendResult new make', () ->

  it 'given error string, constructs 400 reply', (done) ->
    res = {
      status: (code) ->
        return {
          send: (message) ->
            response = JSON.parse(message)
            response.should.be.equal("THING::The error:.")
            done()
        }
    }
    error = "The error:."
    result = null
    message = "THING:"
    sendResult.send(res, error, result, message)

  it 'given error is object with fields?, constructs 400 reply', (done) ->
    res = {
      status: (code) ->
        return {
          send: (message) ->
            response = JSON.parse(message)
            response.should.be.equal("Field error:THING:The error:.")
            done()
        }
    }
    error = {fields: [{code: 300, message:"The error:."}] }
    result = null
    message = "THING:"
    sendResult.send(res, error, result, message)

  it 'given error is object without fields?, constructs 400 reply', (done) ->
    res = {
      status: (code) ->
        return {
          send: (message) ->
            response = JSON.parse(message)
            response.message.should.be.equal("THING:")
            response.error.error[0].code.should.be.equal(300)
            response.error.error[0].message.should.be.equal("The error:.")
            done()
        }
    }
    error = {error: [{code: 300, message:"The error:."}] }
    result = null
    message = "THING:"
    sendResult.send(res, error, result, message)

  it 'given result with records?, constructs 200 reply', (done) ->
    res = {
      status: (code) ->
        return {
          send: (message) ->
            response = JSON.parse(message)
            response.records[0].thing.should.be.equal("thing")
            done()
        }
    }
    error = null
    result = { records: [{thing: "thing"}]}
    message = "THING:"
    sendResult.send(res, error, result, message)

  it 'given result with summary?, constructs 200 reply', (done) ->
    res = {
      status: (code) ->
        return {
          send: (message) ->
            response = JSON.parse(message)
            response.summary[0].thing.should.be.equal("thing")
            done()
        }
    }
    error = null
    result = { summary: [{thing: "thing"}]}
    message = "THING:"
    sendResult.send(res, error, result, message)

  it 'given result with summary? and updateStatistics, constructs 200 reply', (done) ->
    res = {
      status: (code) ->
        return {
          send: (message) ->
            response = JSON.parse(message)
            response.summary[0].thing.should.be.equal("thing")
            done()
        }
    }
    error = null
    result = { summary: [{thing: "thing"}], updateStatistics: {}}
    message = "THING:"
    sendResult.send(res, error, result, message)

  it 'given result with records? or summary?, null message and error constructs 200 reply', (done) ->
    res = {
      status: (code) ->
        return {
          send: (message) ->
            response = JSON.parse(message)
            response.thing1[0].thing2.should.be.equal("thing")
            done()
        }
    }
    error = null
    result = { thing1: [{thing2: "thing"}], updateStatistics: {}}
    message = null
    sendResult.send(res, error, result, message)

  it 'given result with records? or summary?, null error constructs 400 reply', (done) ->
    res = {
      status: (code) ->
        return {
          send: (message) ->
            response = JSON.parse(message)
            response.thing1[0].thing2.should.be.equal("thing")
            done()
        }
    }
    error = null
    result = { thing1: [{thing2: "thing"}], updateStatistics: {}}
    message = "THING:"
    sendResult.send(res, error, result, message)

  it 'given result with records? or summary?, null message and error constructs 200 reply', (done) ->
    res = {
      status: (code) ->
        return {
          send: (message) ->
            response = JSON.parse(message)
            expect(response).to.be.null
            done()
        }
    }
    error = null
    result = null
    message = null
    sendResult.send(res, error, result, message)

  it 'given result with no records? or summary?, null error constructs 400 reply', (done) ->
    res = {
      status: (code) ->
        return {
          send: (message) ->
            response = JSON.parse(message)
            expect(response).to.be.null
            done()
        }
    }
    error = null
    result = null
    message = "THING:"
    sendResult.send(res, error, result, message)
