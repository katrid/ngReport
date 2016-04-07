'use strict'

Runtime = require './runtime'
Report = require('./report').Report
viewer = require('./viewer')

ngReport = angular.module('ngReport', [])

_bootstrap = (el) ->
  if !el
    el = angular.element(Runtime.reportElement)
  angular.bootstrap(el, ['ngReport'])
  el.injector().invoke ($interpolate) -> Runtime.interpolate = $interpolate
  Runtime.scope = el.scope()

loadReport = (el, file) ->
  el = _bootstrap(el)
  rep = new Report(el)
  rep.load(file)
  doc = rep.prepare()
  return doc

showReport = (el, rep, viewerType) ->
  doc = loadReport(el, rep)
  if viewerType is 'pdf'
    v = new viewer.PDFViewer(doc)
  else
    v = new viewer.HtmlViewer(doc, el)
  v.show()

document.loadReport = loadReport
window.showReport = showReport
