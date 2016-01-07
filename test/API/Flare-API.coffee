TM_API = require './TM-API'

class Flare_API extends TM_API

  @.page_Mappings = [
    { name: 'About'       , url: 'about'       }
    { name: 'Features'    , url: 'features'    }
    { name: 'Get_Started' , url: 'get-started' }
    { name: 'Index'       , url: 'index'       }
    { name: 'Navigate'    , url: 'navigate'    }

    { name: 'alert-application'             , url: 'alert-application'    }
    { name: 'app-keyword-search'            , url: 'app-keyword-search' }
    { name: 'article-new-window-view'       , url: 'article-new-window-view' }
    { name: 'article-new-window-view-alert' , url: 'article-new-window-view-alert' }
    { name: 'curated-content'               , url: 'curated-content' }
    { name: 'error-page'                    , url: 'error-page' }
    { name: 'forgot-password'               , url: 'forgot-password' }
    { name: 'help-docs'                     , url: 'help-docs' }
    { name: 'help-index'                    , url: 'help-index' }
    { name: 'help-sub-navigation'           , url: 'help-sub-navigation' }
    { name: 'index-validation'              , url: 'index-validation' }
    { name: 'main-app-view'                 , url: 'main-app-view' }
    { name: 'my-articles'                   , url: 'my-articles' }
    { name: 'my-search-results'             , url: 'my-search-results' }
    { name: 'new-user-onboard'              , url: 'new-user-onboard' }
    { name: 'pwd-reset'                     , url: 'pwd-reset' }
    { name: 'terms-and-conditions'          , url: 'terms-and-conditions' }
    { name: 'user'                          , url: 'user' }

  ]


  constructor: (page)->
    super(page)
    @.map_Pages()

  clear_Session: (callback)->
    @.page.chrome.delete_Cookie 'tm-session', 'http://localhost/', callback

  page_Home           : (callback) => @page.open '/flare'                                       , callback

  map_Pages : ()=>
    for mapping  in Flare_API.page_Mappings
      @["page_#{mapping.name}"] = do (url = mapping.url)->
        (callback)->
          @.page.open "/flare/#{url}", callback



  component: (name, callback)=>
    @.page.open "/angular/component/#{name}", callback

  eval_In_Controller: (controller, code, callback)->
    code = "scope = angular.element(document.documentElement.querySelector('div[ng-controller=#{controller}]')).scope();
            #{code};
            scope.$apply();"
    #console.log code
    250.wait =>             # need to find a better way to detect the digest has finished
      @.page.chrome.eval_Script code, (err,data)=>
        callback()

  login: (username, password, callback)=>
    @.component 'login_form',=>
      code = "scope.username = '#{username}';
              scope.password = '#{password}';
              scope.login();"
      @.eval_In_Controller 'Login_Controller', code, ->
        callback()

  login_As_QA   : (callback) =>
    user = @.QA_Users.first()
    @.login user.name, user.pwd, =>
      @.page.html callback

module.exports = Flare_API