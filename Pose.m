classdef Pose < handle
    % Store the position and orientation of something

    properties
        % public, required constructor params
        % currently 2-D
        x % horizontal meters from origin
        y % vertical meters from origin
        theta % radians from parallel to x-axis
    end

    methods
        function obj = Pose(x, y, theta)
            obj.x = x;
            obj.y = y;
            obj.theta = theta;
        end
    end
end
