'use strict'

class Runtime
  @components = {}
  @getComponent: (name) -> @components[name]
  @registerComponent: (comp) -> @components[comp.getClassName()] = comp
  @registerFormat: (format) -> @formats[format.getClassName()] = format

module.exports = Runtime

require './report'
require './group'
require './text'
require './total'
