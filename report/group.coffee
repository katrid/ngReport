'use strict'

ChildBand = require('./band').ChildBand

class GroupHeader extends ChildBand
  @getClassName: -> 'GroupHeader'

  constructor: (parent) ->
    super(parent)
    @_linkedFooter = null
    @_printBefore = true

  parentNotification: (band, page) ->
    engine = page.document.engine
    v = engine.scope.$eval(@expression)
    if @_curData isnt v
      page = @render(page)
      @_curData = v
    return page

class GroupFooter extends ChildBand
  @getClassName: -> 'GroupFooter'

  parentNotification: (band, page) ->

Runtime = require './runtime'
Runtime.registerComponent(GroupHeader)
Runtime.registerComponent(GroupFooter)
