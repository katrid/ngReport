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
    @_staticBands = null
    @_dataBands = null

  _build: (document) ->
    return new PreparedPage(document, @)

  clearCache: ->
    super()
    for child in @children
      if child.clearCache
        child.clearCache()
        
  load: (obj) ->
    super(obj)
    
    # detect nested children bands
    childrenBands = []
    for band in @children
      if band._childBand
        if band._printBefore
          childrenBands.push(band)
        else
          oldBand.childrenBands.push(band)
        continue
      else if childrenBands.length
        for child in childrenBands
          child.parentBand = band
          band.childrenBands.push(child)
        childrenBands = []
      oldBand = band

  newPage: (document, node) ->
    if not @_staticBands
      @_staticBands = []
      @_dataBands = []
      for band in @children
        if band._staticBand
          @_staticBands.push(band)
        else if not band._childBand
          @_dataBands.push(band)
    page = @_build(document)
    document.addPage(page)
    @_page = page
    for band in @_staticBands
      band.render(page)
    if node
      # return to data loop
      return page
    else
      # render data bands
      for band in @_dataBands
        if not band._childBand
          band.render(page)
      
  render: (document) ->
    @newPage(document)

module.exports = Page

PreparedPage = require('./engine').PreparedPage
