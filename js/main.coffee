$ ->
  worker = new Worker("js/worker.js");
  canvasElm = $("#canvas")
  context = canvasElm.get(0).getContext('2d')
  width = canvasElm.width()
  height = canvasElm.height()
  imageElm = $(".item>img")
  imageData = null
  imageElm
    .load ->
      context.drawImage imageElm.get(0), 0, 0
      imageData = context.getImageData 0, 0, width, height
      $("#loading").fadeOut()

  $("#apply").click ->
      $("#loading").fadeIn()
      inputs = $("form input")
      matrix = [[],[],[]]
      for x in [0..2]
        for y in [0..2]
          matrix[x][y] = parseFloat(inputs.eq(x*3+y).val())
      worker.postMessage {
        imageData: imageData,
        filterData: context.createImageData(width, height)
        matrix: matrix
      }

  worker.onmessage = (event) ->
    context.putImageData event.data, 0, 0
    $("#loading").fadeOut()
      
  true