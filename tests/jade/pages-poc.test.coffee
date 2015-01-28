QA_TM_Design = require './../API/QA-TM_4_0_Design'

# this test suite contains all  all pages that we currently need to support for logged in  users
describe 'jade | pages-users', ->
  page = QA_TM_Design.create(before, after);
  jade = page.jade_API;

  it 'search-two-column', (done)->
    jade.page_User_PoC 'search-two-column?text=Xss', (html, $)=>
      log html
      done()