function [ y ] = inversefn( x )
%INVERSEFN Summary of this function goes here
%   Detailed explanation goes here

    if(x>0)
        x = x + 0.5635;
    elseif(x<0)
        x = x - 0.5296;
    else
        x = 0;
    end
    y = x;
end

