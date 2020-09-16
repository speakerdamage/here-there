# here-there
norns listens to sound input for the first ~30 seconds and then plays back the following: 
 (a) up to 32 sine waves with random parameters, randomly spaced in the stereo field, in [currently] two modes: "chords" and "drones"  
 (b) two separate softcut buffers (l/r, based on inputs), at random positions [currently] in time with the sine actions 
 (c) [in progress] granular buffer with random parameters 

k2: change sine mode  
k1(hold) + k2: reset softcut buffer   
k3: clear sines and begin polling again 
k1(hold) + k3: randomize granular parameters 

TODO: 
UI (easier mixing of 3 sources)
