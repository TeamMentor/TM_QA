return
require 'fluentnode'
QA_TM_Design = require './../API/QA-TM_4_0_Design'

describe.only '| jade | page-article |',->
  page = QA_TM_Design.create(before,after)                                       # required import and get page object
  jade = page.jade_API

  #html = null
  #$   = null

  it 'article', (done)->
    page.open '/article/article-0026811631be',(html,$)->

      done()
