'use strict'

base = require './base'
Runtime = require './runtime'

class TextObject extends base.BaseView
  @getClassName: -> 'Text'

  constructor: (parent) ->
    super(parent)
    @allowExpressions = true
    @autoWidth = false
    @canGrow = false
    @highlight = ''
    @highlightStyle = { }
    @format = ''
    @htmlTags = false
    @textAlign = 'Left'
    @verticalAlign = 'Top'
    @lineHeight = 0
    @nullValue = ''
    @text = ''
    @wordWrap = true
    @border =
      top: false
      right: false
      bottom: false
      left: false
      color: '#000'
      width: 1

    @font =
      name: 'Arial'
      size: 10
      bold: false
      italic: false

  load: (obj) ->
    super(obj)
    @text = obj.text

  _build: (page) ->
    obj = super(page)
    if @allowExpressions and @text
      if @_cachedData is undefined
        @_cachedData = page.document.engine.compileTemplate(@text, @)
      obj.content = @_cachedData(page.document.engine.scope)
    else
      obj.content = @text

    # build style
    obj.style = {
      'vertical-align': @verticalAlign.toLowerCase(),
      'text-align': @textAlign.toLowerCase(),
      'font-family': @font.name,
      'font-size': @font.size + 'pt',
    }
    if @lineHeight
      obj.style['line-height'] = @lineHeight.toString() + 'px'

    if @border.top
      obj.style['border-top'] = @border.width.toString() + 'px solid ' + @border.color + ';'
    if @border.right
      obj.style['border-right'] = @border.width.toString() + 'px solid ' + @border.color + ';'
    if @border.bottom
      obj.style['border-bottom'] = @border.width.toString() + 'px solid ' + @border.color + ';'
    if @border.left
      obj.style['border-left'] = @border.width.toString() + 'px solid ' + @border.color + ';'

    return obj

  toHtml: (obj) ->
    s = '<div style="'
    style = 'position:absolute;overflow:hidden;display:inline;'
    style += 'left:' + obj.left.toString() + 'px;'
    style += 'top:' + obj.top.toString() + 'px;'
    if obj.width
      style += 'max-width:' + obj.width.toString() + 'px;'
    if obj.height
      style += 'max-height:' + obj.height.toString() + 'px;'

    if obj.style
      for k, v of obj.style
        style += k + ':' + v.toString() + ';'
    s += style + '">' + obj.content + '</div>'

    return s


Runtime.registerComponent(TextObject)
