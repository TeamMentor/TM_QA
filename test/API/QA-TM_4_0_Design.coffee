require 'fluentnode'
require '../set-globals'

NodeWebKit_Service = require 'nwr'
Jade_API           = require './Jade-API'
Flare_API          = require './Flare-API'
GraphDB_API        = require './GraphDB-API'
html               = require 'html'

class QA_TM_4_0_Design

  constructor: ()->
    @.nodeWebKit   = new NodeWebKit_Service(57777)
    @.jade_API     = new Jade_API(@)
    @.flare_API    = new Flare_API(@)
    @.port_Design  = global.config?.tm_design?.port || 1337
    @.port_Graph   = global.config?.tm_graph?.port  || 1332
    @.graphDB_API  = new GraphDB_API {server: "http://localhost:#{@.port_Graph}"}
    @.tm_Server    = "http://localhost:#{@.port_Design}"
    @.chrome       = null
    @.open_Delay   = 0

  before: (done)=>
    if not (@chrome is null)
      done()
      return;
    @nodeWebKit.path_App   = '/API'.append_To_Process_Cwd_Path()
    @nodeWebKit.chrome.url_Json.GET (data)=>
      if (data is null)
        @nodeWebKit.start =>
          @chrome = @nodeWebKit.chrome
          @add_Extra_Error_Handling done
      else
        @nodeWebKit.chrome.connect =>
          @chrome = @nodeWebKit.chrome
          done()

  after: (done)->
    if @chrome != null
      @chrome._chrome.close()
    @chrome = null
    done()

  html: (callback)=>
    @.chrome.html (html,$) =>
      callback(html,@.add_Cheerio_Helpers($))

  html_Pretty: (callback)=>
    @.html (raw_Html,$)=>
      callback html.prettyPrint(raw_Html,{indent_size: 2}), $

  open: (url, callback)=>
    @chrome.open @tm_Server + url, =>
      @open_Delay.wait =>
        @html(callback)

  show: (callback)-> @nodeWebKit.show(callback)

  wait_For_Complete: (callback)=>
    @.chrome.page_Events.on 'loadEventFired', ()=>
      @.html callback

  add_Cheerio_Helpers: ($)=>
    $.body = $('body').html()
    $.title = $('title').html()
    $.links = ($.html(link) for link in $('a'))
    $

  screenshot: (name, callback)=>
    safeName = name.replace(/[^()^a-z0-9._-]/gi, '_') + ".png"
    png_File = "./_screenshots".append_To_Process_Cwd_Path().folder_Create()
                               .path_Combine(safeName)

    @chrome._chrome.Page.captureScreenshot (err, image)->
      require('fs').writeFile png_File, image.data, 'base64',(err)->
        callback()

  window_Position: (x,y,width,height, callback)=>
    @nodeWebKit.open_Index ()=>
      @chrome.eval_Script "curWindow = require('nw.gui').Window.get();
                           curWindow.x=#{x};
                           curWindow.y=#{y};
                           curWindow.width=#{width};
                           curWindow.height=#{height};
                           ", callback

 # click: (href, callback)->
 #   @chrome.eval_Script "document.querySelector('a[href*=\"#{href}\"]').click()", =>
 #     @wait_For_Complete =>
 #       @open_Delay.wait =>
 #         callback()

  eval: (code, callback)->
    @chrome.eval_Script(code,callback)

  dom_Find     : (selector,callback)=>
    @chrome.dom_Find selector, (data)->
      callback(data.$)

  field: (selector, callback)=>
    @chrome.dom_Find "input#{selector}", (data)->
      attributes = data.$('input').attr()
      callback(attributes)

  input: (id, value, callback)=>
    code = "element = document.documentElement.querySelector('input##{id}');
            element.value = '#{value}'"
    console.log(code)
    @chrome.eval_Script code, (err,data)=>
      callback()

  textArea: (id, value, callback)=>


    code = "element = document.documentElement.querySelector('textarea##{id}');
            element.innerHTML = '#{value}'"
    @chrome.eval_Script code, (err,data)=>
      callback()

  click: (text, callback)->
    code = "if (document.querySelector('#{text}') != null)
            {
              document.querySelector('#{text}').click()
            } else
            {
              elements = document.documentElement.querySelectorAll('a,button');
              for(var i=0; i< elements.length; i++)
                if(elements[i].innerText == '#{text}')
                  elements[i].click();
            }"
    console.log code

    @chrome.eval_Script code, (err,data)=>
      @wait_For_Complete =>
        @open_Delay.wait =>
           @html callback

  add_Extra_Error_Handling: (callback)->
    @nodeWebKit.open_Index =>
      code = "process.on('uncaughtException', function(err) { alert(err);});";
      @chrome.eval_Script code, (err,data)=>
        callback()


singleton  = null


QA_TM_4_0_Design.create = (before, after)->
  #return new QA_TM_4_0_Design()              # uncomment this if a new instance is needed per test (and the 'after' mocha event is set)
  if singleton is null
    singleton = new QA_TM_4_0_Design()

  if typeof(before) == 'function'           # set these mocha events here so that the user (writting the unit test) doesn't have to
    before (done)-> singleton.before done
  if typeof(after) == 'function'
    after (done)-> singleton.after done
  return singleton

module.exports = QA_TM_4_0_Design