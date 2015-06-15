class GraphDB_API
  constructor: (options)->
    @.options = options || {}
    @.port       = global.config?.tm_graph?.port || 1332
    @.server = @.options.server || "http://localhost:#{@.port}"

  article_Html: (article_Key, callback)->
    url = "#{@.server}/data/article_Html/#{article_Key}"
    url.GET_Json (data)->
      callback data.html || ""

  articles: (callback)=>
    url = "#{@.server}/data/articles"
    url.GET_Json callback

  articles_Ids: (callback)=>
    @articles (articles)->
      callback articles.keys()


module.exports = GraphDB_API