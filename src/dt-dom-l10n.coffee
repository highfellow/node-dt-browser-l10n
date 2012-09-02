L10n = require 'l10n'
L10n_Browser = require 'l10n-browser'

# Events to alter.
EVENTS = ['text', 'raw']

# make the real plugin function.
maker = (resource, lang, callback) ->
  # internal functions.
  l10nLoaded = ->
    callback && callback false, (that) ->
      # The actual plugin function.
      # 'this' and 'that' both point to the adapter.

      # the new event listeners.
      newListeners = {
        text: (el, text) ->
          # do the translation.
          l10nId = el?.attrs?['data-dt-l10n-id']
          if l10nId?
            # get the translated string. TODO - make this work with arguments somehow.
            text = l10n.get l10nId, {}, text
          that.ontext && that.ontext el, text
          
        raw: (el, html) ->
          # TODO - find a neat way to handle raw html.
          that.onraw && that.onraw el, html
      }

      # Replace the old event listeners for 'text' and 'raw' with the new ones.
      for event in EVENTS
        oldListener = that["on#{event}"]
        that.template.removeListener event, oldListener if oldListener?
        that.template.on event, newListeners[event].bind(that)

  l10nFail = ->
    console.error "Failed to load localisation resource file: #{resource}"
    callback && callback true # flag an error.

  lang ?= navigator.language
  # init the L10n module with the browser adapter.
  l10n = new L10n(new L10n_Browser)
  # Set the resource loading.
  if resource?
    l10n.loadResource resource, lang, l10nLoaded, l10nFail

# export the maker function
module.exports = maker
