module.exports = (dependency) ->
  SendResult = require('../../source/request-helpers/sendResult')
  sendResult = new SendResult(true)
  handlers = {
    getBefore: (req, res, next) ->
      ### use next() or to pass control to resourcejs ###
      # next()
      return
      
    getAfter: (req, res, next) ->
      ### choose either relying on resource js for the reply or not: ###
      result = { summary: dependency.do() }
      error = null
      message = "ok"
      sendResult.send(res, error, result, message)
      return
  
    postBefore: (req, res, next) ->
      dependency.do()
      next()
      return
      
    postAfter: (req, res, next) ->
      next()
      return
  
    putBefore: (req, res, next) ->
      result = { summary: 42 }
      error = null
      message = "ok"
      sendResult.send(res, error, result, message)
      return
    deleteBefore: (req, res, next) ->
      result = { summary: 42 }
      error = null
      message = "ok"
      sendResult.send(res, error, result, message)
      return
    indexBefore: (req, res, next) ->
      result = { summary: 42 }
      error = null
      message = "ok"
      sendResult.send(res, error, result, message)
      return
  }
  return handlers
