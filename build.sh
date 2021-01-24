#!/bin/bash
npm run build
cd dist/js/
gzip app*.js
