QA_TM_Design = require './../API/QA-TM_4_0_Design'

# this test suite contains all  all pages that we currently need to support for anonymous users (i.e. non logged in users)
describe.only '| jade | pages-anonymous |', ->
  page = QA_TM_Design.create(before, after);
  jade = page.jade_API;

  #afterEach (done)->
  #  testTitle = @.currentTest.fullTitle()
  #  page.screenshot testTitle, done

  before (done)->
    jade.page_User_Logout ->                                                # ensure we are anonymous
      jade.clear_Session ->
        done()

  @timeout(4000)

  afterEach (done)->
    page.html (html,$)->
      $('title').text().assert_Is('TEAM Mentor 4.0 (Html version)')         # confirm that all pages have the same title
      check_Top_Right_Navigation_Bar($)
      done()

  check_Top_Right_Navigation_Bar = ($)->                                    # confirm that all anonymous pages have the same top level menu
    navBarLinks = $('#links li a')                                          # get all top right links using a css selector
    navBarLinks.length.assert_Is(5)                                         # there should be 5 links
    linksData = for link in navBarLinks                                     # for each link in navBarLinks
      {                                                                     # create a new object
        href : link.attribs.href,                                           # with the href
        value: $(link).text()                                               # and the value (which is the innerHTML)
      }                                                                     # in coffee-script the last value is the default return value

    checkValues = (index, expected_Href,expected_Value ) ->                 # create a helper function to check for expected values
      linksData[index].href.assert_Is(expected_Href)
      linksData[index].value.assert_Is(expected_Value)

    checkValues(0,'/guest/about.html'    , 'About'   )   # check expected values of 6 links
    checkValues(1,'/guest/features.html' , 'Features')
    checkValues(2,'/help/index.html'     , 'Docs'    )
    checkValues(3,'/guest/sign-up.html'  , 'Sign Up' )
    checkValues(4,'/guest/login.html'    , 'Login'   )

  check_Generic_Footer = ($)->
    $('#call-to-action h2'      ).html()             .assert_Is('Security Risk. Understood.'           )
    $('#call-to-action a'       ).get(0).attribs.href.assert_Is('/guest/sign-up.html'                  ) # BUG this is a broken link!
    $('#call-to-action button'  ).text()             .assert_Is('See for yourself'                     )
    $('#footer .label'          ).text()             .assert_Is('TEAM Mentor 4.0')

  extract_Style_Data = (styleCss)->
    items = {}
    for item in styleCss.split(';')
      if (item)
        items[item.split(':').first().trim()] =item.split(':').second().trim()
    return items

  #check_Generic_Footer_Css = (html, baseUrl, next)->
  #  inliner = require('inline-css')
  #  cheerio = require('cheerio')
  #  inlinerOptions = { url: baseUrl }
  #  inliner html, inlinerOptions, (err, cssHtml)->
  #    throw (err) if err
  #    $css = cheerio.load(cssHtml)
  #    footer_Attr = $css('#footer #si-logo').attr()
  #    footer_Attr.assert_Is { id: 'si-logo', style: 'background: url(\'../assets/logos/logos.png\') no-repeat; background-position: 0px -43px; height: 30px; margin: 0 auto; margin-bottom: 20px; width: 160px;' }
  #    items = extract_Style_Data(footer_Attr.style)
  #    items['background'].assert_Is "url('../assets/logos/logos.png') no-repeat"
  #    next()

  it.only '/',(done)->
    jade.page_Home (html,$)->
      $('#usp h2').html().assert_Is('Instant resources that bridge the gap between developer questions and technical solutions')

      $('#usp a'          ).get(0).attribs.href .assert_Is('/guest/sign-up.html')
      $('#usp button span').text()              .assert_Is('Start your free trial today')

      #$('#reasons h2'  ).html()              .assert_Is('With TEAM Mentor, you can...')

      $($('#reasons td p').get(0)).html()    .assert_Is('Fix vulnerabilities quicker than ever before with TEAM Mentor&apos;s seamless integration into a developer&apos;s IDE and daily workflow.')
      $($('#reasons td p').get(1)).html()    .assert_Is('Reduce the number of vulnerabilities over time as developers learn about each vulnerability at the time it is identified.')
      $($('#reasons td p').get(2)).html()    .assert_Is('Expand the development team&apos;s knowledge and improve process with access to thousands of specific remediation tactics, including the host organization&apos;s security policies and coding best practices.')

      $('#clients h3').html()                .assert_Is('Our clients love us (and we think you will too!)')
      clientImages = $('#client-logo')
      clientImages.length.assert_Is(5)
      clientImages[0].attribs.class.assert_Is("elsevier")
      clientImages[1].attribs.class.assert_Is("fedex")
      clientImages[2].attribs.class.assert_Is("mass-mutual")
      clientImages[3].attribs.class.assert_Is("microsoft")
      clientImages[4].attribs.class.assert_Is("ubs")

      check_Generic_Footer($)
      done()
      #check_Generic_Footer_Css($.html(), 'http://localhost:1337/', done)

  it 'About',(done)->
    jade.page_About (html,$)->
      $(  '#about h3'   ).html()        .assert_Is('An interactive Application Security library with thousands of code samples and professional guidance when you need it')
      $(  '#about-us h4').html()        .assert_Is('TEAM Mentor was created by developers for developers using secure coding standards, code snippets and checklists built from 10+ years of targeted security assessments for Fortune 500 organizations.')
      $($('#about-us p' ).get(0)).html().assert_Is('It contains over 4,000 articles with dynamic content across multiple development platforms including .NET, Java, C/C++, PHP, Android and iOS. TEAM Mentor is the In-Practice companion to our <a href="https://www.securityinnovation.com/training/application-security/computer-based/">TEAM Professor eLearning courses</a>, extending developers&#x2019; knowledge in combination with training.')
      $($('#about-us p' ).get(1)).html().assert_Is('TEAM Mentor integrates with static analysis tools, such as Checkmarx and Fortify&#x2122;, helping teams make more sense of scan results and make critical decisions to fix software vulnerabilities.')

      check_Generic_Footer($);
      done()

  it  'Features',(done)->
    jade.page_Features (html,$)->
      $(  '#features h2'       ).html()        .assert_Is('TEAM Mentor provides intelligence to fix vulnerabilities and comply')
      $($('#features p').get(0)).html()        .assert_Is('Delivers compliance-specific secure coding guidance for PCI-DSS, OWASP Top 10, CWE and other popular frameworks.')
      $($('#features p').get(1)).html()        .assert_Is('Integrates with multiple static analysis tools and developer environments (IDE&#x2019;s) to map prescriptive coding guidance to scan results to fix vulnerabilities.')
      $($('#features p').get(2)).html()        .assert_Is('Stores and cross-references your security policies with out-of-the-box secure coding checklists and examples.')
      $($('#features p').get(3)).html()        .assert_Is('Provides guidance to assist developers in reducing security vulnerabilities in software applications.')

      check_Generic_Footer($)
      done()


  it 'Help',(done)->
    jade.page_Help (html,$)->
      titles = ($(h4).text() for h4 in $('#help-nav h4'))
      titles.assert_Is ["About TEAM Mentor", "Installation", "Administration", "UI Elements",
                        "Reading Content","Editing Content","Eclipse for Fortify plugin",
                        "HP Fortify SCA UI Integration","Visual Studio Plugin"]

      $(  '#help-index h2').html().assert_Is('TEAM Mentor Documents')
      $($('#help-index p' ).get(0)).html().assert_Is('Welcome to the TEAM Mentor Documentation Website where you will find detailed information on how to install TEAM Mentor, how it works and how to customize it.')
      $($('#help-index h4').get(0)).html().assert_Is('TEAM Mentor in action:')
      #todo: add check for links
      $($('#help-index p' ).get(1)).html().assert_Is('Other places to get information about TeamMentor:')
      $($('#help-index h4').get(1)).html().assert_Is('TEAM Mentor Related Sites')
      #todo: add check for links

      done()

  it 'Login', (done)->
    jade.page_Login (html,$)->
      $('#loginwall h4').html().assert_Is('Login')
      $.html('#username').assert_Contains('name="username"')
      $.html('#password').assert_Contains('name="password"')
      $('#btn-login').html().assert_Is('Login')
      $('#link-forgot-pwd').html().assert_Is('Forgot your password?')
      $('#btn-login'     ).attr('type').assert_Is('submit')
      $('#link-forgot-pwd').attr('href').assert_Is('/guest/pwd-forgot.html')
      done()

  it 'Login Fail', (done)->
    jade.page_Login_Fail (html, $)->
      $('#loginwall h4').html().assert_Is('Login')
      done()

  it "Login Required", (done)->
    jade.page_Login_Required (html,$)->
      page.chrome.url (url)->
        $('#loginwall .alert').html('You need to login to see that page :)')
        $('#loginwall h4').html().assert_Is('Login')
        done()

  it 'Password Forgot', (done)->
    jade.page_Pwd_Forgot (html, $)->
      $('#loginwall h4').html().assert_Is('Retrieve your password')
      $('.form-group label').html('Email Address')
      $('#email').attr().assert_Is { type:"email", id:"email", name:"email",placeholder:"Email Address", value:"", maxlength:"256" }
      $('#forgot-password').attr('action').assert_Is('/user/pwd_reset')
      $('#btn-get-password').html().assert_Is('Get Password')
      done()

  it 'Password Sent', (done)->
    jade.page_Pwd_Sent (html,$)->
      $('#loginwall h4').html().assert_Is('Login')
      $('#loginwall .alert #message .alert-icon').attr().assert_Is { class: 'alert-icon' }
      $('#loginwall .alert #message .alert-text').html().assert_Is("If you entered a valid address, then a password reset link has been sent to your email address.")
      done()

  it 'Sign Up', (done) ->
    jade.page_Sign_Up (html,$)->
      $('#loginwall h4').html().assert_Is('Sign Up')

      $('form'                       ).attr().assert_Is({ id: 'sign-up-form', role: 'form' , method:'POST', action: '/user/sign-up' })
      $('label[for=username]'        ).html().assert_Is('Username')
      $('label[for=password]'        ).html().assert_Is('Password')
      $('label[for=confirm-password]').html().assert_Is('Confirm Password')
      $('label[for=email]'           ).html().assert_Is('Email Address')

      $('input[id=username]'         ).attr().assert_Is({ id: 'username'        , name: 'username'        , type: 'text'    , placeholder: 'Username'     , value:'', required: '', maxlength: "256"})
      $('input[id=password]'         ).attr().assert_Is({ id: 'password'        , name: 'password'        , type: 'password', placeholder: 'Password'     , value:'', required: '', maxlength: "256"})
      $('input[id=confirm-password]' ).attr().assert_Is({ id: 'confirm-password', name: 'confirm-password', type: 'password', placeholder: 'Password'     , value:'', maxlength: "256"})
      $('input[id=email]'            ).attr().assert_Is({ id: 'email'           , name: 'email'           , type: 'email'   , placeholder: 'Email Address', value:'', maxlength: "256"})
      $('button#btn-sign-up'         ).html().assert_Is('Sign Up')
      $('button#btn-sign-up'         ).attr().assert_Is({class: 'full-width', id:'btn-sign-up', type:'submit'})
      done()

  it 'Sign Up Fail', (done) ->
    jade.page_Sign_Up_Fail (html,$)->
      $('#loginwall h4').html().assert_Is('Sign Up')
      done()

  it  'Sign Up OK', (done) ->
    jade.page_Sign_Up_OK (html,$)->
      $('#loginwall .alert #message .alert-icon').attr().assert_Is { class: 'alert-icon' }
      $('#loginwall .alert #message .alert-text').html().assert_Is('Thanks for signing up to TEAM Mentor. Please login to access our libraries.')
      done()

  it 'Terms and Conditions', (done)->
    jade.page_TermsAndCond (html,$)->
      $('h3').html().assert_Is('Terms &amp; Conditions')
      done()

  it '403 page', (done)->
    expected_Message = ['Unauthorized',
                        'It\'s a HTTP 403 error - you need to Login to access this page.',
                        'If this continues, please contact your TEAM Mentor Support Team.']
    jade.page_403 (html,$)->
      $('#403-message').text().assert_Contains expected_Message
      done()

  it '404 page', (done)->
    expected_Message = ['An error occurred',
                        'It\'s a HTTP 404 error - check the URL and refresh the browser.',
                        'If this continues, please contact your TEAM Mentor Support Team.']
    jade.page_404 (html,$)->
      $('#404-message').text().assert_Contains expected_Message
      done()

  it '500 page', (done)->
    expected_Message = ['An error occurred',
                        'If this continues, please contact your TEAM Mentor Support Team.']
    jade.page_500 (html,$)->
      $('#500-message').text().assert_Contains expected_Message
      done()


  it 'show 404 page on page not found', (done)->
    check_404 = (payload, next)->
      page.open payload, (html,$)->
        $('#404-message').html().assert_Contains 'HTTP 404 error - check the URL and refresh '
        next()

    check_404 '/aaaaaa' ,->
      check_404 '/12312341/aaaaaa' ,->
        check_404 '/!!@@£$/123' ,->
          done()



  it 'Show error message on unhandled node error', (done)->
    page.open '/aaaaaa*&%5E(*&*(*%5E&%%5E', (html,$)->
      $('#an-error-occurred').html().assert_Is 'An error occurred'
      done()



  #not stable (page load event not firing)
  #it '/aaaaaa (bad page',(done)->
  #  bad_Page = '/aaaaaa/asd'
  #  page.open '/aaaaaa', (html,$)->
  #      $('title').text().assert_Is('')
  #      $('body').html().assert_Is('Cannot GET /aaaaaa\n')
  #      done()
