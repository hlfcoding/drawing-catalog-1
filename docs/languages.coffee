# # Supported Languages

module.exports = LANGUAGES =
  Markdown:
    nameMatchers: ['.md']
    commentsOnly: true

  CoffeeScript:
    nameMatchers:      ['.pde']
    pygmentsLexer:     'coffee-script'
    highlightJS:       'coffeescript'
    # **CoffeScript's multi-line block-comment styles.**

    # - Variant 1:
    #   (Variant 3 is preferred over this syntax, as soon as the pull-request
    #    mentioned below has been merged into coffee-script's codebase.)
    ###* }
     * Tip: use '-' or '+' for bullet-lists instead of '*' to distinguish
     * bullet-lists visually from this kind of block comments.  The preceding
     * whitespaces in the line-matcher and end-matcher are required. Without
     * them this syntax makes no sense, as it is meant to produce comments
     * like the following in compiled javascript:
     *
     *     /**
     *      * A sample comment, having a preceding whitespace per line. Useful
     *      * to embed `@doctags` in javascript compiled from coffeescript.
     *      * <= COMBINE THESE TWO CHARS => /
     *
     * (The the final comment-mark above has been TWEAKED to not raise an error)
     ###
    # - Variant 2:
    ### }
    Uses the the below defined syntax, without preceding `#` per line. This is
    the syntax for what the definition is actually meant for !
    ###
    # - Variant 3:
    #   (This syntax produces arkward comments in the compiled javascript, if
    #    the pull-request _“[Format block-comments
    #    better](<https://github.com/jashkenas/coffee-script/pull/3132)”_ has
    #    not been applied to coffee-script's codebase …)
    ### }
    # The block-comment line-matcher `'#'` also works on lines not starting
    # with `'#'`, because we add unmatched lines to the comments once we are
    # in a multi-line comment-block and until we left them …
    ###
    #- Variant 4:
    #   (This definition matches the format used by YUIDoc to parse CoffeeScript
    #   comments)
    multiLineComment  : [
      # Syntax definition for variant 1.
      '###*',   ' *',   ' ###',
      # Syntax definition for variant 2 and 3.
      '###' ,   '#' ,   '###',
      # Syntax definition for variant 4
      '###*',   '#',    '###'
    ]
    # This flag indicates if the end-mark of block-comments (the third value in
    # the list of 3-tuples above) must correspond to the initial block-mark (the
    # first value in the list of 3-tuples above).  If this flag is missing it
    # defaults to `true`. If true it allows one to nest block-comments in
    # different syntax-definitions, like in handlebars or html+php.
    strictMultiLineEnd:false
    singleLineComment: ['#']
    ignorePrefix:      '}'
    foldPrefix:        '^'
