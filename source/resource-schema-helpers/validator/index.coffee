typeIsArray = require('../../utils/typeIsArray')
FakeMongoose = require('../fake-mongoose')
_ = require('lodash')
class Validator
  constructor: (@schema) ->
    fakeFactory = new FakeMongoose(@schema, true, true)
    @example = fakeFactory.make()
#    console.log(JSON.stringify(@example,null,2))
    return

  mergeFindings = (intoFindings, fromFindings) ->
    for k,v of fromFindings
      if k != "result"
        intoFindings[k] = _.extend(intoFindings[k], v)
    intoFindings.result = false if fromFindings.result is false
    return intoFindings

  makePath = (path,key) ->
    return key if path is ""
    return path+"-"+key

  validate: (data, example = null, path="") ->
    findings = {
      result: true
      wrongType: {}
      missingFields: {}
      nullFields: {}
      extraFields: {}
      correctFields: {}
      typeMismatch: {}
      valueInvalid: {}
    }
    example = @example if !example?

    if example.type?
      if typeof data != example.type.name.toLowerCase()
        if example.typeNotValidated
          findings.typeMismatch[makePath(path,key)] = "type doesn't match for "+key+
              " value: "+JSON.stringify(value)+" type is object"+
              " but type should be: "+example.type.name
        else
          findings.wrongType[makePath(path,key)] = "type wrong for value:"+data+
              " the type is "+(typeof data)+
              " the type should be: "+example.type.name.toLowerCase()
          findings.result = false
      else
#          console.log("type correct for "+key+" value: "+value)
        key = typeof data
        findings.correctFields[makePath(path,key)] = "type correct for "+key+" value: "+data
        if example.validation? and !example.validation(data)
          (findings.valueInvalid[makePath(path,key)] = "Invalid value: #{key} = "+data)
          findings.result = false
        if example.taxonomy? and example.taxonomy.indexOf(data) is -1
          (findings.valueInvalid[makePath(path,key)] = "Value for #{key} is #{data}, but must be one of the following:"+
            "#{JSON.stringify(example.taxonomy).replace(/\"/g, " ")}")
          findings.result = false
    else
      for key,value of example
        if example.type?
          if data is undefined
#            console.log("Missing Field "+key+" in data: "+JSON.stringify(value))
            findings.missingFields[makePath(path,key)] = "Extra Field "+key+" has value: "+JSON.stringify(value)

        else if (data[key] is undefined)
#          console.log("Missing Field "+key+" in data: "+JSON.stringify(value))
          findings.missingFields[makePath(path,key)] = "Extra Field "+key+" has value: "+JSON.stringify(value)

      for key,value of data
        if !example[key]?
#        console.log("Extra Field "+key+" has value: "+JSON.stringify(value))
          findings.extraFields[makePath(path,key)] = "Extra Field "+key+" has value: "+JSON.stringify(value)
        else if value is null
#        console.log("Field "+key+" is null")
          findings.nullFields[makePath(path,key)] = "Field "+key+" is null"
        else if typeIsArray(value) # an array
          if !typeIsArray(example[key])?
#          console.log("type wrong for "+key+" value: "+value+" type is array"+
#              " but type should be: "+typeof example[key])
            if example[key].typeNotValidated
              findings.typeMismatch[makePath(path,key)] = "type wrong for "+key+" value: "+JSON.stringify(value)+" type is object"+
                  " but type should be: "+example[key].type.name
            else
              findings.wrongType[makePath(path,key)] = "type wrong for "+key+" value: "+JSON.stringify(value)+" type is array"+
                  " but type should be: "+example[key].type.name
              findings.result = false
          else
#          console.log("type correct for "+key+" value: "+JSON.stringify(value)+"  type is array.")
            findings.correctFields[makePath(path,key)] = "type correct for "+key+" value: "+JSON.stringify(value)+ "type is array."
            if example[key].validation? and !example[key].validation(value)
              (findings.valueInvalid[makePath(path,key)] = example[key].message)
              findings.result = false
            if example[key].taxonomy? and example[key].taxonomy.indexOf(value) is -1
              (findings.valueInvalid[makePath(path,key)] = "Value for #{key} is #{value}, but must be"+
                " one of the following: #{JSON.stringify(example[key].taxonomy).replace(/\"/g, " ")}")
              findings.result = false
            for v,i in value
              mergeFindings(findings, @validate(v, example[key][0],  makePath(path,key+"["+i+"]")))
        else if typeof value is "object" and value.constructor.name is "Object"
          if !(typeof example[key] is "object")
