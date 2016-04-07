'use strict'

class Runtime
  @components = {}
  @getComponent: (name) -> @components[name]
  @registerComponent: (comp) -> @components[comp.getClassName()] = comp

module.exports = Runtime

report = require './report'
text = require './text'
