'use strict'

base = require './base'
Runtime = require './runtime'

class Band extends base.BaseObject
  @getClassName: -> 'Band'

  constructor: (parent) ->
    super(parent)
    @canBreak = false

  render: (page) ->
    console.log('rendering...')


class DataBand extends Band
  @getClassName: -> 'DataBand'

  constructor: (parent) ->
    super(parent)
    @maxRows = 0
    @rowCount = 1
    @data = null

  _calcHeight: () ->
    @height

  render: (page) ->
    # data loop
    if @data
      rows = @data
    else if @rowCount
      rows = [1..@rowCount]
    c = 0
    for row in rows
      c++
      if @name
        page.document.engine.scope[@name] = this
      page.document.engine.scope['row'] = c
      for child in @children
        child.render(page)

      # check page bound
      h = @_calcHeight()
      if (h + page._y) > page._maxHeight
        # add a new prepared page
        page = page.newPage(page)
      
      # add objects to new page
      for child in @children
          page.addObject(child._obj)
          delete child._obj
      page._y += @_calcHeight()

class FooterBand extends Band
  @getClassName: -> 'FooterBand'

Runtime.registerComponent(Band)
Runtime.registerComponent(DataBand)

module.exports =
  Band: Band
  DataBand: DataBand
