function [x] = euler(f,h,a,b,x0)
measurements = round((b-a)/h);
t = [];
for i = 1:measurements
    t = [t; a + h*i];
end
x = [];
x(1,1) = x0(1);
x(1,2) = x0(2);
for t=1:measurements
    x = [x ; x(end) + h*f(x(end))];
end
plot(x,t);
end

