describe 'issues-sprint-1', ->                                                                         # name of this suite of tests (should match the file name)
  page = require('./API/QA-TM_4_0_Design').create(before,after)                                       # required import and get page object
  jade = page.jade_API

  #@timeout(10000)

 
  it 'Issue 332 - When searching for ambiguous characthers ... fail the search gracefully', (done)->
    @timeout 5000
    check_Search_Payload = (payload, next)->
      page.open "/search?text=#{payload}", (html,$)->
        $('form').attr().assert_Is { action: '/search', method: 'GET' }
        next()

    jade.login_As_User ()->
      check_Search_Payload '%00',->
        check_Search_Payload "a'b\"cdef'",->
          check_Search_Payload "a%27b%22c%3Cmarquee%3Edef",->
            check_Search_Payload '!@£$%^**()_+=-{}[]|":;\'\?><,./' ,->
              check_Search_Payload 'aaaa',->
                done()



  it 'Show 404 page', (done)->
    check_404 = (payload, next)->
      page.open payload, (html,$)->
        $('#404-message').html().assert_Contains 'HTTP 404 error - check the URL and refresh '
        next()

    check_404 '/aaaaaa' ,->
      check_404 '/12312341/aaaaaa' ,->
        check_404 '/!!@@£$/123' ,->
          done()

  it 'Show unavailable page on unhandled node error', (done)->
    page.open '/aaaaaa*&%5E(*&*(*%5E&%%5E', (html,$)->
      $('#an-error-occured').html().assert_Is 'An error occured'
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


