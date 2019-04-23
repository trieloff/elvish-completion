# very basic NPM completion
edit:completion:arg-completer[npx] = [@rest]{
  if ?(test -e "node_modules") {
    /bin/ls "node_modules/.bin" 2> /dev/null
  } 
}