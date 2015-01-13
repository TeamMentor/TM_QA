describe 'user-account', ->
  page = require('./API/QA-TM_4_0_Design').create(before,after)
  jade = page.jade_API

  it 'login_As_QA , session_Cookie', (done)->
    jade.clear_Session  (err, data)->
      jade.login_As_QA ->
        jade.session_Cookie (cookie)->
          cookie.name.assert_Is('tm-session')
          cookie.value.size().assert_Bigger_Than(30)
          #console.log cookie
          done()

  it 'clear_Session , session_Cookie', (done)->
    jade.clear_Session  (err, data)->
      jade.session_Cookie (cookie)->
        assert_Is_Null(cookie)
        done()

  it 'Login fail', (done)->
    jade.login 'aaaa'.add_5_Random_Letters(),'bbbb',  (html, $) ->
      $('.alert').html().assert_Is('Error: Username does not exist')
      done()

  it 'Login fail (Password do not match)', (done)->
    jade.login 'a','bbbb',  (html, $) ->
      $('.alert').html().assert_Is('Error: Wrong Password')
      done()

  it 'User Sign Up (with weak password)',(done)->
    @timeout(0)
    username = 'tm_qa_'.add_5_Random_Letters()
    password = 'tmweakpassword'
    email    = "#{username}@teammentor.net"
    jade.user_Sign_Up username, password, email, ->
      page.chrome.url (url)->
        url.assert_Contains('/user/sign-up')
        page.html (html,$)->
          $('h3').html().assert_Is('Sign Up')
          $('.alert').html().assert_Is('Error: Password must contain a non-letter and a non-number character')
          done()

  it 'User Sign Up (with short password)',(done)->
    @timeout(0)
    username = 'tm_qa_'.add_5_Random_Letters()
    password = 'tmw'
    email    = "#{username}@teammentor.net"
    jade.user_Sign_Up username, password, email, ->
      page.chrome.url (url)->
        url.assert_Contains('/user/sign-up')
        page.html (html,$)->
          $('h3').html().assert_Is('Sign Up')
          $('.alert').html().assert_Is('Error: Password must be 8 to 256 character long')
          done()

  it 'User Sign Up (with existing user)',(done)->
    @timeout(0)
    username = 'a'
    password = 'tm!!Fw'.add_5_Random_Letters()
    email    = "#{username}@teammentor.net"
    jade.user_Sign_Up username, password, email, ->
      page.chrome.url (url)->
        url.assert_Contains('/user/sign-up')
        page.html (html,$)->
          $('h3').html().assert_Is('Sign Up')
          $('.alert').html().assert_Is('Error: Username already exist')
          done()

  it 'User Sign Up Fail',(done)->
    @timeout(0)
    assert_User_Sign_Up_Fail = (username, password, email, next)->
      jade.user_Sign_Up username, password, email, ->
        page.chrome.url (url)->
          url.assert_Contains('/user/sign-up')
          next()

    randomUser  = 'abc_'.add_5_Random_Letters();
    randomEmail = "#{randomUser}@teammentor.net"

    assert_User_Sign_Up_Fail randomUser, 'existing email', 'dcruz@securityinnovation.com', ->
      assert_User_Sign_Up_Fail 'dinis', 'existing user', randomEmail, ->
        assert_User_Sign_Up_Fail '', 'no username', randomEmail, ->
          assert_User_Sign_Up_Fail randomUser, 'no email', '', ->
            assert_User_Sign_Up_Fail randomUser + 'no pwd', '', randomEmail, ->
              #note that at the moment there is no check for weak passwords
              done()

  it 'User Sign Up Fail (different passwords)',(done)->

    randomUser  = 'abc_'.add_5_Random_Letters();
    randomEmail = "#{randomUser}@teammentor.net"
    pwd1 = "aaaa"
    pwd2 = "bbbb"
    jade.page_Sign_Up (html, $)=>
      code = "document.querySelector('#username').value='#{randomUser}';
                                  document.querySelector('#password').value='#{pwd1}';
                                  document.querySelector('#confirm-password').value='#{pwd2}';
                                  document.querySelector('#email').value='#{randomEmail}';
                                  document.querySelector('#btn-sign-up').click()"
      page.chrome.eval_Script code, =>
        page.wait_For_Complete (html, $)=>
          page.chrome.url (url)->
            url.assert_Contains('/user/sign-up')
          done()

  #add issue that new users can be created with weak pwds (from jade)