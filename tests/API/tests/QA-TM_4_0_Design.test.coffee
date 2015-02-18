QA_TM_Design = require './../QA-TM_4_0_Design'

describe 'API | QA-TM_4_0_Design',->

  @timeout(5000)

  qaTmDesign = QA_TM_Design.create(before, after)

  it 'constructor',->
    QA_TM_Design.assert_Is_Function()
    using new QA_TM_Design(),->
      @nodeWebKit .assert_Instance_Of(require('nwr'))
      @jade_API   .assert_Instance_Of(require('./../Jade-API'))
      @flare_API  .assert_Instance_Of(require('./../Flare-API'))
      @graphDB_API.assert_Instance_Of(require('./../GraphDB-API'))
      @tm_Server  .assert_Is('http://localhost:1337')
      @open_Delay .assert_Is(0)
      assert_Is_Null(@chrome)

  it 'create', (done)->
    using qaTmDesign,->
      @.assert_Is_Object()
      @.assert_Instance_Of(QA_TM_Design)
      @.chrome.assert_Is_Object()

      @.chrome.url (url)->
        url.assert_Is_String()
        done()

  it 'html', (done)->
    qaTmDesign.html (html)->
      html.assert_Is_String()
      done()

  it 'open (/)', (done)->
    using qaTmDesign,->

      @.open '/', (html)=>
        html.assert_Contains('TEAM Mentor')
        done()
