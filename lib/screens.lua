local screens = {}

function screens:getRandomChar(t)
  if t == 1 then
	  validChars = {"n", "o", "r", "n", "s", "."}
	else
	  validChars = {".", ",", "-", "+"}
	end
	return validChars[math.random(1, #validChars)]
end
random_char = screens:getRandomChar()

function screens:draw_hz()
  screen.aa(0)
  screen.font_face(8)
  screen.level(15)
  screen.font_size(20)
  screen.move(25, 15)
  screen.text_center("HERE")
  screen.font_size(16)
  screen.move(60, 50)
  screen.text_center(poll_hz .. "hz")
  selection = math.random(0,6)
  screen.font_size(10)
  screen_dirty = true
end

function screens:draw_here()
  if darkmode == 0 then
    screen.aa(0)
    screen.font_face(1)
    screen.level(15)
    screen.move(10, 20)
    screen.text("the sound begins")
    screen.move(36, 32)
    screen.text("HERE")
    screen.move(56, 30)
    screen.line(120,30)
    screen.move(120,30)
    screen.line(112,26)
    screen.move(120,30)
    screen.line(112,34)
    screen.move(10,45)
    screen.text("but you began")
    screen.move(26, 57)
    screen.text("THERE")
    screen.move(35, 50)
    screen.line(21,6)
    screen.move(20,3)
    screen.line(18,10)
    screen.move(20,4)
    screen.line(27,9)
  elseif darkmode == 1 then
    screen.font_face(1)
    screen.level(15)
    screen.move(10, 10)
    screen.text("the sound goes on")
    screen.move(10, 22)
    screen.text("HERE")
    screen.move(30, 20)
    screen.line(115,12)
    screen.move(115,12)
    screen.line(107,7)
    screen.move(115,12)
    screen.line(107,17)
    screen.move(32,36)
    screen.text("and you end")
    screen.move(48, 48)
    screen.text("THERE")
    screen.move(72, 46)
    screen.line(110,62)
    screen.move(110,62)
    screen.line(100,62)
    screen.move(110,62)
    screen.line(105,54)
  end
end

function screens:draw_albers()
  screen.aa(0)
  if darkmode == 0 then
    --white bg
    screen.level(10)
    screen.rect(0, 0, 128, 64)
    screen.fill()
    screen.level(0)
  elseif darkmode == 1 then
    screen.level(15)
  end
  --L1
  screen.move(4,8)
  screen.line(50,8)
  screen.line(50,16)
  screen.line(76,16)
  screen.line(76,40)
  screen.move(4,8)
  screen.line(4,50)
  screen.line(24,50)
  screen.line(24,62)
  screen.line(64, 62)
  screen.line(64,26)
  screen.line(34,26)
  screen.line(34,12)
  screen.line(14,12)
  screen.line(14,40)
  screen.line(76,40)
  --L2
  screen.move(6, 6)
  screen.line(52, 6)
  screen.line(52, 14)
  screen.line(78, 14)
  screen.line(78,38)
  screen.move(6, 6)
  screen.line(6, 48)
  screen.line(26,48)
  screen.line(26,60)
  screen.line(66, 60)
  screen.line(66,24)
  screen.line(36,24)
  screen.line(36,14)
  screen.line(16,14)
  screen.line(16,38)
  screen.line(78,38)
  --L3
  screen.move(8, 4)
  screen.line(54, 4)
  screen.line(54, 12)
  screen.line(80, 12)
  screen.line(80,36)
  screen.move(8, 4)
  screen.line(8, 46)
  screen.line(28,46)
  screen.line(28,58)
  screen.line(68, 58)
  screen.line(68,22)
  screen.line(38,22)
  screen.line(38,16)
  screen.line(18,16)
  screen.line(18,36)
  screen.line(80,36)
  --L4
  screen.move(10, 2)
  screen.line(56, 2)
  screen.line(56, 10)
  screen.line(82,10)
  screen.line(82,34)
  screen.move(10, 2)
  screen.line(10, 44)
  screen.line(30,44)
  screen.line(30,56)
  screen.line(70, 56)
  screen.line(70,20)
  screen.line(40,20)
  screen.line(40,18)
  screen.line(20,18)
  screen.line(20,34)
  screen.line(82,34)
  --squares
  screen.rect(34, 28, 26, 26)
  screen.rect(36, 30, 22, 22)
end

function screens:draw_city()
  screen.aa(0)
  if darkmode == 1 then
    screen.level(15)
    screen.rect(1,1,128,64)
    screen.fill()
  end
  -- column 1
  if darkmode == 0 then
    screen.level(15)
  elseif darkmode == 1 then
    screen.level(0)
  end
  for i=16,40,4 do
    screen.rect(0, i, 10, 2)
    screen.fill()
  end
  --column 2
  for i=0,12,4 do
    screen.level(2)
    screen.rect(10, i, 10, 2)
    screen.fill()
  end
  for i=2,34,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(10, i, 10, 2)
    screen.fill()
  end
  for i=38,42,4 do
    screen.level(2)
    screen.rect(10, i, 10, 2)
    screen.fill()
  end
  if darkmode == 0 then
    screen.level(15)
  elseif darkmode == 1 then
    screen.level(0)
  end
  screen.rect(10, 46, 10, 2)
  screen.fill()
  if darkmode == 0 then
    screen.level(15)
  elseif darkmode == 1 then
    screen.level(0)
  end
  screen.rect(10, 50, 10, 10)
  screen.fill()
  --column 3
  for i=14,42,4 do
    screen.level(2)
    screen.rect(20, i, 10, 2)
    screen.fill()
  end
  for i=16,40,4 do
    screen.level(2)
    screen.rect(26, i, 4, 2)
    screen.fill()
  end
  for i=44,48,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(26, i, 4, 2)
    screen.fill()
  end
  if darkmode == 0 then
    screen.level(15)
  elseif darkmode == 1 then
    screen.level(0)
  end
  screen.rect(20, 46, 10, 2)
  screen.fill()
  if darkmode == 0 then
    screen.level(15)
  elseif darkmode == 1 then
    screen.level(0)
  end
  screen.rect(20, 50, 10, 10)
  screen.fill()
  
  --column 4
  screen.level(2)
  screen.rect(32, 8, 8, 2)
  screen.fill()
  for i=12,56,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(30, i, 2, 2)
    screen.fill()
  end
  for i=12,56,4 do
    screen.level(2)
    screen.rect(32, i, 8, 2)
    screen.fill()
  end
  for i=14,42,4 do
    screen.level(2)
    screen.rect(30, i, 2, 2)
    screen.fill()
  end
  for i=14,42,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(32, i, 8, 2)
    screen.fill()
  end
  for i=46,54,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(30, i, 10, 2)
    screen.fill()
  end
  if darkmode == 0 then
    screen.level(15)
  elseif darkmode == 1 then
    screen.level(0)
  end
  screen.rect(30, 58, 10, 2)
  screen.fill()
  --column 5
  for i=0,44,4 do
    screen.level(15)
    screen.rect(40, i, 8, 2)
    screen.fill()
  end
  for i=42,48,4 do
    screen.level(2)
    screen.rect(40, i, 8, 2)
    screen.fill()
  end
  if darkmode == 0 then
    screen.level(15)
  elseif darkmode == 1 then
    screen.level(0)
  end
  screen.rect(40, 48, 8, 12)
  screen.fill()
  --column 6
  for i=12,44,4 do
    screen.level(2)
    screen.rect(48, i, 10, 2)
    screen.fill()
  end
  screen.level(2)
  screen.rect(48, 42, 10, 2)
  screen.fill()
  for i=46,58,2 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(48, i, 10, 2)
    screen.fill()
  end
  --column 7
  for i=10,34,4 do
    screen.level(15)
    screen.rect(58, i, 4, 2)
    screen.fill()
  end
  for i=12,36,4 do
    screen.level(2)
    screen.rect(58, i, 4, 2)
    screen.fill()
  end
  screen.level(2)
  screen.rect(58, 38, 4, 8)
  screen.fill()
  for i=46,58,2 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(58, i, 4, 2)
    screen.fill()
  end
  --column 8
  for i=2,54,4 do
    screen.level(2)
    screen.rect(62, i, 20, 2)
    screen.fill()
  end
  for i=12,36,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(72, i, 20, 2)
    screen.fill()
  end
  for i=40,52,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(62, i, 30, 2)
    screen.fill()
  end
  for i=56,58,2 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(62, i, 30, 2)
    screen.fill()
  end
  --column 9
  for i=8,40,4 do
    screen.level(2)
    screen.rect(92, i, 4, 2)
    screen.fill()
  end
  
  for i=16,42,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(100, i, 2, 2)
    screen.fill()
  end
  for i=44,52,4 do
    screen.level(15)
    screen.rect(92, i, 10, 2)
    screen.fill()
  end
  for i=56,58,2 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(92, i, 10, 2)
    screen.fill()
  end
  for i=16,46,2 do
    screen.level(2)
    screen.rect(96, i, 4, 2)
    screen.fill()
  end
  for i=48,54,2 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(96, i, 4, 2)
    screen.fill()
  end
  --column 10
  for i=2,58,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(102, i, 10, 2)
    screen.fill()
  end
  for i=16,56,4 do
    screen.level(2)
    screen.rect(102, i, 10, 2)
    screen.fill()
  end
  --column 11
  for i=0,12,2 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(112, i, 12, 2)
    screen.fill()
  end
  for i=16,56,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(112, i, 12, 2)
    screen.fill()
  end
  for i=50,58,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(114, i, 10, 2)
    screen.fill()
  end
  --column 12
  for i=0,40,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(126, i, 2, 2)
    screen.fill()
  end
  for i=2,58,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(124, i, 4, 2)
    screen.fill()
  end
  for i=44,56,4 do
    if darkmode == 0 then
      screen.level(15)
    elseif darkmode == 1 then
      screen.level(0)
    end
    screen.rect(124, i, 4, 2)
    screen.fill()
  end
end

function screens:draw_typewriter()
  screen.aa(0)
  if darkmode == 0 then
    screen.level(15)
    for i=1,62,5 do
      screen.font_face(8)
      screen.move(i,10)
      screen.text("n")
    end
    
    for i=1,58,5 do
      screen.font_face(8)
      screen.move(i,15)
      screen.text("o")
      --screen.text(string.rep(getRandomChar(2),1))
    end
    for i=20, 80, 5 do
      screen.font_face(1)
      screen.move(i,80-i)
      screen.text(". . . . . . . . . . . . . . . . . . .")
    end
    for i=1,54,5 do
      screen.font_face(8)
      screen.move(i,20)
      screen.text("r")
    end
    for i=1,50,5 do
      screen.move(i,25)
      screen.text("n")
    end
    for i=1,44,5 do
      screen.move(i,30)
      screen.text("s")
    end
    for i=1,40,5 do
      screen.move(i,35)
      screen.text("n")
    end
    for i=1,34,5 do
      screen.move(i,40)
      screen.text("o")
    end
    for i=1,30,5 do
      screen.move(i,45)
      screen.text("r")
    end
    for i=1,24,5 do
      screen.move(i,50)
      screen.text("n")
    end
    for i=1,20,5 do
      screen.move(i,55)
      screen.text("s")
    end
    for i=1,14,5 do
      screen.move(i,60)
      screen.text("n")
    end
    for i=1,10,5 do
      screen.move(i,65)
      screen.text("o")
    end
    for i=30,64,5 do
      screen.font_face(8)
      screen.move(40 + i/2,i)
      screen.text("n")
    end
    for i=20,64,3 do
      screen.font_face(8)
      screen.move(60 + i,i)
      screen.text("o")
    end
    screen.level(15)
    screen.rect(113,28,15,10)
    screen.fill()
    screen.level(1)
    screen.move(115,36)
    screen.font_face(23)
    screen.text("???")
  elseif darkmode == 1 then
    screen.font_face(8)
    for i=math.random(1,5),63,math.random(2,10) do
      
      screen.level(math.random(1,15))
      screen.move(math.random(1,4),i*2)
      screen.text(string.rep(screens:getRandomChar(1),128))
    end
    for i=math.random(5,10),64,math.random(2,10) do
      screen.level(math.random(1,15))
      screen.move(math.random(1,8),i*2)
      screen.text(string.rep(screens:getRandomChar(1),128))
    end
    local movex = math.random(1,113)
    local movey = math.random(10,50)
    screen.level(15)
    screen.rect(movex,movey,15,10)
    screen.fill()
    screen.level(1)
    screen.move(movex + 2,movey + 8)
    screen.font_face(23)
    screen.text("???")
    screen_dirty = true
  end
  
end

function screens:draw_circles()
  if darkmode == 1 then
    screen.aa(1)
    screen.level(15)
    screen.circle(22, 22, 20)
    screen.stroke()
    screen.move(14,10)
    screen.line(14,32)
    screen.stroke()
    screen.move(14,10)
    screen.line(24,14)
    screen.stroke()
    screen.move(24,14)
    screen.line(24,36)
    screen.stroke()
    screen.move(14,32)
    screen.line(24,36)
    screen.stroke()
    screen.move(19,12)
    screen.line(19,6)
    screen.stroke()
    screen.move(19,6)
    screen.line(29,10)
    screen.stroke()
    screen.move(29,10)
    screen.line(29,32)
    screen.stroke()
    screen.move(29,32)
    screen.line(24,30)
    screen.stroke()
    screen.circle(50, 30, 4)
    screen.stroke()
    screen.circle(60, 34, 3)
    screen.stroke()
    screen.circle(68, 29, 2)
    screen.stroke()
    screen.level(13)
    screen.circle(100, 30, 25)
    screen.fill()
    screen.level(2)
    screen.rect(84, 24, 32, 10)
    screen.fill()
  elseif darkmode == 0 then
    screen.aa(1)
    screen.level(15)
    screen.rect(1,1,128,64)
    screen.fill()
    screen.level(0)
    screen.move(8,60)
    screen.text("???")
    screen.stroke()
    screen.level(4)
    screen.circle(22, 22, 20)
    screen.fill()
    screen.level(15)
    screen.move(14,10)
    screen.line(14,20)
    screen.stroke()
    screen.move(14,10)
    screen.line(34,22)
    screen.move(30,10)
    screen.line(30,20)
    screen.move(30,10)
    screen.line(10,22)
    screen.line_rel(0,12)
    screen.line_rel(12, -6)
    screen.line_rel(12, 6)
    screen.line_rel(0,-12)
    screen.move(22,16)
    screen.line_rel(0, 12)
    screen.stroke()
    screen.level(0)
    screen.circle(50, 30, 4)
    screen.stroke()
    screen.circle(60, 34, 3)
    screen.stroke()
    screen.circle(68, 29, 2)
    screen.stroke()
    screen.level(5)
    screen.circle(100, 30, 25)
    screen.fill()
    screen.level(0)
    screen.circle(90,40,6)
    screen.fill()
    screen.circle(99,31,5)
    screen.fill()
    screen.circle(107,23,4)
    screen.fill()
    screen.circle(113,17,3)
    screen.fill()
  end
end

function screens:draw_drive()
  local dash = "-"
  local oh = "o"
  if darkmode == 0 then
    screen.level(15)
  elseif darkmode == 1 then
    screen.level(0)
  end
  screen.rect(1,1,128,64)
  screen.fill()
  screen.level(12)
  for i=2,32,2 do
    screen.move(1, i)
    screen.text(string.rep(dash, i/2 -2))
  end
  for i=32,64,2 do
    screen.move(i*2 + 9,i)
    screen.text(string.rep(dash, i))
  end
  for i=2,32,2 do
    screen.move(128, i)
    screen.text_right(string.rep(dash, i/2 -2))
  end
  for i=32,64,2 do
    screen.move(i*2 - 64,i)
    screen.text(string.rep(dash, i))
  end
  if darkmode == 1 then
    screen.level(math.random(0,5))
    screen.move(math.random(29,30),10)
    screen.text(".")
    screen.level(math.random(0,9))
    screen.move(math.random(69,70),23)
    screen.text(".")
    screen.level(math.random(0,2))
    screen.move(math.random(59,60),14)
    screen.text(".")
    screen.level(math.random(0,5))
    screen.move(math.random(89,90),4)
    screen.text(".")
    screen.level(math.random(0,10))
    screen.move(math.random(93,94),16)
    screen.text(".")
    screen.level(math.random(0,5))
    screen.move(math.random(38,40),2)
    screen.text(".")
    screen.level(math.random(0,5))
    screen.move(math.random(79,80),3)
    screen.text(".")
    screen.level(math.random(0,15))
    screen.move(math.random(30,90),math.random(1,25))
    screen.text(".")
    screen.move(8,60)
    screen.text("???")
  end
  screen_dirty = true
end

function screens:draw_handwriting()
  screen.level(15)
  screen.rect(1,1,128,64)
  screen.fill()  
  for i=8,65,5 do
    screen.level(3)
    screen.move(1,i)
    screen.text(string.rep("*",100))
  end
end

return screens