'use strict'

base = require './base'
Runtime = require './runtime'

class Band extends base.BaseObject
  @getClassName: -> 'Band'

  constructor: (parent) ->
    super(parent)
    @canShrink = false
    @canBreak = false
    @_fixed = false
    @_staticBand = false
    @_childBand = false

  render: (page, caller) ->
    if @name
      page.document.engine.scope[@name] = this
    h = 0
    for child in @children
      obj = child.render(page)
      if @_fixed
        page.addObject(child._obj)
      h = Math.max(h, obj.bottom)

    h = Math.max(h, @height)
    # if h > @height and @canGrow ???? TODO

    if @_fixed is false
      # check page bound
      ny = 0
      if (h + page._y) > page._maxHeight
        oy = page._y
        # add a new prepared page
        page = page.newPage(page.document, caller)
        ny = page._y

      # add objects to page
      for child in @children
        if ny > 0
          child._obj.top -= oy
          child._obj.top += ny
        page.addObject(child._obj)
        delete child._obj
    page._y += h
    return page


class DataBand extends Band
  @getClassName: -> 'DataBand'

  constructor: (parent) ->
    super(parent)
    @maxRows = 0
    @rowCount = 1
    @data = null
    @_y = 0

  _calcHeight: () ->
    @height

  render: (page) ->
    # data loop
    if @data
      rows = @data
    else if @rowCount
      rows = [1..@rowCount]

    # TODO check child bands

    c = 0
    for row in rows
      c++
      page.document.engine.scope['row'] = c
      page = super(page, true)
      if @maxRows and c >= @maxRows
        break

class ReportTitle extends Band
  @getClassName: -> 'ReportTitle'

  constructor: (parent) ->
    super(parent)
    @_fixed = true
    @_staticBand = true
    
class PageHeader extends Band
  @getClassName -> 'PageHeader'
    
  constructor: (parent) ->
    super(parent)
    @_fixed = true
    @_staticBand = true

class PageFooter extends Band
  @getClassName: -> 'PageFooter'

  constructor: (parent) ->
    super(parent)
    @_fixed = true
    @_staticBand = true

  render: (page) ->
    oy = page._y
    page._y = page._maxHeight - @height
    super(page)
    page._maxHeight -= @height
    page._y = oy

Runtime.registerComponent(Band)
Runtime.registerComponent(DataBand)
Runtime.registerComponent(ReportTitle)
Runtime.registerComponent(PageHeader)
Runtime.registerComponent(PageFooter)

module.exports =
  Band: Band
  DataBand: DataBand
