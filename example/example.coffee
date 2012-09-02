# init the plugin (which loads the resource file on a callback)
{ Template, jqueryify } = window.dynamictemplate
dtBrowserL10n = require '../dt-browser-l10n.js'
url = require 'url'

lang = url.parse(document.URL, true)?.query?.lang
lang ?= navigator.language
console.log "lang:", lang

# the module exports a function which loads the resources
# then calls a callback with the actual plugin function as
# the second parameter of the callback function.
dtBrowserL10n 'data.properties', lang, (err, plugin) ->
  # here the resource is loaded, and the plugin function is in plugin.
  return if err

  tpl = new Template schema:'html5', ->
    @$div ->
      @$h1 'data-dt-l10n-id': 'title', "(The adventures of two small furry creatures)"
      @$p 'data-dt-l10n-id': 'story', "(The quick brown fox jumped over the lazy dog.)"
    @$div ->
      @$p ->
        @$span "Set Language: "
        @$a 'href': './example.html?lang=en', 'en'
        @$span ", "
        @$a 'href': './example.html?lang=de', 'de'

  tpl = jqueryify {use: plugin}, tpl

  tpl.ready ->
    console.log "ready"
    for el in tpl.jquery
      $('body').append el

