should = require('should')
assert = require('assert')
mock = require('mock-require')
handlerMaker = require('./handlers')

module.exports = [
  {
    name: "GET."
    test: (done) ->
      callsNext = 0
      callsDependency = 0
      dependency = {do: () -> callsDependency++; return 42}
      handler = handlerMaker(dependency)
      handler.getBefore(
        {
          params: {id: '1234'},
        }
      ,
        {
        },
        (() -> callsNext++; return) #next
      )
      handler.getAfter(
        {
          params: {id: '1234'},
        }
      ,
        {
          status: (value) ->
            callsDependency.should.be.equal(1)
            callsNext.should.be.equal(0)
            value.should.be.equal(202)
            return {
              send: (value) ->
                value.should.be.equal('{"StatusCode":202,"Success":true,"Contents":{"summary":42}}')
                done()
                return
            }
        },
        (() -> callsNext++; return) #next
      )
  }
  {
    name: "POST: updates with..."
    test: (done) ->
      putContents = {
        param1: 1
        param2: 2
      }
      res = {
        status: (value) ->
          value.should.be.equal(202)
          callsDependency.should.be.equal(1)
          callsNext.should.be.equal(0)
          done()
          
      }
      callsNext = 0
      callsDependency = 0
      dependency = {do: () -> callsDependency++; return 42}
      handler = handlerMaker(dependency)
      
      handler.postBefore(putContents,res,() ->
        putContents.param1.should.be.equal(1)
        callsNext++
        return
      )
      handler.postAfter(putContents,res, () ->
        callsNext++
        callsNext.should.be.equal(2)
        done()
        return
      )
  }
]
