%
% Fuzzy Controller Project
%
% Author: Tanmayee Gujar (tanmayee@buffalo.edu)
% Date: September 2021
% Course: CSE 454
%
% Project Description: This Fuzzy controller works to make the agent (a
% robot with dimension 1*1 units) reach the user specified target, by using Fuzzy Logic. 
% The space this robot is moving in can be considered to be s 20*20 grid. The user
% input is mapped to fuzzy membership functions of distance and theta, are then a
% rule-based approach is used to defuzzify the inputs and give out crisp
% output values in terms of the speed and change in angle. This output is
% then used in the next iteration of the controller, and so on, until the
% robot reaches the target. Each iteration has a timestamp of 100 ms.
%
% User input: Current location (x, y)
% .           Angle to target (theta)
% .           Distance to target (d)
%
% Output each iteration: Speed of robot
% .                      Change in theta

% Creating membership functions (Fuzzifier)

% Membership functions for proximity to target:
% Fuzzy sets:
% 1. f_very_close: When robot is very close to the target
% 2. f_kinda_close: When robot is a little close to the target 
% 3. f_kinda_close_kinda_far: When robot is at moderate proximity from
% target
% 4. f_kinda_far: When robot is a little far from the target
% 5. f_very_far: When robot is very far from the target

% Defining piecewise functions for membership functions for proximity to
% target

% Piecewise functions for f_very_close set:

syms x;
m = 0.65;
f_prox_very_close(x) = -m*x + 1;
f_very_close = piecewise(x<1/m, f_prox_very_close, x>=1/m, 0);
figure(1)
fplot(f_very_close,[0,12], 'DisplayName', "Very close to target")
hold on;
ylim([0 1])

% Piecewise functions for f_kinda_close set:

f_prox_kinda_close_lhs(x) = m*(x-2.5) + 1;
f_prox_kinda_close_rhs(x) = -m*(x-2.5) + 1;
f_kinda_close = piecewise(x<((-1/m)+2.5), 0, ((-1/m)+2.5) <= x < 2.5, f_prox_kinda_close_lhs, 2.5<=x<((1/m)+2.5),f_prox_kinda_close_rhs ,x>= ((1/m)+2.5),0);
fplot(f_kinda_close,[0,12], 'DisplayName', "Kinda close to target");
hold on;

% Piecewise functions for f_kinda_close_kinda_far set:

f_prox_kinda_close_kinda_far_lhs(x) = m*(x-5) + 1;
f_prox_kinda_close_kinda_far_rhs(x) = -m*(x-5) + 1;
f_kinda_close_kinda_far = piecewise(x<((-1/m)+5), 0, ((-1/m)+5) <= x < 5, f_prox_kinda_close_kinda_far_lhs, 5<=x<((1/m)+5),f_prox_kinda_close_kinda_far_rhs ,x>= ((1/m)+5),0);
fplot(f_kinda_close_kinda_far,[0,12], 'DisplayName', "Kinda in the middle");
hold on;

% Piecewise functions for f_kinda_far set:

f_prox_kinda_far_lhs(x) = m*(x-7.5) + 1;
f_prox_kinda_far_rhs(x) = -m*(x-7.5) + 1;
f_kinda_far = piecewise(x<((-1/m)+7.5), 0, ((-1/m)+7.5) <= x < 7.5, f_prox_kinda_far_lhs, 7.5<=x<((1/m)+7.5),f_prox_kinda_far_rhs ,x>= ((1/m)+7.5),0);
fplot(f_kinda_far,[0,12], 'DisplayName', "Kinda far from target");
hold on;

% Piecewise function for f_very_far set:

f_prox_very_far(x) = m*(x - 10) + 1;
f_very_far = piecewise(x<((-1/m)+10), 0, ((-1/m)+10) <= x < 10, f_prox_very_far, x>=10, 1);
fplot(f_very_far,[0,12], 'DisplayName', "Very far from target")
hold on;
xlabel("Distance from target");
ylabel("Membership");
drawnow;
legend;
hold off;

% Membership functions for value of theta: theta defined between [-180,
% 180]
% Fuzzy sets:
% 1. very_neg: when value of theta is negative and large
% 2. kinda_neg: when value of theta is negative but small
% 3. close: when value of theta is close to zero
% 4. kinda_pos: when value of theta is positive but small
% 5. very_pos: when value of theta is positive and large

% Defining piecewise functions for membership functions of theta

% Piecewise function for very_neg set:

n = 1/45;
very_neg_theta(x) = -n*(x+90) + 1 ;
very_neg = piecewise(x<-90, 1, -90<=x<((1/n)-90), very_neg_theta, x>= ((1/n)-90), 0);
figure(2)
fplot(very_neg,[-180,180], 'DisplayName', "Very negative theta");
hold on;

% Piecewise function for kinda_neg set:

kinda_neg_theta_lhs(x) = n*(x+45) + 1;
kinda_neg_theta_rhs(x) = -n*(x) ;
kinda_neg = piecewise(x<((-1/n)-45), 0, ((-1/n)-45) <= x < -45, kinda_neg_theta_lhs,-45<=x<((1/n)-45),kinda_neg_theta_rhs ,x>= ((1/n)-45),0);
fplot(kinda_neg,[-180,180], 'DisplayName', "Kinda negative theta");
hold on;

% Piecewise function for close set:

