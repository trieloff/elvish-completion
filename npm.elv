# very basic NPM completion
edit:completion:arg-completer[npm] = [@rest]{
  COMP_CWORD = (- (count $rest) 1)
  COMP_LINE = (joins " " [(drop 1 $rest)])
  COMP_POINT = (count (joins " " [(drop 1 $rest)]))
  set-env COMP_CWORD $COMP_CWORD
  set-env COMP_LINE $COMP_LINE
  set-env COMP_POINT $COMP_POINT
  npm completion -- $@rest 2> /dev/null
}