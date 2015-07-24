QA_TM_Design = require '../API/QA-TM_4_0_Design'

describe '| misc | api |', ->
  page = QA_TM_Design.create(before, after)
  jade = page.jade_API

  @.timeout(5000)

  before (done)->
    jade.login_As_User ->
      done()

  it '/api', (done)->
    page.open '/api', (html)->
      html.assert_Contains 'http://swagger.wordnik.com'
      done()

  it '/api/graph-db/predicates', (done)->
    @.timeout 3500
    page.open '/api/graph-db/predicates', (html, $)->
      expected_Predicates = ["title","tags","technology","guid","alias","summary","is","type","phase","search-data","contains-article","contains-query","id"]
      $('pre').text().assert_Contains expected_Predicates
      done()

  it '/api/user  (check login requirement)', (done)->
    page.open '/api/user/log_search_valid/abc/123', (html, $)->
      html.assert_Contains '{"error":"user login required"}'
      done()

  it '/api (check login requirement)', (done)->
    jade.logout ->
      page.open '/api', (html)->
        html.assert_Contains '{"error":"user login required"}'
        done()