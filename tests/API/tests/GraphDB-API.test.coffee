GraphDB_API     = require './../GraphDB-API'

describe 'API | GraphDB-API.test',->

  graphDB = null

  before ->
    graphDB = new GraphDB_API()

  it 'constructor',->
    graphDB.options.assert_Is {}
    graphDB.server.assert_Is 'http://localhost:1332'
    using new GraphDB_API({server:'aaaa'}), ->
      @.server.assert_Is 'aaaa'

  it 'articles', (done)->
    graphDB.articles (data)->
      articles = data.values()
      articles.assert_Is_Bigger_Than 500
      using articles.first(),->
        @.guid.split('-').assert_Size_Is 5
        @.title          .assert_Is_String()
        @.summary        .assert_Is_String()
        @.is             .assert_Is 'Article'
        @.id             .assert_Contains 'article-'
        done()