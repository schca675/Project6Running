%This is a comment

clear all
close all

g = 9.81;
l0 = 1;
m = 70;
k = 10000;
steps = 100; % Walking steps, physically.
angleinitdegree = -21; % starting angle
angleenddegree = 18; % when our angle passes this angle we pass from one leg to the other
angleinit = (angleinitdegree/180)*pi;
angleend = (angleenddegree/180)*pi;

% Walking, angle against time: x = theta
% Differential equations:
f = @(t,x) [x(3); x(4); g*sin(x(1))/x(2)-2*x(3)*x(4)/x(2); x(3)^2*x(2) - g*cos(x(1)) - k*(x(2)-l0)/m];

% Interval over which to solve x
tspan = [0 10];

% Initial state
x0 = [angleinit;l0;5;0];
x_cordinterm = [];
y_cordinterm = [];
xfinal=0;
yfinal=x0(2)*cos(x0(1));
ttot = [];

% Determine t, x(t)
 for i = 1:steps
    [t,x] = ode45(f, tspan, x0)
    for j = 1:length(t)
        x_cordinterm = [x_cordinterm; xfinal-(-x(j,2)*sin(x(j,1))+x(j,2)*sin(x(1,1)))];
        y_cordinterm = [y_cordinterm; yfinal+(x(j,2)*cos(x(j,1))-x(j,2)*cos(x(1,1)))];
    end
%     newstartangle = min(find((x(:,1)>angleend)));
    floating = [];
    for j = 1:length(t)
        floating = [floating (y_cordinterm(j) > x(j,2)*cos(x(j,1)))];
    end
    newtindex = min(find(floating==1));
    if ~isempty(newtindex)
        newtspan = [0 t(newtindex)];
        [t,x] = ode45(f,newtspan,x0);
        floating = [];
        for j = 1:length(t)
            floating = [floating (y_cordinterm(j) > x(j,2)*cos(x(j,1)))];
        end
        newtindex = min(find(floating==1));
        if ~isempty(ttot)
            ttot = [ttot; ttot(end)+t(1:newtindex-1)];
        else
            ttot = [t(1:newtindex-1)];
        end
        for j = 1:(newtindex-1)
        end
    end
%     if ~isempty(newx)
%         newtspan = [0 t(newx)];
%         [t,x] = ode45(f, newtspan, x0);
%         newx = min(find((x(:,1)>angleend)));
%         if ~isempty(ttot)
%             ttot = [ttot; ttot(end)+t(1:newx-1)];
%         else
%             ttot = [t(1:newx-1)];
%         end
%         for j = 1:(newx-1)
%             x_cord = [x_cord; xfinal-(-l*sin(x(j,1))+l*sin(x(1,1)))];
%             y_cord = [y_cord; yfinal+(l*cos(x(j,1))-l*cos(x(1,1)))];
%         end
%         x0 = [angleinit,x(newx-1,2)];
%         xfinal = x_cord(end);
%         yfinal = y_cord(end);
%     else
%         ttot=t;
%         x_cord = (l*sin(x(:,1))-l*sin(x(1,1)));
%         y_cord = (l*cos(x(:,1))-l*cos(x(1,1)));
%     end
 end

% Plot x1, x2 and x3 against time
figure('Name', 'x against y')
plot(x_cordinterm,y_cordinterm)
legend('movement')
xlabel('x')
ylabel('y')

% Plot x and y against time
figure('Name', 'x and y against time')
plot(ttot, x_cordinterm,ttot, y_cordinterm)
legend('x', 'y')
xlabel('t')
ylabel('m')

% --------------------------------------------------------