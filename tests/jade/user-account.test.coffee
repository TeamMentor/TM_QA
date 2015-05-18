describe '| jade | user-account |', ->
  page = require('../API/QA-TM_4_0_Design').create(before,after)
  jade = page.jade_API

  @timeout 4000

  it 'login_As_QA , session_Cookie', (done)->
    jade.clear_Session  (err, data)->
      jade.login_As_QA ->
        jade.session_Cookie (cookie)->
          cookie.name.assert_Is('tm-session')
          cookie.value.size().assert_Bigger_Than(30)
          done()

  it 'clear_Session , session_Cookie', (done)->
    jade.clear_Session  (err, data)->
      jade.session_Cookie (cookie)->
        assert_Is_Null(cookie)
        done()

  it 'Login fail', (done)->
    jade.login 'aaaa'.add_5_Random_Letters(),'bbbb',  (html, $) ->
      $('.alert #message .alert-text').html().assert_Is('Error: Username does not exist')
      done()

  it 'Login fail (Password do not match)', (done)->
    jade.login 'a','bbbbaaa',  (html, $) ->
      $('.alert #message .alert-text').html().assert_Is('Error: Wrong Password')
      done()

  it 'Login fail (Account is expired)', (done)->
    jade.login 'AccountExpired','bbbbaaa',  (html, $) ->
      $('.alert #message .alert-text').html().assert_Is('Error: Account Expired')
      done()

  it 'Login fail (Account is Disabled)', (done)->
    jade.login 'AccountDisabled','!!Hxzqe394-9',  (html, $) ->
      $('.alert #message .alert-text').html().assert_Is('Error: Account Disabled')
      done()

  it 'Login fail (request limit constraint)', (done)->
    jade.login_Without_MaxLength 'a'.add_Random_Letters(1025),'b',  (html, $) ->
      $('#500-message #an-error-occurred').html().assert_Is('An error occurred')
      done()

  it 'User Sign Up (with weak password)',(done)->
    @timeout(0)
    username = 'tm_qa_'.add_5_Random_Letters()
    password = 'aaaaaaaaa'
    email    = "#{username}@teammentor.net"
    jade.user_Sign_Up username, password, email, ->
      page.chrome.url (url)->
        url.assert_Contains('/user/sign-up')
        page.html (html,$)->
          $('#loginwall h4').html().assert_Is('Sign Up')
          $('.alert #message .alert-text').html().assert_Is('Error: Password must contain a non-letter and a non-number character')
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
          $('.alert #message .alert-text').html().assert_Is('Error: Password must be 8 to 256 character long')
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
          $('.alert #message .alert-text').html().assert_Is('Error: Username already exist')
          done()

  it 'User Sign Up (with existing email address)',(done)->
    @timeout(0)
    username = 'abc'.add_5_Letters();
    password = 'tm!!Fw'.add_5_Random_Letters()
    email    = "dcruz@securityinnovation.com"

    jade.user_Sign_Up username, password, email, ->
      page.chrome.url (url)->
        url.assert_Contains('/user/sign-up')
        page.html (html,$)->
          $('.alert #message .alert-text').html().assert_Is('Error: Email already exist')
          done()

  it 'User Sign Up Fail',(done)->
    @timeout(0)
    assert_User_Sign_Up_Fail = (username, password, email, next)->
      jade.user_Sign_Up username, password, email, ->
        page.chrome.url (url)->
          url.assert_Contains('user/sign-up')
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

  it 'User Sign Up Success',(done)->
    @timeout(0)
    username = 'CxetJ'.add_5_Letters();
    password = 'tm!34!Fw'.add_5_Random_Letters()
    email    = username+"@securityinnovation.com"
    
    jade.user_Sign_Up username, password, email, ->
      page.chrome.url (url)->
        url.assert_Contains('/sign-up-OK.html')
        page.html (html,$)->
          $('.alert #message .alert-text').html().assert_Is('Thanks for signing up to TEAM Mentor. Please login to access our libraries.')
          #Performs login upon Sign up
          jade.login username,password,  (html, $) ->
            $('#popular-Search-Terms h5').html().assert_Is('Popular Search Terms')
            page.chrome.url (url)->
              url.assert_Contains('/user/main.html')
            done()