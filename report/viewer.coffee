'use strict'

class HtmlViewer
  constructor: (@document, @element) ->
    @pages = @document.pages
    @pageIndex = -1

  clearView: ->
    @container.html('')

  show: ->
    s = @renderViewer()
    $(@element).html(s)
    @container = $('#ng-report-preview-container')
    viewer = @
    $('#btn-next').click(() -> viewer.next())
    $('#btn-prev').click(() -> viewer.prev())
    $('#btn-last').click(() -> viewer.last())
    @setPage(0)

  setPage: (idx) ->
    @pageIndex = idx
    @page = @pages[idx]
    @renderPage()

  first: ->
    @setPage(0)

  last: ->
    @setPage(@pages.length-1)

  next: ->
    if (@pageIndex+1) < @pages.length
      @setPage(++@pageIndex)

  prev: ->
    if @pageIndex-1 < @pages.length
      @setPage(--@pageIndex)

  renderViewer: ->
    return '<div class="ng-report-preview-toolbar"><button id="btn-prev"><< Prev</button><button id="btn-next">Next ></button><button id="btn-last">Last >></button></div><div class="ng-report-preview-report"><div id="ng-report-preview-container"></div></div>'

  renderObject: (obj) ->
    return obj.target.toHtml(obj)

  renderPage: ->
    s = '<div class="ng-report-preview-page" style="'
    s += 'height:' + @page.height.toString() + 'px;width:' + @page.width.toString() + 'px;'
    s += '">'
    for obj in @page.children
      s += @renderObject(obj)
    s += '</div>'
    @container.html(s)
    return s

class PDFViewer
  constructor: (@element) ->

  show: ->
    return

module.exports =
  HtmlViewer: HtmlViewer
  PDFViewer: PDFViewer
