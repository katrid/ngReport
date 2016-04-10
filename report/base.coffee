'use strict'

Runtime = require './runtime'

class BaseObject
  constructor: (parent) ->
    @name = null
    @parent = parent
    @children = []
    @exportable = true
    @printable = true
    @height = 0
    @report = parent.report

  addObject: (obj) ->
    @children.push(obj)
    obj.parent = @

  clearCache: ->
    if @_cachedData
      delete @_cachedData

  _build: (page) ->
    PreparedObject = require('./engine').PreparedObject
    obj = new PreparedObject(page, @constructor.getClassName())
    obj.target = @
    obj.height = @height
    return obj

  load: (obj) ->
    for k, v of obj
      if k != 'children'
        @[k] = v
    if obj.children
      for child in obj.children
        cls = Runtime.getComponent(child.type)
        obj = new cls(@)
        obj.load(child)
        @addObject(obj)

  render: (page) ->
    @_obj = @_build(page)
    for child in @children
      child.render(page)
    # calc canBreak property
    #if @canBreak and obj
    #  page.addObject(obj)
    return @_obj

  toHtml: (obj) ->
    return ''

class BaseView extends BaseObject
  constructor: (parent) ->
    super(parent)
    @left = 0
    @top = 0
    @width = 0
    @shiftMode = 'Always'  # None, Always and Overlapped
    @visible = true

  _build: (page) ->
    obj = super(page)
    obj.width = @width
    # calc offset
    obj.top = @top + page._y
    obj.bottom = @top + @height
    obj.left = @left + page._x
    return obj

  load: (obj) ->
    super(obj)

module.exports =
  BaseObject: BaseObject
  BaseView: BaseView
