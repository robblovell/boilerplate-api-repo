chai = require('chai')
expect = chai.expect
should = chai.should()
assert = chai.assert

SendResult = require('../../source/request-helpers/sendResult')
sendResult = new SendResult(true)

describe 'test sendResult legacy make', () ->

  it 'given error string, constructs 400 reply', (done) ->
    res = {
      status: (code) ->
        return {
          send: (message) ->
            response = JSON.parse(message)
            response.StatusCode.should.be.equal(400)
            response.Success.should.be.false
            response.Contents.should.be.equal("THING::The error:.")
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
            response.StatusCode.should.be.equal(300)
            response.Success.should.be.false
            response.Contents.should.be.equal("Field error:THING:The error:.")
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
            message = JSON.parse(message)

            message.StatusCode.should.be.equal(400)
            message.Success.should.be.false
            response = message.Contents

            response.error.error[0].code.should.be.equal(300)
            response.error.error[0].message.should.be.equal("The error:.")
            response.message.should.be.equal('THING:')
            done()
        }
    }
    error = {error: [{code: 300, message:"The error:."}] }
    result = null
    message = "THING:"
    sendResult.send(res, error, result, message)
    return

  it 'given result with records?, constructs 200 reply', (done) ->
    res = {
      status: (code) ->
        return {
          send: (message) ->
            response = JSON.parse(message)
            response.StatusCode.should.be.equal(200)
            response.Success.should.be.true
            response.Contents.records[0].thing.should.be.equal("thing")
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
            response.StatusCode.should.be.equal(202)
            response.Success.should.be.true
            response.Contents.summary[0].thing.should.be.equal("thing")
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
            response.StatusCode.should.be.equal(202)
            response.Success.should.be.true
            response.Contents.summary[0].thing.should.be.equal("thing")
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
            response.StatusCode.should.be.equal(404)
            response.Success.should.be.equal(true)
            expect(response.Contents).to.be.null
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
            response.StatusCode.should.be.equal(404)
            response.Success.should.be.equal(true)
            expect(response.Contents).to.be.null
            done()
        }
    }
    error = null
    result = null
    message = "THING:"
    sendResult.send(res, error, result, message)
