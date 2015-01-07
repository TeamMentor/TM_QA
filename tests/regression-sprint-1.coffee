describe 'regression-sprint-1', ->                                                                         # name of this suite of tests (should match the file name)
  page = require('./API/QA-TM_4_0_Design').create(before,after)                                       # required import and get page object
  jade = page.jade_API


  it 'Issue 96 - Main Navigation "Login" link is not opening up the Login page', (done)->                   # name of current test
    jade.page_Home (html,$)->                                                                               # open the index page
      login_Link = link.attribs.href for link in $('#links li a') when $(link).html()=='Login'                # extract the url from the link with 'Login' as text
      login_Link.assert_Is_Not('/deploy/html/getting-started/index.html')                                   # checks that the link is the wrong one
      login_Link.assert_Is    ('/guest/login.html')                                     # checks that the link is not the 'correct' one
      done()

  it 'Issue 99 - Main Navigation "Sign Up" link is asking the user to login', (done)->
    jade.page_Home ->
      page.click 'SIGN UP', ->
        page.chrome.url (url_Via_Link)->
          jade.page_Sign_Up ->
          page.chrome.url (url_Link)->
            page.chrome.url (url_Direct)->
              url_Direct.assert_Is(url_Link)
              done()


  it 'Issue 102 - Password forgot is not sending requests to mapped TM instance', (done)->
    jade.page_Pwd_Forgot ->
      email = 'aaaaaa@securityinnovation.com' #qa-user@teammentor.net'
      page.chrome.eval_Script "document.querySelector('#email').value='#{email}';", =>
        page.chrome.eval_Script "document.querySelector('#btn-get-password').click();", =>
          page.wait_For_Complete  (html,$)->
            $('h3').html().assert_Is("Login")
            $('#loginwall .alert' ).html().assert_Is("We&apos;ve sent you an email with instructions for resetting your password :)")
            done()

  it 'Issue 117 - Getting Started Page is blank', (done)->
    jade.page_Home ->
      page.click 'START YOUR FREE TRIAL TODAY', (html, $)->
        $('h3').html().assert_Is("Sign Up")
        jade.page_Home ->
          page.click 'SEE FOR YOURSELF', (html)->
            $('h3').html().assert_Is("Sign Up")
            done()

  it 'Issue 118 - Clicking on TM logo while logged in should not bring back the main screen', (done)->
    jade.page_Home ->
      jade.login_As_QA (html,$)->

        $($('#title-area a').get(0)).attr().href.assert_Is('/user/main.html')
        done()

  #it 'Issue 119 - /returning-user-login.html is Blank', (done)->
  #  jade.page_Sign_Up_OK (html, $)->                                                       # open sign-up ok page
  #    $('p a').attr('href').assert_Is('/guest/login.html')                                 # confirm link is now ok
  #    page.chrome.eval_Script "document.documentElement.querySelector('p a').click()", ->  # click on link
  #      page.wait_For_Complete (html, $)->                                                 # wait for page to load
  #        $('h3').html().assert_Is("Login")                                                # confirm that we are on the login page
  #        done();

  it 'Issue 123-Terms and conditions link is available', (done)->
    jade.page_Home (html, $) ->
      footerDiv =  $('#footer').html()
      footerDiv.assert_Not_Contains("Terms &amp; Conditions")
      done();

  it 'Issue 124 - Forgot password page is blank', (done)->
    jade.page_Login ->
      page.click 'FORGOT YOUR PASSWORD?', (html,$)->
        $('h3').html().assert_Is("Forgot your password?")
        done();

    it 'Issue 128 - Opening /Graph/{query} page with bad {query} should result in an "no results" page/view', (done)->
    jade.login_As_User ->
      page.open '/graph/aaaaaaa', (html)->
        page.html (html, $)->
          $('#containers a').length.assert_Is(0)
          done()

  it "Issue 129 - 'Need to login page' missing from current 'guest' pages", (done)->
    jade.keys().assert_Contains('page_Login_Required')
    page.open '/guest/login-required.html', (html,$)->
      $('h3').html().assert_Is('Login')
      done()

  it 'Issue 151 - Add asserts for new Login page content ', (done)->
    jade.page_Login (html,$)->
      $('#summary h1').html().assert_Is("Security Risk. Understood.")
      $('#summary h4').html().assert_Is("Instant resources that bridge the gap between developer questions and technical solutions.")
      $('#summary p').html().assert_Is("TEAM Mentor was created by developers for developers using secure coding standards, code snippets and checklists built from 10+ years of targeted security assessments for Fortune 500 organizations.")
      $('#summary h3').html().assert_Is("With TEAM Mentor, you can...")
      $($('.row p').get(2)).html().assert_Is("FIX vulnerabilities quicker than ever before with TEAM Mentor&apos;s seamless integration into a developer&apos;s IDE and daily workflow.")
      $($('.row p').get(3)).html().assert_Is("REDUCE the number of vulnerabilities over time as developers learn about each vulnerability at the time it is identified.")
      $($('.row p').get(4)).html().assert_Is("EXPAND the development team&apos;s knowledge and improve process with access to thousands of specific remediation tactics, including the host organization&apos;s security policies and coding best practices.")
      done()

  it 'Issue 173 - Add TM release version number to a specific location',(done)->
    jade.page_About (html, $)->
      $("#footer h6").html().assert_Contains('TEAM Mentor v')
      done()

  #removed because the fix for https://github.com/TeamMentor/TM_4_0_Design/issues/164 removed the label value used below
  #it 'Issue 192 - When clicking on the TEXT of any filter, the top filter is selected',(done)->
  #  jade.login_As_User ->
  #    page.open '/graph/logging', ->
  #      # this code removes two rows so that only have the right-hand-side nav showing on page
  #      code = "children = document.documentElement.querySelector('.row').children;
  #              children[0].remove();
  #              children[0].remove();"
  #      page.chrome.eval_Script code, ->
  #        page.html (html,$)->
  #          for td in $('td')
  #            input = $(td).find('input')
  #            if (input.length)
  #              value = $(td).text()
  #              label = $(td).find('label')
  #              $(input).attr().id.assert_Is(value)
  #              label.attr().for.assert_Is(value)
  #          done()
#
  it 'Issue 198 - Right-hand-side query selection must have a visual clue and needs to be clickable (to clear filter)',(done)->
    jade.login_As_User ->
      page.open '/graph/Logging', (html, $)->
        linkText = "Centralize Logging"
        if $('#containers a').html() is null                  # return if link is not there
          done()
          return
        page.click linkText, (html, $)->                      # click on link
          $('#containers a').html().log().assert_Is(linkText)
          done()