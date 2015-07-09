TM_API     = require './../TM-API'
QA_TM_Design = require('./../QA-TM_4_0_Design')

describe '| API | tests | TM-API.test',->

  page = QA_TM_Design.create(before,after)
  #tm = page.TM_API
  #tm = new TM_API(page)

  it 'constructor',->
    page = {}
    using new TM_API(page),->
      @.page.assert_Is({})
      @.QA_Users.assert_Is([{ name:'user', pwd: 'a'}])
