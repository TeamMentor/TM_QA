require 'fluentnode'

async     = require 'async'
supertest = require 'supertest'

TM_Design_Server = require('../../TM_4_0_Design/node/server')

describe 'security | to-review',->

  describe 'Due to NodeJs Express static mapper, TM Design allows download of static files', ->

    it 'using supertest', (done)->
      targets = [
                  { status: 200 ,  path: '/package.json'}
                  { status: 200 ,  path: '/node_modules/jade/package.json'}

                  { status: 404 ,  path: '/aaaaaaa.json'}
                  { status: 200 ,  path: '/guest/about.html'}

                  { status: 404 ,  path: '/node_modules/express/package.json'}      # these don't work via supertest
                  { status: 404 ,  path: '/source/jade/_layouts/head.jade'}         # but work on the
                  { status: 404 ,  path: '/node/server.coffee'}]                    # browser


      server = supertest(TM_Design_Server)

      test_Path= (target, next)->
        server.get(target.path)
              .expect(target.status)
              .end (err,res)->
                if err
                  log res.text
                next()

      async.eachSeries(targets, test_Path, done)

    it 'using http request', (done)->
      qa_Server  = "http://localhost:1337"
      targets    = ['/','/guest/about.html'                              # these should be there

                    '/package.json', '/node_modules/jade/package.json'   # these shouldn't
                    '/node_modules/express/package.json'
                    '/source/jade/_layouts/head.jade'
                    '/node/server.coffee']

      qa_Server.GET (html)->

        (done(); return) if is_Null(html)   # check if the qa_Server is available

        test_Path = (target, next)->
          qa_Server.append(target).GET (html)->
            html.assert_Not_Contains('Cannot GET')
            next()

        async.eachSeries(targets, test_Path, done)
