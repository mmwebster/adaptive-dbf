classdef World < handle
  % A linear receiver array of arbitrary count, spacing,

  properties
    % public, required constructor params
    width % in meters
    height % in meters
  end

  properties (Access = private)
    arrayIsDef = false; % is array defined or not
    array % possibly undefined array
  end

  methods
    function this = World(width, height)
        this.width = width;
        this.height = height;
    end

    % re-draw the world, with any changes
    % @param figId The figure to draw to
    function drawTo(this, figId)
      % focus on / open fig
      figure(figId);
      % clear previous contents
      clf;

      hold on;

      % plot all defined objects
      if (this.arrayIsDef)
        % add array members
        % prepare x/y values for all sensors
        x_vals = zeros(1,this.array.numSensors);
        y_vals = zeros(1,this.array.numSensors);
        % iterate through sensors
        i = 1;
        for sensor=this.array.sensors
          x_vals(i) = sensor.x;
          y_vals(i) = sensor.y;
          i = i + 1;
        end
        plot(x_vals,y_vals,'x');
      end

      hold off;

      % set dims
      axis([0 this.width 0 this.height]);
    end

    % update an array drawn on the map
    % @note no pre-condition on already already having been drawn
    % @note world only supports one array at a time
    function updateArray(this, array)
        this.arrayIsDef = true
        this.array = array;
    end
  end
end
