class Flare_API

  @.page_Mappings = [ { name: 'About'    , url: 'about'    },
                      { name: 'Features' , url: 'features' } ]


  constructor: (page)->
    @page = page
    @.map_Pages()

  clear_Session: (callback)->
    @page.chrome.delete_Cookie 'tm-session', 'http://localhost/', callback

  page_Home           : (callback) => @page.open '/'                                       , callback

  map_Pages : ()=>
    for mapping  in Flare_API.page_Mappings

      mapping_Function = (url)->
        log url
        return  (callback)->@page.open '/flare/' + url , callback

      @["page_#{mapping.name}"] = mapping_Function mapping.url




module.exports = Flare_API