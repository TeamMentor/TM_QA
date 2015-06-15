require 'fluentnode'
QA_TM_Design = require './../API/QA-TM_4_0_Design'

describe '| jade | page-search |',->
  page = QA_TM_Design.create(before,after)                                       # required import and get page object
  jade = page.jade_API

  #html = null
  #$   = null

  it 'mixin: main-app-view', (done)->
    jade.render_Mixin 'search-mixins','main-app-view', {}, ($)->
      $('#main-app-view').html().assert_Is_String()
      done()

  it 'mixin: search-bar-input', (done)->
    jade.render_Mixin 'search-mixins','search-bar-input', {}, ($)->
      $('input' ).attr().assert_Is {"type":"text","id":"search-input","name":"text","class":"form-control"}
      $('button').attr().assert_Is {"id":"search-button","type":"submit"}
      done()

  describe 'Recently Viewed Articles |', (done)->

    before (done)->
      jade.login_As_User ->
        done()

    it 'open article and check list', (done)->
      article_Id    = '4c396802c1d8' #'aaaaaa'.add_5_Letters()
      article_Title = 'Missing-Function-Level-Access-Control' #.add_5_Letters()
      badge_value   = 12;
      articleUrl = page.tm_Server + "/article/#{article_Id}/#{article_Title}"
      page.chrome.open articleUrl, ()->
        jade.page_User_Main (html, $)->
          using $('#recently-Viewed-Articles a'),->
            @.length.assert_Bigger_Than(0)
            @.first().attr().assert_Is { href: "/article/#{article_Id}/#{article_Title}",id: "article-#{article_Id}" }
            @.first().text().assert_Is article_Title.replace /-/g , ' '
            done()

    #it 'open article redirector and confirm tm error', (done)->
    #  articleUrl = page.tm_Server + '/article/view/guid/title'
    #  page.chrome.open articleUrl, ()->
    #    300.wait ->
    #      page.chrome.url (url)->
    #        url.assert_Contains(['https://','teammentor.net/error'])
    #        done()

    it 'check elements',(done)->
      jade.render_Mixin 'search-mixins','main-app-view', { top_Searches: [], top_Articles: []}, ($)->
          $('h5').text().assert_Is('Popular Search TermsTop Articles')
          $('a' ).length .assert_Is(0)
          done()

    #this test needs to be done more solidly
    it 'perform search', (done)->
      searchText = 'xss'
      search_Input =
        type: 'text',
        name: 'text',
        value: searchText,
        class: 'form-control'

      jade.page_User_Main (html,$)->
        code = "document.querySelector('input').value='#{searchText}';
                document.querySelector('button').click()"
        page.chrome.eval_Script code, =>
          page.wait_For_Complete (html, $)=>
            $('#search-input input').attr().assert_Is search_Input
            done()

