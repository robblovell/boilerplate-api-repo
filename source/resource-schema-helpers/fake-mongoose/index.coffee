typeIsArray = require('../../utils/typeIsArray')
faker = require('faker')

class FakeMongoose
  constructor: (@schema, @lengthOne=true, @example=false) ->
  
  make: () ->
    @fake()
    
  fake: () ->
    return map(@schema, 0, @)

  makeValue = (method, _this) ->
    if (_this.example)
      return method
    else
      if method.taxonomy?
        return method.taxonomy[0]
      fakeCall = method.fake.split('.')
      if fakeCall.length == 2
        return faker[fakeCall[0]][fakeCall[1]]()
      else
        return "ERROR IN FAKE SPECIFICATION, need class.function of a faker method"

  makeValueFromType = (type, _this) ->
    if (_this.example)
      switch(type.name)
        when "Id" then return {type: String, required: false, fake: "random.uuid"}
        when "String" then return {type: String, required: false, fake: "lorem.word"}
        when "Number" then return {type: Number, required: false, fake: "random.number"}
        when "Boolean" then return {type: Boolean, required: false, fake: "random.boolean"}
    else
      switch(type.name)
        when "Id" then return faker.random.uuid()
        when "String" then return faker.lorem.word()
        when "Number" then return Math.floor(Math.random * 14000) # faker.random.number()
        when "Boolean" then return faker.random.boolean()

  map = (schema, level=null, _this) ->
    fake = {}
    if !schema?
      throw "No schema"
    if (level is 0 and not schema.objectType?)
      fake = map(schema, null, _this)
    else if schema.objectType?
      fake = map(schema.schema, null, _this)
    else
      for key,value of schema
        if value is null
          throw "Field is null"
        # an array
        else if typeIsArray(value)
          fake[key] = []
          number = if _this.lengthOne then 1 else Math.floor(Math.random() * (3-1) + 1)
          if typeof value[0] is "object" and value[0].type? and value[0].type.name is "Object"
            for i in [0...number]
              fake[key].push(map(value[0].schema, null, _this))
          else if typeof value[0] is "object" and !value[0].type and !value[0].objectType?
            for i in [0...number]
              fake[key].push(map(value[0], null, _this))
          else
            for i in [0...number]
              fake[key].push(makeValue(value[0], _this))
        # an object or a complex field.
        else if typeof value is "object" and value.type? and
          value.type.name is "Object"
            fake[key] = map(value.schema, null, _this)
        else if typeof value is "object"
          if `value.type != undefined`
            # a type.  # complex field.
            fake[key] = makeValue(value, _this)
          else
            # a embedded object.
            fake[key] = map(value, null, _this)
        else if value.name?
          if value.name is "String"
            fake[key] = makeValueFromType(value, _this)
          else if value.name is "Number"
            fake[key] = makeValueFromType(value, _this)
          else if value.name is "Boolean"
            fake[key] = makeValueFromType(value, _this)

    return fake
   
module.exports = FakeMongoose