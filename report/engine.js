// Generated by CoffeeScript 1.10.0
(function() {
  'use strict';
  var Document, Engine, PreparedObject, PreparedPage, Runtime, base,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  base = require('./base');

  Runtime = require('./runtime');

  Engine = (function() {
    Engine.canvas = null;

    function Engine() {
      this.pageCount = 0;
      this.pageNumber = 0;
      this.scope = Runtime.scope;
      this.expCache = {};
      this.totals = {};
    }

    Engine.prototype.bootstrap = function() {
      if (!Engine.canvas) {
        return Engine.canvas = 1;
      }
    };

    Engine.prototype.run = function(doc) {
      var i, j, len, len1, p, ref, ref1, report;
      report = doc.report;
      ref = report.pages;
      for (i = 0, len = ref.length; i < len; i++) {
        p = ref[i];
        p.render(doc);
      }
      ref1 = report.pages;
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        p = ref1[j];
        p.clearCache();
      }
      return console.log('Page count:', doc.pages.length);
    };

    Engine.prototype.compileTemplate = function(s) {
      return Runtime.interpolate(s);
    };

    return Engine;

  })();

  Document = (function() {
    function Document(report1) {
      this.report = report1;
      this.pages = [];
      this.pageCount = 0;
      this.engine = new Engine();
      this.description = this.report.description;
      this.author = this.report.author;
      this.code = this.report.code;
    }

    Document.prototype.addPage = function(page) {
      this.pages.push(page);
      return this.pageCount = page.pageNumber = this.pages.length;
    };

    Document.prototype.save = function() {
      return {};
    };

    return Document;

  })();

  PreparedObject = (function() {
    function PreparedObject(parent1, type) {
      this.parent = parent1;
      if (type) {
        this.type = type;
      }
      this.content = null;
      this.left = 0;
      this.top = 0;
      this.width = 0;
      this.height = 0;
      this._x = 0;
      this._y = 0;
    }

    PreparedObject.prototype.load = function(obj) {
      var k, results, v;
      results = [];
      for (k in obj) {
        v = obj[k];
        results.push(this[k] = v);
      }
      return results;
    };

    return PreparedObject;

  })();

  PreparedPage = (function(superClass) {
    extend(PreparedPage, superClass);

    function PreparedPage(parent, page) {
      PreparedPage.__super__.constructor.call(this, parent);
      this.landscape = false;
      this.children = [];
      this.document = parent;
      this.index = 0;
      this.pageNumber = 0;
      if (page) {
        this.page = page;
        this.width = this.page.width;
        this.height = this.page.height;
      }
      this._y = page.marginTop;
      this._x = page.marginLeft;
      this.calcPrintableArea();
    }

    PreparedPage.prototype.addObject = function(obj) {
      return this.children.push(obj);
    };

    PreparedPage.prototype.calcPrintableArea = function() {
      this._maxHeight = this.page.height - this.page.marginTop - this.page.marginBottom;
      return this._maxWidth = this.page.width - this.page.marginLeft - this.page.marginRight;
    };

    PreparedPage.prototype.newPage = function(document, caller) {
      return this.page.newPage(document, caller);
    };

    return PreparedPage;

  })(PreparedObject);

  module.exports = {
    Engine: Engine,
    PreparedObject: PreparedObject,
    PreparedPage: PreparedPage,
    Document: Document
  };

}).call(this);

//# sourceMappingURL=engine.js.map
