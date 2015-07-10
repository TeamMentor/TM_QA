QA_TM_Design   = require '../API/QA-TM_4_0_Design'

describe '| flare | pages-anonymous.test |', ->
  page  = QA_TM_Design.create(before, after);

  it '/angular/html/index', (done)->
    page.open '/angular/html/index.html',->
      done()

  it '/angular/html/pages/index', (done)->
    page.open '/angular/html/pages/index.html',->
      page.html (html, $)->
        for link in $('a')
          log $(link).html()
        done()

  it.only '/angular/html/pages/index (on live page)', (done)->

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

