require 'fluentnode'
QA_TM_Design = require './../API/QA-TM_4_0_Design'

describe 'jade | page-search',->
  page = QA_TM_Design.create(before,after)                                       # required import and get page object
  jade = page.jade_API

  #html = null
  #$   = null

  it 'mixin: main-app-view', (done)->
    jade.render_Mixin 'user-mixins','main-app-view', {}, ($)->
      $('#recentlyViewedArticles').html().assert_Is_String()
      done()

  it 'mixin: search-bar-input', (done)->
    jade.render_Mixin 'search-mixins','search-bar-input', {}, ($)->
      $('input' ).attr().assert_Is({ type: 'text', placeholder: 'Type keywords here', name: 'text', class: 'form-control' })
      $('button').attr().assert_Is({ type: 'submit', class: 'btn-search-bar' })
      done()

  describe 'Recently Viewed Articles', (done)->

    before (done)->
      jade.login_As_User ->
        done()

    it 'open article and check list', (done)->
      article_Id    = 'aaaaaa'.add_5_Letters()
      article_Title = 'bbbbbb'.add_5_Letters()
      articleUrl = page.tm_Server + "/article/view/#{article_Id}/#{article_Title}"
      page.chrome.open articleUrl, ()->
        jade.page_User_Main (html, $)->
          using $('#recentlyViewedArticles a'),->
            @.length.assert_Bigger_Than(0)
            @.first().attr().assert_Is { href: jade.tm_35_Server + '/' + article_Id
                                       , target: '_blank' }
            @.first().html().assert_Is(article_Title)
            done()

    it 'open article redirector and confirm tm error', (done)->
      articleUrl = page.tm_Server + '/article/view/guid/title'
      page.chrome.open articleUrl, ()->
        300.wait ->
          page.chrome.url (url)->
            url.assert_Contains(['https://','teammentor.net/error'])
            done()

    it 'check elements',(done)->
      jade.render_Mixin 'user-mixins','main-app-view', {}, ($)->
          $('h4').html().assert_Is('Recently Viewed Articles')
          $('a' ).length .assert_Is(0)
          done()

