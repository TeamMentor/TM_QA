describe '| jade | page-graph.test |',->
  page = require('./../API/QA-TM_4_0_Design').create(before,after)                                       # required import and get page object
  jade = page.jade_API

  before (done)->
    jade.login_As_User ->
        done()

  it 'Check filters have size ',(done)->
    jade.page_User_Graph 'Java', (html,$)->
        #if $('#filters a').html() is null      # return if link is not there
        #  done()
        #  return
        first_Link   = $('#filters a').first()
        first_Badge = $('#filters a .badge').first()
        linkText = first_Link.text().remove(first_Badge.text())
        linkText.assert_Is_String()
        for badge in $('#filters .badge')        # check that all badges have a value
          $(badge).html().assert_Is_Not(0)
        done()
        #page.click linkText, (html, $)->             # click on link
          #for badge,index in $('#filters .badge') # check that all badges have a value execpt the first one
          #  if index
          #    $(badge).html().assert_Is(0)
          #  else
          #    $(badge).html().assert_Is_Not(0)
        #  done()

  it 'Check Active Filter',(done)->
    filter_Name = 'Java'
    jade.page_User_Graph filter_Name, (html,$)->
      activeFilter = $('#activeFilter').text()              # on first load there should be no value in the active filter
      activeFilter.assert_Is ''
      first_Filter = $('#filters a').first()
      link = first_Filter.attr().href
      page.open link, (html, $)->
        updatedFilter = $('#activeFilter').text()
        updatedFilter.assert_Contains filter_Name
        first_Filter.text().assert_Contains filter_Name        # now active filter should have the contents of the link clicked
        done()

  it 'Issue 492 Validate right-hand side filter is working',(done)->
    jade.page_User_Graph "Index", (html,$)->
      $('#activeFilter').text().assert_Is('')
      $($('#filters .filter-icon').get(2)).text().assert_Is("C++")
      filterLink = $('#filters .nav a').eq(2).attr().href
      page.open filterLink, (html,$)->
        clearFilterLink = $('#activeFilter a')
        activeLinkText = $('#activeFilter').text().remove(clearFilterLink.text())
        activeLinkText.assert_Is("C++")
        done()