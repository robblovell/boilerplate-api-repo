FormatResponse = require('./FormatResponse')

class SendResult
  constructor: (@legacy = false) ->
    @response = new FormatResponse(@legacy)

  send: (res, error, result, message) ->
    if (error?)
      console.log("Send Result:: #{message}, error: "+JSON.stringify(error,null,2))
      if error.fields?
        res.status(400).send @response.make(error.fields[0].code, false, "Field error:" + message + error.fields[0].message)
      else
        if typeof(error) is 'string'
          res.status(400).send @response.make(400, false, message + ':' + error)
        else
          res.status(400).send @response.make(400, false, { message: message, error: error, result: result})
      return
    if (result?)
#      console.log("Send Result:: #{message}, result: "+JSON.stringify(result,null,2))
      if (result.records? and result.records.length > 0)
        res.status(200).send @response.make(200, true, result)
      else if (result.summary? and result.summary.updateStatistics?)
        res.status(200).send @response.make(200, true, result)
      else if (result.summary?)
        res.status(202).send @response.make(202, true, result)
      else if (result? and Object.keys(result).length > 0)
        res.status(200).send JSON.stringify(result)
      else
        res.status(404).send @response.make(404, true, null)
    else
      res.status(404).send @response.make(404, true, null)
    return

module.exports = SendResult