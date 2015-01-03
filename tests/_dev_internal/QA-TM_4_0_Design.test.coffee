QA_TM_Design = require '../../API/QA-TM_4_0_Design'

describe.only '_dev_internal | QA-TM_4_0_Design',->

  @timeout(5000)

  "before qaTmDesign".log()
  qaTmDesign = QA_TM_Design.create(before, after)
  "qaTmDesign: #{qaTmDesign}".log()
  "after qaTmDesign".log()

  it 'constructor',->
    QA_TM_Design.assert_Is_Function()
    using new QA_TM_Design(),->
      @nodeWebKit.assert_Instance_Of(require('nwr'))
      @jade_API  .assert_Instance_Of(require('../../API/Jade_API'))
      @flare_API .assert_Instance_Of(require('../../API/Flare_API'))
      @tm_Server .assert_Is('http://localhost:1337')
      @open_Delay.assert_Is(0)
      assert_Is_Null(@chrome)

  it 'create', (done)->
    using qaTmDesign,->
      @.assert_Is_Object()
      @.assert_Instance_Of(QA_TM_Design)
      @.chrome.assert_Is_Object()

      @.chrome.url (url)->
        url.assert_Is_String()
        "Current url is #{url}".log()
        done()

  it 'html', (done)->
    qaTmDesign.html (html)->
      html.assert_Is_String()
      done()

  it 'open (direct)', (done)->
    using qaTmDesign,->
      @tm_Server =''
      google_Url  = 'https://www.google.co.uk'
      @.open google_Url, (html)=>
        html.assert_Contains('Google')
        done()