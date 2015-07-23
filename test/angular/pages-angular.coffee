QA_TM_Design   = require '../API/QA-TM_4_0_Design'

describe '| flare | pages-anonymous.test |', ->
  page  = QA_TM_Design.create(before, after);
  flare = page.flare_API;

  it '/angular/html/index', (done)->
    page.open '/angular/html/index.html',->
      done()

  it '/angular/flare/docs', (done)->
    page.open '/angular/flare/docs',->
      page.html (html, $)->
        #for link in $('a')
          #log $(link).html()
        done()

  it '/angular/user/navigate', (done)->
    page.open '/angular/user/navigate',->
      page.html (html, $)->
        done()

  it '/angular/user/article/{article_Id}/article_Title', (done)->
    page.open '/angular/user/article/00000091ce5a/title',->
      page.html (html, $)->
        done()

  it.only '/angular/guest/login', (done)->
    page.open '/angular/guest/login',->
      300.wait ->
        page.html_Pretty (html, $)->
          log $.html($('login_form'))
          log html
          done()

  it.only '| view | queries' ,(done)->
    page.open '/angular/user/queries', ->
      done()

  it '| component | navigate_queries' ,(done)->
    flare.component 'navigate_queries', ->
      done()

  it 'Flare API - login', (done)->
    username = 'aaa'
    password = 'bbb'
    flare.login username, password, ->
      done()

  it 'Flare API - login as QA', (done)->
    flare.component 'login_form', ->
      done()

  it 'Flare API - pwd_forgot_form', (done)->
    email = "asda@asd.com"
    flare.component 'pwd_forgot_form', ->
      flare.eval_In_Controller  'Pwd_Forgot_Controller', "scope.email = '#{email}';", ->
        flare.eval_In_Controller 'Pwd_Forgot_Controller','scope.get_Password();',->
          done()




  return

  it '/angular/html/pages/index (on live page)', (done)->
    page.open '/angular/html/pages/index.html',->
      page.click("Features")
      page.wait_For_Complete ->
        done()

      return
      log 'before'
      500.wait ->
        log 'after 500'
        page.click("Features")
        500.wait ->
          log 'after 500'
          page.click("About")
          500.wait ->
            log 'after 500'
            page.click("Docs")
            log 'done'
            done()


    return
    page.html (html, $)->
      for link in $('a')
        log $(link).html()

      done()

  it '/angular/html/simple-angular.html', (done)->
    page.open '/angular/html/test/simple-angular.html',->
      #page.field '#test_Field', (data)->
        #log data
        #1000.wait ->
          #code = "console.log angular.element($('input'))[0].value"
          code = "$('input')"
          code = "console.log(angular.element($('a')).scope().$digest())"
          page.chrome.eval_Script code, (result)->
            log '------'
            log result
            done()
      #page.fieldsaaa (fields)->
      #  console.log fields

