
require 'fluentnode'
QA_TM_Design = require './../API/QA-TM_4_0_Design'

describe '| jade | page-article.test |',->
  page     = QA_TM_Design.create(before,after)                                       # required import and get page object
  jade     = page.jade_API
  graphDb  = page.graphDB_API
  articles = null

  @.timeout 5000

  before (done)->
    jade.login_As_User ->
      graphDb.articles (data)->
        articles = data.values()
        done()

  it '/articles', (done)->
    jade.page_User_Articles (html,$)->
      $('#articles a').length.assert_Is_Bigger_Than 150
      $('#resultsTitle').text().contains 'Showing 250 articles (of '
      $('#articles a').attr().href.assert_Contains 'article/article-'

      article_Data = articles.first()
      article_Html = $('#articles a').first()

      article_Html.text()     .assert_Is article_Data.title
      article_Html.attr().id  .assert_Is article_Data.id
      article_Html.attr().href.assert_Is "/article/#{article_Data.id}"
      done()

  describe '/article/:key',->

    article = null

    before (done)->
      jade.login_As_User ->
        graphDb.articles (data)->
          article = data.values().first()
          done()

    check_Article_Contents = (key, selector, expected_Text, next)->
      jade.page_User_Article key, (html,$)->
        $(selector).text().assert_Is expected_Text
        next()

    it 'by id', (done)->
      check_Article_Contents article.id    , '#title', article.title  , done

    it 'by partial id', (done)->
      partial_Id = article.id.remove 'article-'
      check_Article_Contents partial_Id    , '#title', article.title  , done

    it 'by guid', (done)->
      check_Article_Contents article.guid  , '#title', article.title , done

    it 'by title', (done)->
      check_Article_Contents article.title , '#title', article.title , done

    it 'by dashed-title', (done)->
      dashed_Title = article.title.replace(/ /g,'-')
      check_Article_Contents dashed_Title  , '#title', article.title , done

    it 'by id and title', (done)->
      id_and_title = "#{article.id}/#{article.title}"
      check_Article_Contents id_and_title  , '#title', article.title  , done