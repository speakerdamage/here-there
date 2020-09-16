// 32 sines + glut w/ live buffer

Engine_HereThere : CroneEngine {
	classvar num;
	var <synth;
	
	classvar nvoices = 2;
	var pg;
	var effect;
	var <buffers;
	var <voices;
	var mixBus;
	var <phases;
	var <levels;
	var <seek_tasks;
	var recSynth;
	
	
	

	*initClass {  num = 32; }

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}
	
	// disk read
	readBuf { arg i, path;
		if(buffers[i].notNil, {
			if (File.exists(path), {
				// TODO: load stereo files and duplicate GrainBuf for stereo granulation
				var newbuf = Buffer.readChannel(context.server, path, 0, -1, [0], {
					voices[i].set(\buf, newbuf);
					buffers[i].free;
					buffers[i] = newbuf;
				});
			});
		});
	}
	
	// live record
  recordToBuf { arg bufIndex=0, inChannel=0;
  	if(buffers[bufIndex].notNil, {
  		recSynth = { 
  			RecordBuf.ar(
  				SoundIn.ar(inChannel),   // capture requested channel...
  				buffers[bufIndex].bufnum, // to requested buffer
  				doneAction:2 // free the synth automatically at buffer end (if not already freed)
  			);
  		}.play(Crone.server);
  	});
  }
  
  stopRecord { 
  	if (recSynth.notNil, { recSynth.free; });
  }
	
	

	alloc {
	  //32 sines
		var server = Crone.server;
		var def = SynthDef.new(\zsin, {
			arg out, hz=220, amp=0.0, amp_atk=0.001, amp_rel=0.05, hz_lag=0.005, pan=0, pan_lag=0.005, am_in=0, am_mul=0, am_add=1.0;
			var amp_mod, amp_, hz_, pan_;
			amp_ = LagUD.ar(K2A.ar(amp), amp_atk, amp_rel);
			amp_mod = SoundIn.ar(am_in) * LagUD.ar(K2A.ar(am_mul), amp_atk, amp_rel) + LagUD.ar(K2A.ar(am_add), amp_atk, amp_rel);
			hz_ = Lag.ar(K2A.ar(hz), hz_lag);
			pan_ = Lag.ar(K2A.ar(pan), pan_lag);
			Out.ar(out, Pan2.ar(SinOsc.ar(hz_) * amp_ * amp_mod, pan));
		});
		def.send(server); 
		server.sync;
		
		synth = Array.fill(num, { Synth.new(\zsin, [\out, context.out_b], target: context.xg) });

		#[\hz, \amp, \pan, \amp_atk, \amp_rel, \hz_lag, \pan_lag, \am_mul, \am_add].do({
			arg name;
			this.addCommand(name, "if", {
				arg msg;
				var i = msg[1] -1;
				if(i<num && i >= 0, { 
					synth[i].set(name, msg[2]);
				});
			});
		});
		
		this.addCommand(\am_in, "ii", { 
		  arg msg;
		  var i, j;
		  i = msg[1] - 1;
		  j = msg[2] - 1;
		  if (i<num && i>=0 && j<2 && j >= 0, {
		    synth[i].set(\am_in, j);
		  });
		});
		
		
		//Glut
		
		buffers = Array.fill(nvoices, { arg i;
			Buffer.alloc(
				context.server,
				context.server.sampleRate * 1,
			);
		});
		
		SynthDef(\synth, {
			arg out, phase_out, level_out, buf,
			gate=0, pos=0, speed=1, jitter=0,
			size=0.1, density=20, pitch=1, spread=0, gain=1, envscale=1,
			freeze=0, t_reset_pos=0;

			var grain_trig;
			var jitter_sig;
			var buf_dur;
			var pan_sig;
			var buf_pos;
			var pos_sig;
			var sig;

			var env;
			var level;

			grain_trig = Impulse.kr(density);
			buf_dur = BufDur.kr(buf);

			pan_sig = TRand.kr(trig: grain_trig,
				lo: spread.neg,
				hi: spread);

			jitter_sig = TRand.kr(trig: grain_trig,
				lo: buf_dur.reciprocal.neg * jitter,
				hi: buf_dur.reciprocal * jitter);

			buf_pos = Phasor.kr(trig: t_reset_pos,
				rate: buf_dur.reciprocal / ControlRate.ir * speed,
				resetPos: pos);

			pos_sig = Wrap.kr(Select.kr(freeze, [buf_pos, pos]));

			sig = GrainBuf.ar(2, grain_trig, size, buf, pitch, pos_sig + jitter_sig, 2, pan_sig);
			env = EnvGen.kr(Env.asr(1, 1, 1), gate: gate, timeScale: envscale);

			level = env;

			Out.ar(out, sig * level * gain);
			Out.kr(phase_out, pos_sig);
			// ignore gain for level out
			Out.kr(level_out, level);
		}).add;

		SynthDef(\effect, {
			arg in, out, mix=0.5, room=0.5, damp=0.5;
			var sig = In.ar(in, 2);
			sig = FreeVerb.ar(sig, mix, room, damp);
			Out.ar(out, sig);
		}).add;

		context.server.sync;

		// mix bus for all synth outputs
		mixBus =  Bus.audio(context.server, 2);

		effect = Synth.new(\effect, [\in, mixBus.index, \out, context.out_b.index], target: context.xg);

		phases = Array.fill(nvoices, { arg i; Bus.control(context.server); });
		levels = Array.fill(nvoices, { arg i; Bus.control(context.server); });

		pg = ParGroup.head(context.xg);

		voices = Array.fill(nvoices, { arg i;
			Synth.new(\synth, [
				\out, mixBus.index,
				\phase_out, phases[i].index,
				\level_out, levels[i].index,
				\buf, buffers[i],
			], target: pg);
		});

		context.server.sync;

		this.addCommand("reverb_mix", "f", { arg msg; effect.set(\mix, msg[1]); });
		this.addCommand("reverb_room", "f", { arg msg; effect.set(\room, msg[1]); });
		this.addCommand("reverb_damp", "f", { arg msg; effect.set(\damp, msg[1]); });

		this.addCommand("read", "is", { arg msg;
			this.readBuf(msg[1] - 1, msg[2]);
		});

		this.addCommand("seek", "if", { arg msg;
			var voice = msg[1] - 1;
			var lvl, pos;
			var seek_rate = 1 / 750;

			seek_tasks[voice].stop;

			// TODO: async get
			lvl = levels[voice].getSynchronous();

			if (false, { // disable seeking until fully implemented
				var step;
				var target_pos;

				// TODO: async get
				pos = phases[voice].getSynchronous();
				voices[voice].set(\freeze, 1);

				target_pos = msg[2];
				step = (target_pos - pos) * seek_rate;

				seek_tasks[voice] = Routine {
					while({ abs(target_pos - pos) > abs(step) }, {
						pos = pos + step;
						voices[voice].set(\pos, pos);
						seek_rate.wait;
					});

					voices[voice].set(\pos, target_pos);
					voices[voice].set(\freeze, 0);
					voices[voice].set(\t_reset_pos, 1);
				};

				seek_tasks[voice].play();
			}, {
				pos = msg[2];

				voices[voice].set(\pos, pos);
				voices[voice].set(\t_reset_pos, 1);
				voices[voice].set(\freeze, 0);
			});
		});

		this.addCommand("gate", "ii", { arg msg;
			var voice = msg[1] - 1;
			voices[voice].set(\gate, msg[2]);
		});

		this.addCommand("speed", "if", { arg msg;
			var voice = msg[1] - 1;
			voices[voice].set(\speed, msg[2]);
		});

		this.addCommand("jitter", "if", { arg msg;
			var voice = msg[1] - 1;
			voices[voice].set(\jitter, msg[2]);
		});

		this.addCommand("size", "if", { arg msg;
			var voice = msg[1] - 1;
			voices[voice].set(\size, msg[2]);
		});

		this.addCommand("density", "if", { arg msg;
			var voice = msg[1] - 1;
			voices[voice].set(\density, msg[2]);
		});

		this.addCommand("pitch", "if", { arg msg;
			var voice = msg[1] - 1;
			voices[voice].set(\pitch, msg[2]);
		});

		this.addCommand("spread", "if", { arg msg;
			var voice = msg[1] - 1;
			voices[voice].set(\spread, msg[2]);
		});

		this.addCommand("volume", "if", { arg msg;
			var voice = msg[1] - 1;
			voices[voice].set(\gain, msg[2]);
		});

		this.addCommand("envscale", "if", { arg msg;
			var voice = msg[1] - 1;
			voices[voice].set(\envscale, msg[2]);
		});
		
		this.addCommand("startRecord", "ii", { arg msg;
    	recordToBuf(msg[0], msg[1]);
    });
    
    
    this.addCommand("stopRecord", "", { arg msg;
    	stopRecord(msg[0], msg[1]);
    });

		nvoices.do({ arg i;
			this.addPoll(("phase_" ++ (i+1)).asSymbol, {
				var val = phases[i].getSynchronous;
				val
			});

			this.addPoll(("level_" ++ (i+1)).asSymbol, {
				var val = levels[i].getSynchronous;
				val
			});
		});

		seek_tasks = Array.fill(nvoices, { arg i;
			Routine {}
		});
		

	}

	free {
	  // free 32 sines
		synth.do({ |syn| syn.free; });
		// free glut
		voices.do({ arg voice; voice.free; });
		phases.do({ arg bus; bus.free; });
		levels.do({ arg bus; bus.free; });
		buffers.do({ arg b; b.free; });
		effect.free;
		mixBus.free;
	}
}