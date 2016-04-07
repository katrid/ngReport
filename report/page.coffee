'use strict'

base = require './base'
PaperSize = require('./report').PaperSize

class Page extends base.BaseObject
  constructor: (parent) ->
    super(parent)
    @report = parent
    @marginBottom = 0
    @marginLeft = 0
    @marginTop = 0
    @marginRight = 0
    @landscape = false
    @width = PaperSize.A4.x
    @height = PaperSize.A4.y

  _build: (document) ->
    return new PreparedPage(document, @)

  clearCache: ->
    super()
    for child in @children
      child.clearCache()

  render: (document) ->
    page = @_build(document)
    document.addPage(page)
    for child in @children
      child.render(page)
    return page

module.exports = Page

PreparedPage = require('./engine').PreparedPage
