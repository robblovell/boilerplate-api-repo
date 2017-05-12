typeIsArray = require('../../utils/typeIsArray')
faker = require('faker')
Schema = require('mongoose').Schema
class MakeMongoose
  constructor: (@schema) ->
    
  make: (metaSchema=@schema) =>
    map(metaSchema,0)
      
  map = (schema,level=null) =>
    if (level == 0 and not schema.objectType?)
      mongooseSchema = new Schema(map(schema), {strict: false})
    else if schema.objectType?
      if schema.objectType is "schema"
        mongooseSchema = new Schema(map(schema.schema), schema.options)
      else if schema.objectType is "object"
        mongooseSchema = map(schema.schema)
    else
      mongooseSchema = {}
      for key,value of schema
        if value is null
          throw "Field is null"
          # an array
        else if typeIsArray(value)
          mongooseSchema[key] = []
          if typeof value[0] is "object" and !value[0].type and !value[0].objectType?
            mongooseSchema[key].push(new Schema(map(value[0])))
          else
            mongooseSchema[key].push(map(value[0]))
        else if typeof value is "object" and value.type? and
          value.type.name is "Object"
            mongooseSchema[key] = map(value)
        else
          mongooseSchema[key] = value
  
    return mongooseSchema
    
module.exports = MakeMongoose