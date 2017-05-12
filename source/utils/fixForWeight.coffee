typeIsArray = require('./typeIsArray')
typeIsObject = require('./typeIsObject')

fixForWeight = (response) ->
  result = {}
  for k,v of response
    if typeof v is "number" and k.toLowerCase().indexOf("weight") isnt -1
      result[k] = Math.floor(Math.random() * 14000)
    else if typeIsObject(v)
      result[k] = fixForWeight(v)
    else if typeIsArray(v)
      for i,l in v
        v[i] = fixForWeight(l)
      result[k] = v
    else
      result[k] = v
  return result

module.exports = fixForWeight