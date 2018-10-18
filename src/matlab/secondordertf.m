function tfSecond = secondordertf(u,w,t)
% SECONDORDERTF  Second Order Model Parameters Identification.
%   tfSecond = SECONDORDERTF(u,w,t) Generate the best fit Second order model
%   for given input,output data.
%
%   See also TF, DIFF.
    dt = diff(t,1);                 % dT = Ti - Ti-1
    dW = diff(w,1)./dt;             % dW = Wi - Wi-1
    ddW = diff(dW,1)./dt(2:end);    % ddW = dWi - dWi-1

    B = [ddW(1:end) dW(1:end-1) w(1:end-2)];  % ignore first point
    paramSecond = (B'*B)\(B'*(u(3:end)));   % pseudo inverse

    tfSecond = tf(1,[paramSecond(1) paramSecond(2) paramSecond(3)]);
end
