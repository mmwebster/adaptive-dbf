classdef Array < handle
    % A linear receiver array of arbitrary count, spacing,
    % pose (from centroid), wave propogation speed,
    % wavelength (for target center freq.), sampling frequency,
    % and dynamically-applied array complex weights

    properties
        % public, required constructor params
        wavelength
        numSensors
        spacing
        pose % class containing position (m) and orientation (rad) members
        fs % sampling frequency (hz)
    end

    properties (Constant)
        c=3e8;
    end

    properties (GetAccess=private)
        weights % amplitude and phase modifier for each receiver
    end

    methods
        function this = Array(wavelength, numSensors, spacing, pose, fs)
            this.wavelength = wavelength;
            this.numSensors = numSensors;
            this.spacing = spacing;
            this.pose = pose;
            this.fs = fs;
        end

        % return vector of Sensor objects with x/y positions
        function sensors = sensors(this)
          % init empty array of sensor objects
          sensors(1,this.numSensors) = Sensor();
          % populate all sensor objects
          for i=1:this.numSensors
            sensors(i) = this.makeSensor(i - 1);
          end
        end

        % calculate the current x and y position and return in Sensor
        % @param sensorIndex is 0-based index
        function s = makeSensor(this, sensorIndex)
          % assume 0 rad rotation from x-axis, for now
          % unit vector colinear with array, in direction of highest index sensor
          u = this.spacing; % scalar until supporting rotation
          % +/- offset of sensor steps from array centroid
          % start offset assuming odd number of sensors
          offsetFromCentroid = sensorIndex - (this.numSensors - 1)/2;
          % then add or subtract .5 sensor spacing if even (if before or
          % after centroid)
          if mod(this.numSensors, 2) == 0
            if (sensorIndex < (this.numSensors - 1)/2)
              % even and before centroid
              offsetFromCentroid = offsetFromCentroid + .5;
            else
              % even and after centroid
              offsetFromCentroid = offsetFromCentroid - .5;
            end
          end
          % get vector from centroid to sensor (currently one-dim until rot.)
          centroidToSensor = offsetFromCentroid * u;
          % set return value (y is independent of sensor until the array's
          % orientation can be changed)
          s = Sensor(centroidToSensor + this.pose.x, this.pose.y);
        end
    end
end
