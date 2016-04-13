// Generated by CoffeeScript 1.10.0
(function() {
  'use strict';
  var Document, Page, PaperSize, Report, Runtime, Units, mm;

  Runtime = require('./runtime');

  Units = (function() {
    function Units() {}

    Units.mm = 3.779527559055;

    Units.cm = 37.79527559055;

    Units.inch = 96;

    return Units;

  })();

  mm = Units.mm;

  PaperSize = (function() {
    function PaperSize() {}

    PaperSize.A3 = {
      x: 297 * mm,
      y: 420 * mm
    };

    PaperSize.A4 = {
      x: 210 * mm,
      y: 297 * mm
    };

    PaperSize.A5 = {
      x: 148 * mm,
      y: 210 * mm
    };

    PaperSize.Custom = null;

    return PaperSize;

  })();

  Report = (function() {
    function Report(element) {
      this.element = element;
      this._curPage = null;
      this._report = null;
      this.units = 'mm';
      this.paperSize = 'A4';
      this.pageWidth = PaperSize.A4.x;
      this.pageHeight = PaperSize.A4.y;
      this.prepared = false;
      this.document = null;
      this.loaded = false;
      this.pages = [];
      this.totals = [];
    }

    Report.prototype.addPage = function(page) {
      return this.pages.push(page);
    };

    Report.prototype.findObject = function(name) {
      var i, len, obj, ref, s;
      ref = this.pages;
      for (i = 0, len = ref.length; i < len; i++) {
        obj = ref[i];
        if (obj.name === name) {
          return obj;
        }
        s = obj.findObject(name);
        if (s) {
          return s;
        }
      }
    };

    Report.prototype.load = function(report) {
      var Total, i, j, len, len1, p, page, ref, ref1, results, t, total;
      this._report = report;
      ref = report.pages;
      for (i = 0, len = ref.length; i < len; i++) {
        p = ref[i];
        page = new Page(this);
        this.addPage(page);
        page.load(p);
      }
      if (report.totals) {
        Total = Runtime.getComponent('Total');
        ref1 = report.totals;
        results = [];
        for (j = 0, len1 = ref1.length; j < len1; j++) {
          total = ref1[j];
          t = new Total(this);
          t.load(total);
          results.push(this.totals.push(t));
        }
        return results;
      }
    };

    Report.prototype.prepare = function() {
      if (!this.prepared) {
        this.document = new Document(this);
        this.document.engine.run(this.document);
        this.prepared = true;
      }
      return this.document;
    };

    Report.prototype.print = function(format) {
      var HtmlExport, html, shtml, wnd;
      if (format == null) {
        format = 'html';
      }
      if (format === 'html') {
        HtmlExport = require('./html');
        html = new HtmlExport(this.prepare());
        wnd = window.open('', 'ngReportPrintWnd');
        shtml = html.toHtml();
        wnd.document.write('<html><head><link href="css/print.css" rel="stylesheet" type="text/css"></head><body><div style="display: table">' + shtml + '</div><script>window.print()</script></body></html>');
        return wnd.print();
      }
    };

    return Report;

  })();

  module.exports = {
    Report: Report,
    PaperSize: PaperSize,
    Units: Units
  };

  Document = require('./engine').Document;

  Page = require('./page');

  require('./group');

  require('./base');

  require('./band');

  require('./text');

}).call(this);

//# sourceMappingURL=report.js.map