#          console.log("type wrong for "+key+" value: "+value+" type is object"+
#              " but type should be: "+typeof example[key])
            if example[key].typeNotValidated
              findings.typeMismatch[makePath(path,key)] = "type wrong for "+key+" value: "+JSON.stringify(value)+" type is object"+
                  " but type should be: "+typeof example[key].type.name
            else
              findings.wrongType[makePath(path,key)] = "type wrong for "+key+" value: "+JSON.stringify(value)+" type is object"+
                  " but type should be: "+typeof example[key].type.name
              findings.result = false
          else
#          console.log("type correct for "+key+" value: "+value+"  type is: "+(typeof value))
            findings.correctFields[makePath(path,key)] = "type correct for "+key+" value: "+JSON.stringify(value)
            if example[key].validation? and !example[key].validation(value)
              (findings.valueInvalid[makePath(path,key)] = example[key].message)
              findings.result = false
            if example[key].taxonomy? and example[key].taxonomy.indexOf(value) is -1
              (findings.valueInvalid[makePath(path,key)] = "Value for #{key} is #{value}, but must be"+
                  " one of the following: #{JSON.stringify(example[key].taxonomy).replace(/\"/g, " ")}")
              findings.result = false
            mergeFindings(findings, @validate(value, example[key], makePath(path,key)))
        else if typeof value is "object"
#        console.log(JSON.stringify(value));
          if (example[key].type? and value.constructor? and value.constructor.name != example[key].type.name)
            if example[key].typeNotValidated
              findings.typeMismatch[makePath(path,key)] = "type wrong for "+key+" value: "+JSON.stringify(value)+" type is object"+
                  " but type should be: "+example[key].type.name
            else
              findings.wrongType[makePath(path,key)] = "type wrong for " + key + " value: " + value + " type is:" +
                  (value.constructor.name) + " but type should be: " + example[key].type.name
              findings.result = false
          else
            findings.correctFields[makePath(path,key)] = "type correct for " + key + " value: " + value;
            if example[key].validation? and !example[key].validation(value)
              (findings.valueInvalid[makePath(path,key)] = example[key].message)
              findings.result = false
            if example[key].taxonomy? and example[key].taxonomy.indexOf(value) is -1
              (findings.valueInvalid[makePath(path,key)] = "Value for #{key} is #{value}, but must be"+
                  " one of the following: #{JSON.stringify(example[key].taxonomy).replace(/\"/g, " ")}")
              findings.result = false
        else
          if typeof value != example[key].type.name.toLowerCase()
#          console.log("type wrong for "+key+" value: "+value+
#              " type is:"+(typeof value)+
#              " but type should be: "+typeof example[key])
            if example[key].typeNotValidated
              findings.typeMismatch[makePath(path,key)] = "type wrong for "+key+" value: "+JSON.stringify(value)+" type is object"+
                  " but type should be: "+example[key].type.name
            else
              findings.wrongType[makePath(path,key)] = "type wrong for "+key+" value: "+value+
                  " type is:"+(typeof value)+
                  " but type should be: "+example[key].type.name.toLowerCase()
              findings.result = false
          else
#          console.log("type correct for "+key+" value: "+value)
            findings.correctFields[makePath(path,key)] = "type correct for "+key+" value: "+value
            if example[key].validation? and !example[key].validation(value)
              (findings.valueInvalid[makePath(path,key)] = example[key].message)
              findings.result = false
            if example[key].taxonomy? and example[key].taxonomy.indexOf(value) is -1
              (findings.valueInvalid[makePath(path,key)] = "Value for #{key} is #{value}, but must be"+
                  " one of the following: #{JSON.stringify(example[key].taxonomy).replace(/\"/g, " ")}")
              findings.result = false
              
    return findings

module.exports = Validator