close_theta_lhs(x) = n*(x) + 1;
close_theta_rhs(x) = -n*(x) + 1;
close = piecewise(x<((-1/n)), 0, ((-1/n)) <= x < 0, close_theta_lhs, 0<=x<((1/n)),close_theta_rhs ,x>= ((1/n)),0);
fplot(close,[-180,180], 'DisplayName', "Theta is close");
hold on;

% Piecewise function for kinda_pos set:

kinda_pos_theta_lhs(x) = n*(x) ;
kinda_pos_theta_rhs(x) = -n*(x-45) + 1;
kinda_pos = piecewise(x<((-1/n)+45), 0, ((-1/n)+45) <= x < 45, kinda_pos_theta_lhs, 45<=x<((1/n)+45),kinda_pos_theta_rhs ,x>= ((1/n)+45),0);
fplot(kinda_pos,[-180,180], 'DisplayName', "Kinda positive theta");
hold on;

% Piecewise function for very_pos set:

very_pos_theta(x) = n*(x - 90) + 1;
very_pos = piecewise(x<((-1/n)+90), 0, ((-1/n)+90) <= x < 90, very_pos_theta, x>=90, 1);
fplot(very_pos, [-180,180], 'DisplayName', "Very positive theta")
hold on;
xlabel("Theta");
ylabel("Membership");
legend;
hold off; 

% Taking user inputs
% Consider our space to be a 20*20 grid
a = input("Enter x co-ordinate between -10 and 10 of current location: ");
b = input("Enter y co-ordinate between -10 and 10 of current location: ");
c = input("Enter angle theta between -45 and 90 degrees between direction of robot and destination: ");
d = input("Enter distance between 0 to 20 to target: ");

x_ = sym(a);
y_ = sym(b);
theta = sym(c);
dist = sym(d);

% finding coordinates of target
% using x = r*sin(theta)
%       y = r*cos(theta)
x_target = double(dist*sin(double(theta*pi()/180)));
y_target = double(dist*cos(double(theta)*pi()/180));

% Setting while loop till robot reaches destination
i = 0;
while floor(dist*50) ~= 0 %dist*50 because accuracy of robot is upto 0.5 units
    % finding memberships of proximity sets
    very_close_memb = (f_very_close(double(dist)));
    kinda_close_memb = (f_kinda_close(double(dist)));
    kinda_mid_memb = (f_kinda_close_kinda_far(double(dist)));
    kinda_far_memb = (f_kinda_far(double(dist)));
    very_far_memb = (f_very_far(double(dist)));
    disp("Distance membership function weights: Very close, Kinda close, Kinda in middle, Kinda far, Very far")
    disp(double(very_far_memb))
    disp(double(kinda_close_memb))
    disp(double(kinda_mid_memb))
    disp(double(kinda_far_memb))
    disp(double(very_far_memb))
    % expert system rules
    speed_very_close = 0.5;
    speed_kinda_close = 2;
    speed_mid = 4;
    speed_kinda_far = 5;
    speed_very_far = 7;
    % defuzzifier for proximity functions
    speed = (very_close_memb*speed_very_close)+(kinda_close_memb*speed_kinda_close)+(kinda_mid_memb*speed_mid)+(kinda_far_memb*speed_kinda_far)+(very_far_memb*speed_very_far);
    disp("Forward velocity:")
    disp(double(speed))
    % finding memberships of theta sets
    very_neg_memb = (very_neg(double(theta)));
    kinda_neg_memb = (kinda_neg(double(theta)));
    close_memb = (close(double(theta)));
    kinda_pos_memb = (kinda_pos(double(theta)));
    very_pos_memb = (very_pos(double(theta)));
    disp("Theta membership function weights: Very negative, Kinda negative, Kinda close, Kinda positive, Very positive")
    disp(double(very_neg_memb))
    disp(double(kinda_neg_memb))
    disp(double(close_memb))
    disp(double(kinda_pos_memb))
    disp(double(very_pos_memb))
    % expert system rules
    change_very_neg = -90;
    change_kinda_neg = -5;
    change_close = 0;
    change_kinda_pos = 5;
    change_very_pos = 90;
    % defuzzifier for change in theta
    change_theta = (very_neg_memb*change_very_neg)+(kinda_neg_memb*change_kinda_neg)+(close_memb*change_close)+(kinda_pos_memb*change_kinda_pos)+(very_pos_memb*change_very_pos);
    disp("Change in theta:")
    disp(double(change_theta))

    % distance travelled this time stamp
    % using distance = speed * time
    dist_covered = speed*0.1; % 100 ms = 0.1 sec

    % getting new coordinates of robot's location
    % new x = old x + distance * sin(theta)
    % new y = old y + distance * cos(theta)
    new_x = x_+double(dist_covered*sin(double(theta)*pi()/180));
    new_y = y_+double(dist_covered*cos(double(theta)*pi()/180));

    % calculating new distance to target
    % using dist = sqrt((x_2-x_1)^2 + (y_2-y_1)^2)
    new_dist = double(sqrt((x_target-new_x)^2 + (y_target-new_y)^2));

    % calculating new theta to target
    % using theta = arctan((x_target-new_x)/(y_target-new_y))
    new_theta = atan((x_target-new_x)/(y_target-new_y))*180/pi();

    % Reassigning input variables for next iteration
    x_ = new_x;
    y_ = new_y;
    theta = new_theta;
    dist = new_dist;
    disp("Iteration #")
    disp(i)
    disp("Distance to target: ")
    disp(floor(dist))
    i = i + 1;
    
    % Repeat loop
end % end of loop

disp("Target reached!")