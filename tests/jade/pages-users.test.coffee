QA_TM_Design = require './../API/QA-TM_4_0_Design'

# this test suite contains all  all pages that we currently need to support for logged in  users
describe '| jade | pages-users.test', ->
  page = QA_TM_Design.create(before, after);
  jade = page.jade_API;

  afterEach (done)->
    page.html (html,$)->
      $('title').text().assert_Is('TEAM Mentor 4.0 (Html version)')         # confirm that all pages have the same title
      check_Top_Right_Navigation_Bar($)
      done()

  check_Top_Right_Navigation_Bar = ($)->                                    # confirm that all anonymous pages have the same top level menu
    navBarLinks = $('#links li a')                                          # get all top right links using a css selector
    navBarLinks.length.assert_Is(4)                                         # there should be 5 links

    linksData = for link in navBarLinks                                     # for each link in navBarLinks
      {                                                                     # create a new object
        link_attr : $(link).attr(),                                         # with the link attributes
        img_attr  : $($(link).find('i')).attr()                             # the img attributes
        text: $(link).text()                                               # and the value (which is the innerText)
      }

    checkValues = (index, link_attr,img_attr, text ) ->                 # create a helper function to check for expected values
      using linksData[index],->
        @.link_attr.assert_Is link_attr
        @.img_attr .assert_Is img_attr
        @.text     .assert_Is text

    checkValues(0, {"href":'/user/main.html'              }, { class: 'fi-magnifying-glass'}, 'Search'    )
    checkValues(1, {"href":"/#{jade.url_Prefix}/Guidance" }, { class: 'fi-map'             }, 'Navigate')
    checkValues(2, {"href":'/help/index.html'             }, { class: 'fi-info'            }, 'Help'    )
    checkValues(3, {"href":'/user/logout'                 }, { class: 'fi-power'           }, 'Logout'  )

  before (done)->
    jade.login_As_QA  ->
      done()

  it 'Help', (done)->
    jade.page_User_Help (html,$)->
      section_Titles = ($(h4).html() for h4 in $('h4'))
      section_Titles.assert_Is([ 'About TEAM Mentor',
                                 'Installation',
                                 'Administration',
                                 'UI Elements',
                                 'Reading Content',
                                 'Editing Content',
                                 'Eclipse for Fortify plugin',
                                 'HP Fortify SCA UI Integration',
                                 'Visual Studio Plugin',
                                 'TEAM Mentor in action:',
                                 'TEAM Mentor Related Sites' ])
      done()

  it 'Logout', (done)->
    jade.page_User_Logout (html,$)->
      page.chrome.url (url)->
        url.assert_Contains('/guest/default.html')
        jade.login_As_QA ->
            done()

  it 'Main', (done)->
    jade.page_User_Main (html,$)->
      section_Titles = ($(h4).html() for h4 in $('h4'))
      section_Titles.assert_Is(['Popular Search Terms','Top Articles'])
      done()

  it 'page_User_Graph_All', (done)->
    jade.page_User_Graph_All (html,$)->
      done()

  xit 'page_User_Graph (Technology)', (done)->
    @timeout 10000
    jade.page_User_Graph 'Technology', (html,$)->
      all_Articles = $("#articles a").keys().size()
      first_Filter = $('#filters a').first().attr().href
      page.open first_Filter, (html, $)->
        $("#articles a").keys().size()
                        .assert_Is_Not(all_Articles)
        done()