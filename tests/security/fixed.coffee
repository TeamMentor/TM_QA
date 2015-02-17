describe 'security | fixed', ->
  page = require('./../API/QA-TM_4_0_Design').create(before,after)
  jade = page.jade_API

  it 'Issue 88 - navigation page should not be accessible without a login', (done)->
    check_Login_Request = (next)->
      page.html (html,$)->
        $('#heading p').html().assert_Is('Please log in to access TEAM Mentor.')
        0.wait ->
          next()

    jade.clear_Session ->
      jade.page_User_Main -> check_Login_Request ->
        jade.page_User_Graph 'CORS', -> check_Login_Request ->
          done()

  it 'Issue 100 - Login page should not have hardcoded username', (done)->
    hardcoded_UserName = 'user'
    jade.page_Login ->
      page.field '#username', (attributes) ->
        attributes.id   .assert_Is 'username'
        attributes.name .assert_Is 'username'
        attributes.value.assert_Is ''
        done()