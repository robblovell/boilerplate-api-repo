typeIsArray = require('./typeIsArray')
typeIsObject = require('./typeIsObject')

convertToUTC = (response) ->
  result = {}
  for k,v of response
    if k.toLowerCase().indexOf("date") >= 0 and v != ""
      try
        result[k] = new Date(v).toISOString()
      catch error
        result[k] = v
    else if typeIsObject(v)
      result[k] = convertToUTC(v)
    else if typeIsArray(v)
      for i,l in v
        v[i] = convertToUTC(l)
      result[k] = v
    else
      result[k] = v
  return result

module.exports = convertToUTC