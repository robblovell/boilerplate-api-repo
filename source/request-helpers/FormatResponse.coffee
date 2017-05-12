combyne = require 'combyne'
class FormatResponse
  constructor: (@legacy = false) ->
    ###
        {
        "Content":JSON,
        "Success":Boolean
        "StatusCode":Integer
        "Code": Integer
        }
    ###
    @template = {StatusCode: "String", Success: "Boolean", Contents: "String"}

  make: (code, success, response, stringify = true) ->
    if @legacy
      @template.Contents = response
      @template.Success = success
      @template.StatusCode = code

      return if stringify then JSON.stringify(@template) else return @template
      return JSON.stringify(@template)
    else
      return if stringify then JSON.stringify(response) else return response

module.exports = FormatResponse