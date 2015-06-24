QA_TM_Design = require './../API/QA-TM_4_0_Design'

# this test suite contains all  all pages that we currently need to support for logged in  users
describe '| jade | pages-users', ->
  page = QA_TM_Design.create(before, after)
  jade = page.jade_API

  @timeout 4000

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
        link_attr : $(link).attr(),                                         # with the link attributes
        img_attr  : $(link).find('span').attr()                             # the img attributes
        text      : $(link).text()                                          # and the value (which is the innerText)
      }

    checkValues = (index, link_attr,img_attr, text ) ->                 # create a helper function to check for expected values
      using linksData[index],->
        @.link_attr.assert_Is link_attr
        @.img_attr .assert_Is img_attr  if @.img_attr
        @.text     .assert_Is text

    checkValues(0, {id: 'nav-user-main'    , href: '/user/main.html'                        }, { title: 'Search', class: 'icon-Search' }, 'Search'    )
    checkValues(1, {id: 'nav-user-guidance', href: "/show/"                                 }, { title: 'Index' , class: 'icon-Index'  }, 'Index')
    checkValues(2, {id: 'nav-user-help'    , href: '/help/index.html'                       }, { title: 'Info'  , class: 'icon-Info'   }, 'Docs'    )
    checkValues(3, {id: 'nav-user-logout'  , href: '/user/logout'                           }, { title: 'Logout', class: 'icon-Logout' }, 'Logout'  )
    checkValues(4, {id: 'tm-support-email' , href: 'mailto:support@securityinnovation.com'  }, undefined , 'an email'  )

  before (done)->
    jade.login_As_QA  ->
      done()

  it 'Help', (done)->
    jade.page_Help (html,$)->
      section_Titles = ($(h4).html() for h4 in $('h4'))
      section_Titles.assert_Is([ 'About TEAM Mentor'
                                 'Accessing and Reading Content'
                                 'Installation'
                                 'Administration'
                                 'Editing Content'
                                 'Eclipse for Fortify plugin'
                                 'HP Fortify SCA UI Integration' ])
      done()

  it 'Logout', (done)->
    jade.page_User_Logout (html,$)->
      page.chrome.url (url)->
        url.assert_Contains('/guest/default.html')
        jade.login_As_QA ->
            done()

  it 'Main', (done)->
    jade.page_User_Main (html,$)->
      section_Titles = ($(h4).html() for h4 in $('h5'))
      section_Titles.assert_Is(['Popular Search Terms','Top Articles'])
      done()

  it 'page_User_Graph_All', (done)->
    jade.page_User_Graph_All (html,$)->
      done()

  it 'page_User_Graph (Technology)', (done)->
    @timeout 10000
    jade.page_User_Graph 'Technology', (html,$)->
      all_Articles = $("#articles a").keys().size()
      second_Filter = $($('#filters a')[1]).attr().href  # currently android
      page.open second_Filter, (html, $)->
        $("#articles a").keys().size()
                        .assert_Is_Not(all_Articles)
        done()