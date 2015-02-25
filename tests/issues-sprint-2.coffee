describe '| issues-sprint-1 |', ->                                                                         # name of this suite of tests (should match the file name)
  page  = require('./API/QA-TM_4_0_Design').create(before,after)                                       # required import and get page object
  jade  = page.jade_API
  graph = page.graphDB_API

  #@timeout(10000)

  it 'Issue 461 - Clicking on Terms and Conditions inside a full article view', (done)->
    jade.open_An_Article (html, $)=>
      $("#terms-and-conditions").attr().href.assert_Is '../guest/terms-and-conditions.html'
      page.click "#terms-and-conditions", (html,$)->
          $('#nav-login').text().assert_Is 'Login'
          done()

  #done


  #it 'Issue 96 - Take Screenshot of affected pages', (done)->                                              # name of current test
  # @timeout(4000)
  # page.window_Position 1000,50,800,400, ->                                                                # change window size to make it more 'screenshot friendly'
  #   page.open '/', (html,$)->                                                                             # open the index page
  #     page.screenshot 'Issue 96 1. Home Page', ->                                                         # take screenshot
  #       login_Link = link.attribs.href for Fink in $('.nav li a') when $(link).html()=='Login'            # extract 'Login' link
  #       page.open login_Link, ->                                                                          # follow link
  #         page.screenshot 'Issue 96 2. UI after clicking on link', ->                                     # take screenshot
  #           done()                                                                                        # finish test

