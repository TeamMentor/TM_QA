QA_TM_Design   = require '../API/QA-TM_4_0_Design'

describe '| flare | pages-anonymous.test |', ->
  page  = QA_TM_Design.create(before, after);

  it '/angular/html/index', (done)->
    page.open '/angular/html/index.html',->
      done()

