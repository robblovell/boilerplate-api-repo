typeIsArray = require('../../utils/typeIsArray')

class FakeMongoose
  constructor: (@linkTemplates) ->

  makeLink: (object, value, template) ->
    
  links: (data) ->
    for key,value of data
      if value is null
        throw "Field is null"
      else if typeIsArray(value) # an array
        for v in value
          @links(v)
      else if typeof value is "object" and value.type? and value.type.name is "Object"
        @links(value)
      else
        if key in linkTemplates
          makelink(data, value, linkTemplates[key])
