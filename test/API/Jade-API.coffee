TM_API = require './TM-API'

class Jade_API extends TM_API

  page_403            : (callback) => @page.open '/jade/guest/403.html'                   , callback
  page_404            : (callback) => @page.open '/jade/guest/404.html'                   , callback
  page_500            : (callback) => @page.open '/jade/guest/500.html'                   , callback
  page_About          : (callback) => @page.open '/jade/guest/about.html'                 , callback
  page_Help           : (callback) => @page.open '/jade/help/index.html'                  , callback
  page_Home           : (callback) => @page.open '/jade/'                                 , callback
  page_Features       : (callback) => @page.open '/jade/guest/features.html'              , callback
  page_Login          : (callback) => @page.open '/jade/guest/login.html'                 , callback
  page_Login_Fail     : (callback) -> @page.open '/jade/guest/login-Fail.html'            , callback
  page_Login_Required : (callback) => @page.open '/jade/guest/login-required.html'        , callback
  page_Main_Page      : (callback) => @page.open '/jade/guest/default.html'               , callback
  page_Pwd_Forgot     : (callback) => @page.open '/jade/guest/pwd-forgot.html'            , callback
  page_Pwd_Sent       : (callback) => @page.open '/jade/guest/pwd-sent.html'              , callback
  page_Sign_Up        : (callback) => @page.open '/jade/guest/sign-up.html'               , callback
  page_Sign_Up_Fail   : (callback) => @page.open '/jade/guest/sign-up-Fail.html'          , callback
  page_Sign_Up_OK     : (callback) => @page.open '/jade/guest/sign-up-OK.html'            , callback


  page_TermsAndCond   : (callback        ) => @page.open '/jade/misc/terms-and-conditions', callback
  page_Help           : (callback        ) => @page.open '/jade/help/index.html'          , callback
  page_Help_Page      : (target,callback ) => @page.open "/jade/help/#{target}"           , callback

  page_User_Article   : (target, callback) => @page.open "/jade/article/#{target}"         , callback
  page_User_Articles  : (callback        ) => @page.open '/jade/articles'                  , callback

  page_User_Index     : (callback        ) => @page.open "/jade/show"                      , callback
  page_User_Logout    : (callback        ) => @page.open '/jade/user/logout'               , callback
  page_User_Main      : (callback        ) => @page.open '/jade/user/main.html'            , callback
  page_User_Graph     : (target, callback) => @page.open "/jade/show/#{target}"            , callback
  page_User_Graph_All : (callback        ) => @page.open "/jade/show"                      , callback


  page_User_PoC       : (target, callback) => @page.open "/jade/poc/#{target}"  , callback

  render_File: (file, params, callback)->
    mixinPage = "/render/file/#{file}?#{params}"
    @.page.open mixinPage, (html, $)->
      callback($)

  render_Mixin: (file, mixin, params, callback)->
    mixinPage = "/render/mixin/#{file}/#{mixin}?viewModel=#{params.json_Str().url_Encode()}"
    @.page.open mixinPage, (html, $)->
      callback($)


module.exports = Jade_API