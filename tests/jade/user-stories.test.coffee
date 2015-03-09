QA_TM_Design = require '../API/QA-TM_4_0_Design'

describe '| jade | user-stories.test', ->
  page = QA_TM_Design.create(before, after)
  jade = page.jade_API

  @timeout 4000

  beforeEach ()->
    page.open_Delay = 0

  it 'User should navigate site and find login link', (done)->
    jade.clear_Session ->
      page.open '/', ->
        page.click 'ABOUT', ->
          page.click 'DOCS', ->
            page.click 'LOGIN', ->
              page.click 'LOGIN',->
                done()