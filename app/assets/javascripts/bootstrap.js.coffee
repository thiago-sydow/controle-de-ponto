jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[data-toggle=tooltip]").tooltip()
  $(".collapsible-table").find(".btn").click (event) ->
  	event.preventDefault()

  $(".collapsible-table").find("tr").click (event) ->
  	texto = if $(this).find(".hide").is(":visible") then "+" else "-"
  	$(this).find(".btn").text(texto)
  	$(this).find(".hide").toggle()