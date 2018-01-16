clear all
close all
format long e

g = 9.81;
l = 1;
steps = 10; % Walking steps, physically.
angleinitdegree = -21; % starting angle
angleenddegree = 18; % when our angle passes this angle we pass from one leg to the other
angleinit = (angleinitdegree/180)*pi;
angleend = (angleenddegree/180)*pi;
angle_init_velocity = 5; % Initial angle velocity.

% Walking, angle against time: x = theta
% Differential equations:
f = @(t,x) [x(2); g*sin(x(1))/l];

% Interval over which to solve x
tspan = [0 10];

% Initial state
x0 = [angleinit; 10];
x_cord = [];
y_cord = [];
xfinal=0;
yfinal=l*cos(x0(1));
ttot = [];

% Determine t, x(t)
for i = 1:steps
    [t,x] = ode45(f, tspan, x0);
    newx = min(find((x(:,1)>angleend)));    
    if ~isempty(newx)
        newtspan = [0 t(newx)];
        [t,x] = ode45(f, newtspan, x0);
        newx = min(find((x(:,1)>angleend)));
        if ~isempty(ttot)
            ttot = [ttot; ttot(end)+t(1:newx-1)];
        else
            ttot = [t(1:newx-1)];
        end
        for j = 1:(newx-1)
            x_cord = [x_cord; xfinal+(l*sin(x(j,1))-l*sin(x(1,1)))];
            y_cord = [y_cord; yfinal+(l*cos(x(j,1))-l*cos(x(1,1)))];
        end
        x0 = [angleinit,x(newx-1,2)];
        xfinal = x_cord(end);
        yfinal = y_cord(end);
    else
        ttot=t;
        x_cord = (l*sin(x(:,1))-l*sin(x(1,1)));
        y_cord = yfinal+(l*cos(x(:,1))-l*cos(x(1,1)));
    end
end

% Plot x1, x2 and x3 against time
figure('Name', 'x against y')
plot(x_cord,y_cord)
legend('movement')
xlabel('x')
ylabel('y')

% Plot x and y against time
figure('Name', 'x and y against time')
plot(ttot, x_cord,ttot, y_cord)
legend('x', 'y')
xlabel('t')
ylabel('m')

% --------------------------------------------------------




