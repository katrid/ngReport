
class HtmlExport
  constructor: (@document) ->
    @_y = 0
    @_x = 0

  toHtml: () ->
    s =  ''
    for page in @document.pages
      s += @renderPage(page)
    return s

  renderObject: (obj) ->
    return obj.target.toHtml(obj)

  renderPage: (page) ->
    s = '<div class="ng-report-print-page" style="'
    s += 'height:' + page.height.toString() + 'px;width:' + page.width.toString() + 'px;'
    s += '">'
    @_y += page.height
    for obj in page.children
      s += @renderObject(obj)
    s += '</div>'
    return s

module.exports = HtmlExport
