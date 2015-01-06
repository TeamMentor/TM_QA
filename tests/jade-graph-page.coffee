describe 'jade-graph-page',->
  page = require('./API/QA-TM_4_0_Design').create(before,after)                                       # required import and get page object
  jade = page.jade_API

  describe 'right-hand-side',->

    before (done)->
      jade.login_As_User ->
        page.open '/graph/Logging', ->
          done()

    it 'Click on first query ',(done)->
      page.html (html, $)->
          linkText = "Centralize Logging"
          if $('#containers a').html() is null      # return if link is not there
            done()
            return
          for badge in $('#containers .badge')        # check that all badges have a value
            $(badge).html().assert_Is_Not(0)
          page.click linkText, (html, $)->             # click on link
            for badge,index in $('#containers .badge') # check that all badges have a value execpt the first one
              if index
                $(badge).html().assert_Is(0)
              else
                $(badge).html().assert_Is_Not(0)
            done()
