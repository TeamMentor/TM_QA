require 'fluentnode'
QA_TM_Design = require './../API/QA-TM_4_0_Design'

describe 'jade | page-graph',->
  page = QA_TM_Design.create(before,after)                                       # required import and get page object
  jade = page.jade_API

  html = null
  $   = null

  before (done)->
    jade.login_As_User ->
      jade.page_User_Main (_html, _$)->
        html = _html
        $   = _$
        done()

  it 'check page elements', ->
    $('#recentlyViewedArticles').html().assert_Is_String()

  describe 'Currently Viewed Articles', (done)->


    it 'check elements',(done)->
      using $('#recentlyViewedArticles'),->
        $(@.find('h4')).html().assert_Is('Recently Viewed Articles')
        $(@.find('a')).length .assert_Is(0)
        done()