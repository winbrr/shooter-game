local i = 0

return function()
  i = i + 1
  return string.format("%x", i)
end