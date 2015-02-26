QA_TM_Design = require '../API/QA-TM_4_0_Design'
async        = require('async')

describe '| misc | pages-misc |', ->
  page = QA_TM_Design.create(before, after)
  jade = page.jade_API

  #[QA] Add navbar check for login and anonymous page rendering
  it '/misc/terms-and-conditions ', (done)->
    @timeout 5000
    jade.page_User_Logout ->
      page.open '/misc/terms-and-conditions', (html,$)->
        jade.login_As_User ->
          page.open '/misc/terms-and-conditions', (html,$)->
          done()