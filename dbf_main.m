% cleanup
clear all
close all
pause on

% setup the world
worldWidth = 40;
worldHeight = 40;
% create the world
world = World(worldWidth, worldHeight)

% @NOTE current array configuration does not consider real limits on digital
%       sampling frequency (DDC simulation performed in future iteration)
% setup the array for the VHF 2m amateur radio band (144-148Mhz)
arrayWavelength = 2.05337; % 146Mhz center of band
% @TODO fix bug — array only works with even-numbered elements
arrayNumSensors = 8; % sensors/receivers
arraySpacing = .5; % meters between each receiver in linear array
arrayPoseX = world.width/2; % center X (m)
arrayPoseY = world.height/2; % center Y (m)
arrayPoseT = 0; % parallel to X (rads)
arrayPose = Pose(arrayPoseX, arrayPoseY, arrayPoseT);
nyquistFs = 148e6 * 2; % set nyquist at top of the band (exactly 2x b/c not
                       % sampling AT nyquist)
arrayFs = nyquistFs * 10; % sample at 10x nyquist
% create the array
array = Array(arrayWavelength, arrayNumSensors, arraySpacing, arrayPose, arrayFs)

% one degree in radians
degRad = 2*pi/360;

% update the array in the world, then re-draw the world
for i=1:50
  world.updateArray(array);
  world.drawTo(1);
  pause(.02);
  % move it
  array.pose.x = array.pose.x - .2;
  array.pose.y = array.pose.y + .2;
  % spin it
  array.pose.theta = array.pose.theta + 10*degRad;
  % bop it
  array.spacing = array.spacing + .03;
end
