function [ deltaMinus, deltaPlus] = deadzoneindetify( u,v,t )
%DEADZONEINDETIFY Dead Zone Parameters Identification
    %% Dead Zone Parameters Identification
    isZero = ( u <= 0.1) & ( u >= -0.1) & ( v ~= 0 ); % Find Zeros
    % Start DeadZone
    deltaMinus = min(v(isZero))
    % End DeadZone
    deltaPlus = max(v(isZero))
end

