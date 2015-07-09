inliner = require('inline-css')
cheerio = require('cheerio')

describe '| regression-css |', ->                                                                          # name of this suite of tests (should match the file name)
  page = require('./../API/QA-TM_4_0_Design').create(before,after)                                             # required import and get page object
  jade = page.jade_API
  @timeout(7500)

  it 'Issue 218 - Small alignment issue with Search button', (done)->
    jade.login_As_User ->
      jade.page_User_Main (html, $)->
        baseUrl = page.tm_Server
        inlinerOptions = { url: baseUrl }
        inliner html, inlinerOptions, (err, cssHtml)->
          throw (err) if err
          $css = cheerio.load(cssHtml)
          attributes = $css('.input-group').attr()
          attributes.assert_Is {"class":"input-group","style":"background: #fafafa; border: 1px solid #dbdbdb; border-radius: 3px; display: table; height: 3em; margin: 10px 0 0 0; width: 98.5%;"}

          done()

  # removing test below since footer img is not done with css anymore
  # leaving it here since it is a good example of testing css

  #it 'Issue 456 - Refactor css inliner with Juice replacement', (done)->
  #  baseUrl = page.tm_Server
  #  inlinerOptions = { url: baseUrl }
  #  extract_Style_Data = (styleCss)->
  #    items = {}
  #    for item in styleCss.split(';')
  #      if (item)
  #        items[item.split(':').first().trim()] =item.split(':').second().trim()
  #    return items
  #  jade.page_User_Logout ->
  #    jade.page_Home (html, $)->
  #      inliner html, inlinerOptions, (err, cssHtml)->
  #        throw (err) if err
  #        $css = cheerio.load(cssHtml)
  #        footer_Attr = $css('#footer #si-logo').attr()
  #        footer_Attr.assert_Is { id: 'si-logo', style: 'background: url(\'../assets/logos/logos.png\') no-repeat; background-position: 0px -43px; height: 30px; margin: 0 auto; margin-bottom: 20px; width: 160px;' }
  #        items = extract_Style_Data(footer_Attr.style)
  #        items['background'].assert_Is "url('../assets/logos/logos.png') no-repeat"
  #        done()

  it 'Issue 500 - TM Logo missing from search results page', (done)->
    searchText = 'xss'
    jade.login_As_User ()->
      page.open '/user/main.html', (html,$)->
        $('input').attr().assert_Is {"type":"text","id":"search-input","name":"text","class":"form-control"}
        code = "document.querySelector('input').value='#{searchText}';
                  document.querySelector('button').click()"
        page.eval code, ->
          page.wait_For_Complete (html, $)->
            page.chrome.url (url)->
              url.assert_Contains '/search?text='+searchText
              $('input').attr('value').assert_Is searchText
              inliner html, { url: url }, (err, css)->
                throw (err) if err
                $ = cheerio.load(css)
                $('#team-mentor-navigation #tm-logo').attr().assert_Is { id: 'tm-logo', style: 'background: url(\'../assets/logos/logos.png\') no-repeat; background-position: top center; height: 40px; margin: 0 auto; margin-bottom: 10px;' }
                done()