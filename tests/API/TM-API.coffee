class TM_API

  constructor: (page)->
    @.tm_35_Server = "https://tmdev01-uno.teammentor.net"
    @.page         = page
    @.QA_Users     = [{ name:'user', pwd: 'a'}]

  clear_Session: (callback)->
    @page.chrome.delete_Cookie 'tm-session', 'http://localhost/', callback

  login          : (username, password, callback)=>
    @page_Login =>
      code = "document.querySelector('#username').value='#{username}';
              document.querySelector('#password').value='#{password}';
              document.querySelector('#btn-login').click()"
      @page.chrome.eval_Script code, =>
        @page.wait_For_Complete callback

  login_Without_MaxLength : (username, password, callback)=>
    @page_Login =>                                                                # removeAttribute required attribute to pass test
      script ="document.querySelector('#username').removeAttribute('required');
                 document.querySelector('#password').removeAttribute('required');"
      @page.chrome.eval_Script script

      code = "document.querySelector('#username').value='#{username}';
                              document.querySelector('#password').value='#{password}';
                              document.querySelector('#btn-login').click()"
      @page.chrome.eval_Script code, =>
        @page.wait_For_Complete callback

  login_As_QA   : (callback) =>
    user = @QA_Users.first()
    @login user.name, user.pwd, =>
      @page.html callback


  login_As_User: (callback) =>
    @is_User_Logged_In (value)=>
      if value
        @page.html callback
      else
        @login_As_QA callback

  logout: (callback) =>
    @page_User_Logout callback

  is_User_Logged_In: (callback) =>
    url = @page.tm_Server + '/user/main.html'
    @.session_Cookie (cookie)->
      if (cookie is null)
        callback false
      else
        options = { headers: { 'Cookie':'tm-session='+ cookie.value} }
        url.http_With_Options options, (err, html)->
          callback html and html.contains('Logout')

  open_Article: (article_Id, callback)=>
    @.page_User_Article article_Id, callback

  open_An_Article: (callback)=>
    @.page.graphDB_API.articles_Ids (articles_Ids)=>
      @open_Article articles_Ids.first(), callback

  session_Cookie: (callback) =>
    @page.chrome.cookies (cookies)->
      for cookie in cookies
        if cookie.name is "tm-session"
          callback(cookie)
          return
      callback(null)

  user_Sign_Up: (username, password, email, callback) =>
    log 'here'
    @page_Sign_Up (html, $)=>                                                   #removeAttribute required attribute to pass some tests
      code  ="document.querySelector('#username').removeAttribute('required');
              document.querySelector('#password').removeAttribute('required');

              document.querySelector('#username').value='#{username}';
              document.querySelector('#password').value='#{password}';
              document.querySelector('#confirm-password').value='#{password}';
              document.querySelector('#email').value='#{email}';
              document.querySelector('#btn-sign-up').click()"
      @page.chrome.eval_Script code, =>
        @page.wait_For_Complete (html, $)=>
          callback(html, $)

module.exports = TM_API