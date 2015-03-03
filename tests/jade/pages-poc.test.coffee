QA_TM_Design = require './../API/QA-TM_4_0_Design'

describe 'jade | pages-poc', ->
  page = QA_TM_Design.create(before, after);
  jade = page.jade_API;

  before (done)->
    jade.login_As_User  ->
      done()
  it '/poc', (done)->
    jade.page_User_PoC '', (html, $)=>
       done()

  it 'topArticles', (done)->
    jade.page_User_PoC 'top-articles', (html, $)=>
       done()
