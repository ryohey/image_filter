getPixel = (imageData, x, y) ->
  obj = {}
  i = (y*imageData.width+x)*4
  obj[val] = imageData.data[i+parseInt(key)] for key, val of ["r", "g", "b", "a"]
  obj

setPixel = (imageData, x, y, color) ->
  i = (y*imageData.width+x)*4
  clip = (val) -> Math.min(Math.max(val, 0), 255)
  imageData.data[i+parseInt(key)] = clip color[val] for key, val of ["r", "g", "b", "a"]

colorMulti = (color, val) ->
  color.r *= val
  color.g *= val
  color.b *= val
  #color.a *= val

colorsAdd = (colorA, colorB) ->
  colorA.r += colorB.r
  colorA.g += colorB.g
  colorA.b += colorB.b
  colorA.a = 255
  #colorA.a += colorB.a

filter = (imageData, filterData, matrix) ->
  for y in [0..imageData.height]
    for x in [0..imageData.width]
      color = {r: 0, g: 0, b: 0, a: 0}
      for my in [0..2]
        for mx in [0..2]
          nearColor = getPixel imageData, x+mx-1, y+my-1
          colorMulti nearColor, matrix[my][mx]
          colorsAdd color, nearColor

      setPixel filterData, x, y, color

onmessage = (event) ->
  filter event.data.imageData, event.data.filterData, event.data.matrix
  postMessage event.data.filterData