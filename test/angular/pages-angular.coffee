QA_TM_Design   = require '../API/QA-TM_4_0_Design'

describe '| flare | pages-anonymous.test |', ->
  page  = QA_TM_Design.create(before, after);

  it '/angular/html/index', (done)->
    page.open '/angular/html/index.html',->
      done()

  it '/angular/flare/docs', (done)->
    page.open '/angular/flare/docs',->
      page.html (html, $)->
        #for link in $('a')
          #log $(link).html()
        done()

  it.only '/angular/user/navigate', (done)->
    page.open '/angular/user/navigate',->
      page.html (html, $)->
        done()

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

