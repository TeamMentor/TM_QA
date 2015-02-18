class GraphDB_API
  constructor: (options)->
    @.options = options || {}
    @.server = @.options.server || 'http://localhost:1332'

  articles: (callback)=>
    url = "#{@.server}/data/articles"
    url.GET_Json callback


module.exports = GraphDB_API