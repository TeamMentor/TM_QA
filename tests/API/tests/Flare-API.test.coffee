Flare_API    = require './../Flare-API'
QA_TM_Design = require('./../QA-TM_4_0_Design')

describe '| API | tests | Flare-API.test',->

  page = QA_TM_Design.create(before,after)
  flare = page.flare_API

  it 'constructor',->
    page = {}
    using new Flare_API(page),->
      @.page.assert_Is({})
      @.QA_Users.assert_Is([{ name:'user', pwd: 'a'}])
