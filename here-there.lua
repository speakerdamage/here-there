--   . . . . . . . . . . . . . *************
--   . . . . . . . . . . . . . . ***********
--   . ??? . . . . . . . . . . . *********** 
--   . HERE/ . . . . . . . . . . ***********
--   . THERE . . . . . . . . . . ***********
--   . v1.2. . . . . . . . . . . ***********
--   . . . . . . . . . . . . . . ***********
--   . . . . . . . . . . . . . *************

-- TODO:
-- poll amp_in_l/amp_in_r at time of capture and set each sine rel to it
-- add RecordBuf to engine

engine.name = 'HereThere'
fileselect = require 'fileselect'
screens = include("lib/screens")

darkmode = 0
local selection = 0
SCREEN_FRAMERATE = 2
screen_dirty = true
local validChars
local tones = {}
local poll_timer = 1
local random_timer = 0
local num_sines = 32
poll_hz = -1
local VOICES = 1
local cutlength = 30
local cutwaiting = true
chordmode = true
donerecording = false
count = 0
saved = "..."
cutsample = "..."

function init()
  -- add ability to update poll time
  params:add {
    type = 'option',
    id = 'poll_time',
    name = 'Poll Time',
    options = {'1', '5', '10', 'random'},
    action = function(val)
      if val == random then
        poll_timer = math.random(1,20)
        random_timer = 1
      else
        poll_timer = val
        random_timer = 0
      end
    end
  }
  local sep = ": "

  params:add_taper("reverb_mix", "*"..sep.."mix", 0, 100, 50, 0, "%")
  params:set_action("reverb_mix", function(value) engine.reverb_mix(value / 100) end)

  params:add_taper("reverb_room", "*"..sep.."room", 0, 100, 50, 0, "%")
  params:set_action("reverb_room", function(value) engine.reverb_room(value / 100) end)

  params:add_taper("reverb_damp", "*"..sep.."damp", 0, 100, 50, 0, "%")
  params:set_action("reverb_damp", function(value) engine.reverb_damp(value / 100) end)
  
  local sep = ": "
  
  local sep = ": "

  for v = 1, VOICES do
    params:add_separator()

    params:add_file(v.."sample", v..sep.."sample")
    params:set_action(v.."sample", function(file) engine.read(v, file) end)

    params:add_taper(v.."glutvol", v..sep.."glutvol", -60, 20, 0, 0, "dB")
    params:set_action(v.."glutvol", function(value) engine.volume(v, math.pow(10, value / 20)) end)

    params:add_taper(v.."speed", v..sep.."speed", -200, 200, 100, 0, "%")
    params:set_action(v.."speed", function(value) engine.speed(v, value / 100) end)

    params:add_taper(v.."jitter", v..sep.."jitter", 0, 500, 0, 5, "ms")
    params:set_action(v.."jitter", function(value) engine.jitter(v, value / 1000) end)

    params:add_taper(v.."size", v..sep.."size", 1, 500, 100, 5, "ms")
    params:set_action(v.."size", function(value) engine.size(v, value / 1000) end)

    params:add_taper(v.."density", v..sep.."density", 0, 512, 20, 6, "hz")
    params:set_action(v.."density", function(value) engine.density(v, value) end)

    params:add_taper(v.."pitch", v..sep.."pitch", -24, 24, 0, 0, "st")
    params:set_action(v.."pitch", function(value) engine.pitch(v, math.pow(0.5, -value / 12)) end)

    params:add_taper(v.."spread", v..sep.."spread", 0, 100, 0, 0, "%")
    params:set_action(v.."spread", function(value) engine.spread(v, value / 100) end)

    params:add_taper(v.."fade", v..sep.."att / dec", 1, 9000, 1000, 3, "ms")
    params:set_action(v.."fade", function(value) engine.envscale(v, value / 1000) end)
  end

 
  -- Render Style
  screen.level(15)
  screen.aa(0)
  screen.line_width(1)
  screen_refresh_metro = metro.init()
  screen_refresh_metro.event = function()
    if screen_dirty then
      screen_dirty = false
      redraw()
    end
  end
  screen_refresh_metro:start(1 / SCREEN_FRAMERATE)
  
  -- listen to audio
  -- and initiate recording on incoming audio
  p_amp_in=poll.set("amp_in_l")
  -- set period low when primed, default 1 second
  p_amp_in.time=1
  p_amp_in.callback=function(val)
    -- print("incoming signal = "..val)
    if cutwaiting == true then
      if val > 0.03 then
        print("amp in pass")
        init_softcut()
      end
    end
  end
  p_amp_in:start()
  
  params:set("clock_tempo",10)
  clock.run(timers)
  params:bang()
end

function init_softcut()
  audio.level_adc_cut(1)
  audio.level_eng_cut(0)
  softcut.level_input_cut(1,1,1.0)
  softcut.level_input_cut(2,2,1.0)
  softcut.buffer_clear()
  for i=1,2 do
    softcut.play(i,1)
    softcut.rate(i,1)
    softcut.loop(i,1)
    --softcut.fade_time(1,0.2)
    --softcut.level_slew_time(1,0.8)
    --softcut.rate_slew_time(1,0.8)
    softcut.enable(i,1)
    softcut.buffer(i,1)
    softcut.level(i,1.0)
    -- l/r volume controls
    params:add_control(i .. "cutvol", i .. " cutvol", controlspec.new(0, 1, "lin", 0, 1, ""))
    params:set_action(i .. "cutvol", function(x) softcut.level(i, x) end)
    softcut.pre_level(i,0.5)
    softcut.rec_level(i,1)
    softcut.rec(i,1)
    softcut.pan_slew_time(i,0.5)
  end
  softcut.position(1,1)
  softcut.position(2,cutlength * 2)
  softcut.pan(1,math.random(0,10) * -0.1)
  softcut.pan(2,math.random(0,10))
  softcut.loop_start(1,1)
  softcut.loop_end(1,cutlength)
  softcut.loop_start(2,cutlength * 2)
  softcut.loop_end(2,cutlength * 3)
  cutwaiting = false
