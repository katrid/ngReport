'use strict'

base = require './base'
Runtime = require './runtime'

class Engine
  @canvas = null

  constructor: ->
    @pageCount = 0
    @pageNumber = 0
    @scope = Runtime.scope
    @expCache = {}

  bootstrap: ->
    if !Engine.canvas
      Engine.canvas = 1

  run: (doc) ->
    report = doc.report
    for p in report.pages
      p.render(doc)

    for p in report.pages
      p.clearCache()

    console.log(doc.pages.length)

  compileTemplate: (s) ->
    return Runtime.interpolate(s)

class Document
  constructor: (@report) ->
    @pages = []
    @pageCount = 0
    @engine = new Engine()
    @description = @report.description
    @author = @report.author
    @code = @report.code

  addPage: (page) ->
    @pages.push(page)
    @pageCount = page.pageNumber = @pages.length

  save: ->
    return { }

class PreparedObject
  constructor: (@parent, type) ->
    if type
      @type = type
    @content = null
    @left = 0
    @top = 0
    @width = 0
    @height = 0
    @_x = 0
    @_y = 0

  load: (obj) ->
    for k, v of obj
      this[k] = v

class PreparedPage extends PreparedObject
  constructor: (parent, page) ->
    super(parent)
    @landscape = false
    @children = []
    @document = parent
    @index = 0
    @pageNumber = 0
    if page
      @page = page
      @width = @page.width
      @height = @page.height
    @_y = page.marginTop
    @_x = page.marginLeft
    @calcPrintableArea()

  addObject: (obj) ->
    @children.push(obj)

  calcPrintableArea: () ->
    @_maxHeight = @page.height - @page.marginTop - @page.marginBottom
    @_maxWidth = @page.width - @page.marginLeft - @page.marginRight

  newPage: () ->
    page = new PreparedPage(@parent, @page)
    @document.addPage(page)
    return page

module.exports =
  Engine: Engine
  PreparedObject: PreparedObject
  PreparedPage: PreparedPage
  Document: Document
