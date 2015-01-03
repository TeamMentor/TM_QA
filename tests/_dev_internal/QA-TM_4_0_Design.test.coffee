QA_TM_Design = require '../../API/QA-TM_4_0_Design'

describe.only '_dev_internal | QA-TM_4_0_Design',->

  it 'constructor',->
    QA_TM_Design.assert_Is_Function()
    using new QA_TM_Design(),->
      @nodeWebKit.assert_Instance_Of(require('nwr'))
      @jade_API  .assert_Instance_Of(require('../../API/Jade_API'))
      @flare_API .assert_Instance_Of(require('../../API/Flare_API'))
      log 'hello'