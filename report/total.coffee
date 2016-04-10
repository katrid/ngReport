'use strict'

Runtime = require './runtime'

SUM = 'SUM'
COUNT = 'COUNT'
MAX = 'MAX'
MIN = 'MIN'
AVG = 'AVG'

class Total
  @getClassName: -> 'Total'

  constructor: (@report) ->
    @expression = null
    @band = null
    @func = SUM
    @name = null

  band: (band) =>
    return band

  compute: (band, page) ->
    engine = page.document.engine
    v = engine.scope.$eval(@expression) or 0
    curVal = engine.totals[@name]
    if @func is COUNT
      if not curVal?
        curVal = 0
      curVal += 1
    else if @func is SUM
      if not curVal?
        curVal = v
      else
        curVal += v
    else if @func is AVG
      if curVal is null
        curVal = v
      else
        curVal = (@currentValue + v) / 2
    else if @func is MIN
      if curVal is null
        curVal = v
      else
        curVal = Math.min(@currentValue, v)
    else if @func is MAX
      if curVal is null
        curVal = v
      else
        curVal = Math.max(@currentValue, v)
    engine.totals[@name] = curVal
    engine.scope[@name] = curVal
    return curVal

  load: (obj) ->
    @func = obj.func
    @name = obj.name
    @expression = obj.expression
    @band = @report.findObject(obj.band)

  reset: (band, page) ->
    page.document.engine.totals[@name] = null

Runtime.registerComponent(Total)
