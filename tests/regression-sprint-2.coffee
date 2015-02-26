describe ' | regression-sprint-2 |', ->
  page = require('./API/QA-TM_4_0_Design').create(before,after)
  jade = page.jade_API
  @timeout(7500)

  it 'Issue 461 - Clicking on Terms and Conditions inside a full article view', (done)->
    jade.login_As_User ->
      jade.open_An_Article (html, $)=>
        $("#terms-and-conditions").attr().href.assert_Is '../misc/terms-and-conditions'
        page.click "#terms-and-conditions", (html,$)->
          $('#nav-user-logout').text().assert_Is 'Logout'
          done()