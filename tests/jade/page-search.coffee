require 'fluentnode'
QA_TM_Design = require './../API/QA-TM_4_0_Design'

describe 'jade | page-graph',->
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

  describe 'Currently Viewed Articles', (done)->

    it 'check elements',(done)->
      using $('#recentlyViewedArticles'),->
        $(@.find('h4')).html().assert_Is('Recently Viewed Articles')
        $(@.find('a')).length .assert_Is(0)
        done()


#before (done)->
#jade.login_As_User ->
#  jade.page_User_Main (_html, _$)->
#    html = _html
#    $   = _$
#    done()
