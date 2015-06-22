QA_TM_Design   = require '../API/QA-TM_4_0_Design'
Flare_API      = require '../API/Flare-API'
async          = require 'async'

describe '| flare | pages-anonymous.test |', ->
  page  = QA_TM_Design.create(before, after);
  flare = page.flare_API;

  before (done)-> flare.clear_Session done                                   # ensure we are anonymous

  @timeout(4000)

  afterEach (done)->
    page.html (html,$)->
      $('title').text().assert_Is('TEAM Mentor 4.0 (Html version)')         # confirm that all pages have the same title
#      check_Top_Right_Navigation_Bar($)
      done()

  it '(open all Flare pages)', (done)->
    @.timeout 15000
    open_Page = (mapping, next)->
      name = mapping.name
      flare["page_#{name}"] (html, $)->
        next()

    async.eachSeries Flare_API.page_Mappings, open_Page, done

  it.only 'check top level navigation',(done)->
    flare.page_Index (html, $)->
      links = for link in $('.links a')
                $(link).attr()
      links.assert_Is [
        { href: 'about', class: 'action' },
        { href: 'features', class: 'action' },
        { href: 'index', class: 'action' },
        { href: 'get-started', class: 'button btn-nav' } ]
      done()

  it 'login',(done)->

  return
  it '/help',(done)->
    page.open '/flare/help/index', (html,$)->
      #console.log html
      done()