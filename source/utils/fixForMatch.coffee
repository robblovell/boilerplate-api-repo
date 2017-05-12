typeIsArray = require('./typeIsArray')
typeIsObject = require('./typeIsObject')
fixForDeepEqual = (response) ->
  result = {}
  for k,v of response
    if typeof v is "number" and
      (k.toLowerCase().indexOf("total") isnt -1 or
    k.toLowerCase().indexOf("quote") isnt -1 or
    k.toLowerCase().indexOf("estimate") isnt -1 or
    k.toLowerCase().indexOf("discount") isnt -1 )
      result[k] = 0.0
    else if k.toLowerCase().indexOf("date") isnt -1 or
    k.toLowerCase().indexOf("id") isnt -1 or
    k.toLowerCase().indexOf("leadtime") isnt -1 or
    k.toLowerCase().indexOf("transittime") isnt -1 or
    k.toLowerCase().indexOf("carriername") isnt -1

      result[k] = "force matched"
    else if typeIsObject(v)
      result[k] = fixForDeepEqual(v)
    else if typeIsArray(v)
      for i,l in v
        v[i] = fixForDeepEqual(l)
      result[k] = v
    else
      result[k] = v
  return result

module.exports = fixForDeepEqual