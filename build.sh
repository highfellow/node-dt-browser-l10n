#!/bin/bash

coffee -c src/dt-dom-l10n.coffee
mv src/dt-dom-l10n.js .
node_modules/.bin/browserify example/example.coffee -o example/example.js
