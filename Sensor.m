classdef Sensor < handle
    % light class to hold array sensor info

    properties
        % public, required constructor params
        x
        y
    end

    methods
        function this = Sensor(x,y)
            % allow no-arg constructor calls for empty initialization
            if (nargin > 0)
              this.x = x;
              this.y = y;
            end
        end
    end
end
