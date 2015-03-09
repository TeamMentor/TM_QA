QA_TM_Design = require '../API/QA-TM_4_0_Design'
async        = require('async')

describe '| misc | pages-help |', ->
  page = QA_TM_Design.create(before, after)
  jade = page.jade_API

  help_Pages = []

  it 'check nav link (when user is logged out)', (done)->
    jade.logout ->
      page.open '/help/index.html', (html,$)->
        $('#nav-login').text().assert_Is 'Login'
        $('#nav-help' ).text().assert_Is 'Docs'
        done()

  it 'check nav link (when user is logged in)', (done)->
    @timeout 4000
    jade.login_As_User ->
      page.open '/help/index.html', (html,$)->
        $('#nav-user-logout').text().assert_Is 'Logout'
        $('#nav-user-help'  ).text().assert_Is 'Docs'
        done()

  it 'check right navigation links', (done)->
    page.open '/help/index.html', (html,$)->
      help_Pages = ({href : link.attribs.href, title: $(link).html()} for link in $('#help-nav a'))
      help_Pages.assert_Size_Is(61)
      help_Pages[10].title.assert_Is("Managing Users")  #check a couple to see if they are still the ones we expect
      help_Pages[20].title.assert_Is("Using the Control Panel")
      help_Pages[30].title.assert_Is("Using the Search Function")
      help_Pages[40].title.assert_Is("Edit Article Metadata")
      help_Pages[50].title.assert_Is("How to Evaluate and What to Expect")
      done()

  it 'check that image redirection to github is working', (done)->
    image   = 'tmcfg12.jpg'
    url     = "#{page.tm_Server}/Image/#{image}"
    message = "Moved Temporarily. Redirecting to https://raw.githubusercontent.com/TMContent/Lib_Docs/master/_Images/#{image}"
    url.GET (html)->
        html.assert_Is message
        done()

  it 'open two pages and check that titles match', (done)->
    @.timeout 5000
    open_Help_Page = (help_Page, next)->
      page.open help_Page.href,(html,$)->
        $('#help-docs h1').html().assert_Is $('#help-title').html()
        article_Title = $('#help-docs h1').html()
        article_Title.assert_Is(help_Page.title)                   # confirms title of loaded page matches link title
        $('#help-docs .bg').text().size().assert_Bigger_Than(100)   # confirms there is some text on the page
        next()
    async.eachSeries help_Pages.take(2), open_Help_Page, done

  it 'open "empty page" page (aaaaa-bbb)',(done)->
    jade.page_Help_Page 'aaaaa-bbb', (html, $)->
      $('#help-title'  ).text().assert_Is 'No content for the current page'
      $('#help-content').text().assert_Is ''
      done()

  it 'open "index" page (index.html)',(done)->
    jade.page_Help_Page 'index.html', (html, $)->
      $('#help-index h2').text().assert_Is 'TEAM Mentor Documents'
      $('#help-index p' ).text().assert_Contains 'Welcome to the TEAM Mentor Documentation Website'
      done()
  it 'open "Managing Users" page (00000000-0000-0000-0000-0000001c8add)',(done)->
    jade.page_Help_Page '00000000-0000-0000-0000-0000001c8add', (html, $)->
      $('#help-title'  ).text().assert_Is 'Managing Users'
      $('#help-content').text().assert_Contains 'Administrators can manage TEAM Mentor users via the Tbot.'
      first_Img_Link = $('#help-content img').first().attr().src.assert_Is '/Image/tmcfg12.jpg'
      done()

  it 'open "Support" page (323dae88-b74b-465c-a949-d48c33f4ac85)',(done)->
    jade.page_Help_Page '323dae88-b74b-465c-a949-d48c33f4ac85', (html, $)->
      $('#help-title'  ).text().assert_Is 'Support'
      $('#help-content').text().assert_Is 'To contact Security Innovation TEAM Mentor support please email support@securityinnovation.com or leave your message at 1.978.694.1008 (option 2) and we will get back to you.'
      done()