'use strict'

class Runtime
  @components = {}
  @getComponent: (name) -> @components[name]
  @registerComponent: (comp) -> @components[comp.getClassName()] = comp

module.exports = Runtime

require './report'
require './group'
require './text'
require './total'
