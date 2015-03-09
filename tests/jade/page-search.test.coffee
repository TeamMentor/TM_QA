require 'fluentnode'
QA_TM_Design = require './../API/QA-TM_4_0_Design'

describe '| jade | page-search.test |',->
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

    xit 'open article and check list', (done)->
      article_Id    = 'aaaaaa'.add_5_Letters()
      article_Title = 'bbbbbb'.add_5_Letters()
      badge_value   = 12;
      articleUrl = page.tm_Server + "/article/view/#{article_Id}/#{article_Title}"
      page.chrome.open articleUrl, ()->
        jade.page_User_Main (html, $)->
          using $('#recentlyViewedArticles a'),->
            @.length.assert_Bigger_Than(0)
            @.first().attr().assert_Is { href: jade.tm_35_Server + '/' + article_Id
                                       , target: '_blank' }
            @.first().text().assert_Is(article_Title)
            done()

    xit 'open article redirector and confirm tm error', (done)->
      articleUrl = page.tm_Server + '/article/view/guid/title'
      page.chrome.open articleUrl, ()->
        300.wait ->
          page.chrome.url (url)->
            url.assert_Contains(['https://','teammentor.net/error'])
            done()

    it 'check elements',(done)->
      jade.render_Mixin 'search-mixins','main-app-view', { top_Searches: [], top_Articles: []}, ($)->
          $('h5').text().assert_Is('Popular Search TermsTop Articles')
          $('a' ).length .assert_Is(0)
          done()

    #this test needs to be done more solidly
    xit 'perform search', (done)->
      searchText = 'xss'
      jade.page_User_Main (html,$)->
        code = "document.querySelector('input').value='#{searchText}';
                document.querySelector('button').click()"
        page.chrome.eval_Script code, =>
          page.wait_For_Complete (html, $)=>
            done()

    it "Issue_497 - Url encoding on popular search items", (done)->
      jade.page_User_Main (html,$)->
        #search patterns
        plusSearch      = page.tm_Server + '/search?text=C%2B%2B'
        ampersandSearch = page.tm_Server + '/search?text=%26'
        mainPageSearch  = page.tm_Server + '/user/main.html'
        # searching patterns to populate them in the Popular Search Terms
        page.chrome.open plusSearch, ()->
          page.chrome.open plusSearch, ()->
            page.chrome.open ampersandSearch, ()->
              page.chrome.open ampersandSearch, ()->
                page.chrome.open mainPageSearch, ()->
                  searchItems = ($(link).attr('href') for link in $('#popular-Search-Terms a'))
                  searchItems.assert_Contains("/search?text=C%2B%2B")
                  searchItems.assert_Contains("/search?text=%26")
                  done()

    it "Issue_508 - Dynamic generated links are not URL-encoded", (done)->
      jade.page_User_Main (html,$)->
        #search patterns
        ampersandSearch = page.tm_Server + '/search?text=%26' # URL encoding for &
        plusSearch      = page.tm_Server + '/search?text=%2B' # URL encoding for +
        # searching patterns to populate them in the Popular Search Terms
        page.chrome.open ampersandSearch, ()->
          page.chrome.html (html,$)->
            filters = ($(link).attr('href') for link in $('#filters a'))
            filters.assert_Contains("/search?text=%26&filter=/query-b97ee4fd5453")
            filters.assert_Contains("/search?text=%26&filter=/query-b97ee4fd5453")
            page.chrome.open plusSearch, ()->
              page.chrome.html (html,$)->
                filters = ($(link).attr('href') for link in $('#filters a'))
                filters.assert_Contains("/search?text=%2B&filter=/query-b209501ac4b8")
                filters.assert_Contains("/search?text=%2B&filter=/query-b97ee4fd5453")
                done()