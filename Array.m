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
          % vector colinear with array, in direction of highest index sensor,
          % of magnitude 1-sensor spacing
          v = this.getBasis();

          % +/- offset of sensor steps from array centroid
          % start offset assuming odd number of sensors
          offsetFromCentroid = this.getOffsetFromCentroid(sensorIndex);

          % get vector from centroid to sensor
          centroidToSensor = offsetFromCentroid * v;

          % set return value using abs + relative positions
          sensorAbsX = centroidToSensor(1) + this.pose.x;
          sensorAbsY = centroidToSensor(2) + this.pose.y;
          s = Sensor(sensorAbsX, sensorAbsY);
        end

        % @brief Returns a vector that's a basis for the array-line, with
        %        length of 1 spacing step, allowing multiplication by discrete
        %        sensors steps forward or backward to get position relative to
        %        array centroid
        function v = getBasis(this)
          % get relative position, one sensor down the straight array
          deltaX = cos(this.pose.theta) * this.spacing;
          deltaY = sin(this.pose.theta) * this.spacing;
          % return it
          v = [deltaX, deltaY];
        end

        % @brief Returns the number of sensor-spacing steps from centroid to a
        %        sensor index (with 0 being the first in the array)
        function o = getOffsetFromCentroid(this, sensorIndex)
          % +/- offset of sensor steps from array centroid
          % start offset assuming odd number of sensors
          o = sensorIndex - (this.numSensors - 1)/2;
          % then add or subtract .5 sensor spacing if even (if before or
          % after centroid)
          if mod(this.numSensors, 2) == 0
            if (sensorIndex < (this.numSensors - 1)/2)
              % even and before centroid
              o = o + .5;
            else
              % even and after centroid
              o = o - .5;
            end
          end
        end
    end
end
