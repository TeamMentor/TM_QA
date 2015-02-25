Jade_API     = require './../Jade-API'
QA_TM_Design = require('./../QA-TM_4_0_Design')

describe '| API | tests | Jade-API.test',->
  page = QA_TM_Design.create(before,after)
  jade = page.jade_API

  it 'constructor',->
    page = {}
    using new Jade_API(page),->
      @.page.assert_Is({})
      @.QA_Users.assert_Is([{ name:'user', pwd: 'a'}])

  it 'clear_Session', (done)->
    jade.clear_Session ->
      jade.session_Cookie (cookie)->
        assert_Is_Null(cookie)
        done()


  it 'login_As_QA', (done)->
    jade.login_As_QA ->
      jade.session_Cookie (cookie)->
        cookie.name.assert_Is('tm-session')
        done()

  it 'is_User_Logged_In', (done)->
    jade.is_User_Logged_In (result)->
      result.assert_Is_True()
      done()

  it 'open_Article, open_An_Article', (done)->
    using jade, ->
      @.login_As_User =>
        @.page.graphDB_API.articles_Ids (articles_Ids)=>
          article_Id = articles_Ids.first()
          @.open_Article article_Id, (html_A)=>
            @.open_An_Article (html_B)=>
              @.page.graphDB_API.article_Html article_Id, (html)=>
                html_A.assert_Is html_B
                      .assert_Contains html
                done()

  it 'render_File', (done)->
    params = ""
    jade.render_File 'jade_user_main', params, ($)->
      $.html().assert_Contains('<a href="/user/main.html">')
      done()

  it 'render_Mixin', (done)->
    params = {title : 'AAAA_123' }
    jade.render_Mixin 'search-mixins', 'directory-list', params, ($)->
      $('h3').attr().id.assert_Is('title'   )
      $('h3').html()   .assert_Is('AAAA_123')
      done()

  it 'sessionCookie', (done)->
    using jade, ->
      @.session_Cookie (cookie)=>
        cookie.name.assert_Is('tm-session')
        @.clear_Session =>
          @.is_User_Logged_In (result)=>
            result.assert_Is_False()
            done()

