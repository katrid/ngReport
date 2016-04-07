'use strict'

class Units
  @mm: 3.779527559055
  @cm: 37.79527559055
  @inch: 96

mm = Units.mm

class PaperSize
  @A3: { x: 297 * mm, y: 420 * mm }
  @A4: { x: 210 * mm, y: 297 * mm }
  @A5: { x: 148 * mm, y: 210 * mm }
  @Custom: null

class Report
  constructor: (@element) ->
    @_curPage = null
    @_report = null
    @units = 'mm'
    @paperSize = 'A4'
    @pageWidth = PaperSize.A4.x
    @pageHeight = PaperSize.A4.y
    @prepared = false
    @document = null
    @loaded = false
    @pages = []

  addPage: (page) ->
    @pages.push(page)

  load: (report) ->
    @_report = report
    for p in report.pages
      page = new Page(@)
      @addPage(page)
      page.load(p)

  prepare: ->
    if !@prepared
      @document = new Document(@)
      @document.engine.run(@document)
      @prepared = true
    return @document

module.exports =
  Report: Report
  PaperSize: PaperSize
  Units: Units

Document = require('./engine').Document
Page = require('./page')
require './base'
require './band'
require './text'