end

function save_cut()
  saved = "there-"..string.format("%04.0f",10000*math.random())..".wav"
  softcut.buffer_write_mono(_path.dust.."/audio/here/"..saved,1,cutlength, 1)
  cutsample = _path.dust.."audio/here/"..saved
  donerecording = true
  clock.sleep(3) -- needs time to write/read
  load_cut(cutsample)
end

function load_cut(smp)
  params:set("1glutvol", -10)
  randomparams()
  start_voice()
  params:set("1sample", smp)
  screen_dirty = true
end

function randomparams()
  params:set("1speed", math.random(-200,200))
  params:set("1jitter", math.random(100,300))
  params:set("1size", math.random(100,350))
  params:set("1density", math.random(100,350))
  --params:set("1pitch", math.random(1,10))
  params:set("1spread", math.random(40,100))
  params:set("reverb_mix", math.random(0,100))
  params:set("reverb_room", math.random(0,100))
  params:set("reverb_damp", math.random(0,100))
  --print("random params")
end

function reset_voice()
  engine.seek(1, 0)
end

function start_voice()
  reset_voice()
  engine.gate(1, 1)
end

function softcutting()
  if(donerecording == false) then
    save_cut()
  end
  softcut.position(1,math.random(1,25))
  softcut.position(2,math.random(60,85))
  softcut.pan(1,math.random(0,10) * -0.1)
  softcut.pan(2,math.random(0,10))
end

function timers()
  while true do
    if(count > 20) then
      clock.sleep(math.random(0,1000) * 0.01)
      play_tones()
      if(count < 33) then
        clock.sleep(poll_timer)
        poll_l()
      end
    else
      clock.sleep(poll_timer)
      poll_l()
    end
  end
end

function poll_l()
  local pitch_poll_l = poll.set("pitch_in_l", function(value)
    if((value > -1) and (count < num_sines)) then
      local rounded = math.floor(value * 100) * 0.01
      table.insert(tones, rounded)
      poll_hz = rounded
      selection = 100
      screen_dirty = true
      count = count + 1
    end
  end)
  pitch_poll_l:start()
  pitch_poll_l:stop()
  
end

function play_tones()
  for i,v in ipairs(tones) do 
    --print(i,v) -- remove
    engine.amp_atk(i, math.random(1,50) * 0.001)
    engine.amp_rel(i, math.random(1,50) * 0.01)
    engine.am_in(i, math.random(1,100) * 0.01)
    engine.amp(i,math.random(0,10) * 0.01)
    engine.am_add(i, math.random(0,100) * 0.01)
    engine.am_mul(i, math.random(0,100) * 0.01)
    if(chordmode == false) then
      softcutting()
      clock.sleep(math.random(0,30) * 0.1)
    end
    
    engine.pan_lag(i, math.random(0,10) * 0.1)
    engine.hz_lag(i, math.random(0,10) * 0.1)
    engine.pan(i,math.random(-100,100) * 0.01)
    engine.hz(i, v)
  end
  if(chordmode == true) then
    -- todo: decouple softcut timing, or lock to above
    clock.sleep(math.random(0,1000) * 0.01)
    softcutting()
  end
  darkmode = math.random(0,1)
  selection = math.random(0,6)
  screen_dirty = true
end

function stop_tones()
  for i,v in ipairs(tones) do 
    engine.amp(i, 0)
  end
  clear_tones()
end

function clear_tones()
  for k,v in pairs(tones) do 
    tones[k]=nil 
  end
  count = 0
  poll_l()
end

-- Interactions
function key(n, z)
  if n == 1 then
    shift = z
  elseif n == 2 then
    if z == 1 then
      -- clear buffers?
      cutwaiting = true
      init_softcut()
    else
      if chordmode then
        chordmode = false
      else
        chordmode = true
      end
      if darkmode == 0 then
        darkmode = 1
        screen_dirty = true
      else
        darkmode = 0
        screen_dirty = true
      end
    end
  elseif n == 3 then
    if z == 1 then
      --stop_tones()
      randomparams()
      screen_dirty = true
    else
      clear_tones()
      darkmode = 0
      selection = math.random(0,6)
      screen_dirty = true
    end
  end
end

function enc(id,delta)
  if id == 1 then
    params:delta("1glutvol", delta)
  elseif id == 2 then
    params:delta("1speed", delta)
    -- TODO: control sines amp?
    params:delta("1cutvol", delta)
    params:delta("2cutvol", delta)
  elseif id == 3 then
    params:delta("1pitch", delta)
  end
end

-- Render
function redraw()
  screen.clear()
  if selection == 0 then
    screens:draw_here()
  elseif selection == 1 then
    screens:draw_albers()
  elseif selection == 2 then
    screens:draw_city()
  elseif selection == 3 then
    screens:draw_typewriter()
  elseif selection == 4 then
    screens:draw_circles()
  elseif selection == 5 then
    screens:draw_drive()
  elseif selection == 6 then
    screens:draw_handwriting()
  elseif selection == 100 then
    screens:draw_hz()
  end
  screen.stroke()
  screen.update()
end
