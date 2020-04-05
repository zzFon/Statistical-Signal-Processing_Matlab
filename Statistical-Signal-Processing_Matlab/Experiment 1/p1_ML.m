
% timeline
t = 0:1:301;
% swept-frequency cosine, the target signal
s = chirp(t,0,301,250);
% s = cos(t);
% white noise
n_mean = 0; n_var = 25;
n = n_mean+sqrt(n_var)*randn(1,length(t));

% received signal, with s(t)
x = s+n; disp('test for x(t) = s(t)+n(t):');
% ML detection
left_side = dot(s,s)-2*dot(s,x);
right_side = -2*n_var*log(0.6/0.4);
if left_side < right_side
    result = 1;
    disp('s(t) is detected');
else
    result = 0;
    disp('x(t) does not contain s(t)');
end

figure(1);
subplot(2,1,1);
plot(t,s); xlabel('time / ms'); title('origin signal s');
subplot(2,1,2);
plot(t,x); xlabel('time / ms'); title('recived signal x');

% received signal, without s(t)
x = n; disp('test for x(t) = n(t):');
% ML detection
left_side = dot(s,s)-2*dot(s,x);
right_side = -2*n_var*log(0.6/0.4);
if left_side < right_side
    result = 1;
    disp('s(t) is detected');
else
    result = 0;
    disp('x(t) does not contain s(t)');
end

figure(2);
subplot(2,1,1);
plot(t,0); xlabel('time / ms'); title('origin signal s');
subplot(2,1,2);
plot(t,x); xlabel('time / ms'); title('recived signal x');
