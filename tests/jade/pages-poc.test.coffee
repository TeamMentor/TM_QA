QA_TM_Design = require './../API/QA-TM_4_0_Design'

# this test suite contains all  all pages that we currently need to support for logged in  users
describe 'jade | pages-poc', ->
  page = QA_TM_Design.create(before, after);
  jade = page.jade_API;

  it '-poc-', (done)->
    jade.login_As_User  ->
      jade.page_User_PoC '', (html, $)=>
         done()

  it 'search-two-column', (done)->
    jade.login_As_User  ->
      searchText = 'security'
      jade.page_User_PoC 'search-two-column', (html, $)=>
        code = "document.querySelector('input').value='#{searchText}';
                document.querySelector('button').click()"
        page.chrome.eval_Script code, =>
          page.wait_For_Complete (html, $)=>
            page.chrome.url (url)=>
              url.assert_Contains('search-two-column?text=' + searchText)
              $('#articles a').keys().assert_Size_Is_Bigger_Than 10
              done()

  it 'md-render', (done)->
    #jade.login_As_User  ->
      page.open '/-poc-/md-render?md_text=this is **bold**, this is normal<script>alert(12)<script><img a=asd onerror=aaaa />', (html,$)->
        $('title').html().assert_Is('TEAM Mentor 4.0 (Html version)')
        $('h3').html().assert_Is 'Render Markdown PoC'
        selector = 'text_md'
        markdown = "this **is in bold**..."
        page.textArea 'text_md', markdown,->
          page.click 'RENDER', ->
          done()
