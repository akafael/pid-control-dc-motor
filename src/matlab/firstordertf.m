function tfFirst = firstordertf(u,w,t)
% FIRSTORDERTF  First Order Model Parameters Identification.
%   tfFirst = FIRSTORDERTF(u,w,t) Generate the best fit first order model
%   for given input,output data.
%
%   See also TF.
    dT = t(2:end) - t(1:(end-1));          % dT = Ti - Ti-1
    dW = (w(2:end) - w(1:(end-1)))./dT;    % dW = Wi - Wi-1

    A = [dW(1:end)  w(2:end)];             % ignore first point
    tmp = (A'*A);
    tmp2 = (A'*(u(2:end)));
    paramFirst = (A'*A)\(A'*(u(2:end)));   % pseudo inverse

    tfFirst = tf(1,[paramFirst(1) paramFirst(2)]);
end
