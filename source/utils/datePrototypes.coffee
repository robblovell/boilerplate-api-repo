
Date.prototype.addHours= (h) ->
  @setHours(@getHours()+h)
  return @

Date.prototype.addDays= (d) ->
  @setHours(@getHours()+Number(d)*24)
  return @

millisecondsPerDay = (1000 * 3600 * 24)
Date.prototype.dayDifference = (date1, date2, doabs=false) ->
  if doabs
    timeDiff = Math.abs(date2.getTime() - date1.getTime())
  else
    timeDiff = date2.getTime() - date1.getTime()

  return Math.ceil(timeDiff / millisecondsPerDay)