$ ->
  getSearch = ->
    $.get "/admin/search", (data) ->
      n = Math.floor(Math.random()*10)
      name = data.statuses[n].user.name
      text = data.statuses[n].text

      $("#name").fadeOut 200, ->
        $(this).text("")
        $(this).delay(300).fadeIn 200, ->
          $(this).text(name)

      $("#tweet").fadeOut 200, ->
        $(this).text("")
        $(this).delay(300).fadeIn 200, ->
          $(this).text(text)

      return

  setInterval getSearch, 8000
