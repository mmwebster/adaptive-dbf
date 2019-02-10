classdef Array
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
        %function obj = Array(inputArg1,inputArg2)
        function obj = Array(wavelength, numSensors, spacing, pose, fs)
            obj.wavelength = wavelength;
            obj.numSensors = numSensors;
            obj.spacing = spacing;
            obj.pose = pose;
            obj.fs = fs;
        end

        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end
