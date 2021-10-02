# TanmayeeGujar.github.io
##Fuzzy Controller Project for CSE 454 
This Fuzzy controller works to make the agent (a robot with dimension 1x1 units) reach the user specified target, by using Fuzzy Logic. The space this robot is moving in can be considered to be a 20x20 grid. The user input is mapped to fuzzy membership functions of distance and theta, are then a rule-based approach is used to defuzzify the inputs and give out crisp output values in terms of the speed and change in angle. This output is then used in the next iteration of the controller, and so on, until the robot reaches the target. Each iteration has a timestamp of 100 ms.
To run the program:
1. Download and run the FuzzyController.m file in MATLAB online account
2. In the command window, the following prompts for user input will appear:
a. “Enter x coordinate between -10 and 10 of current location:”
Enter a value between -10 and 10, and hit Enter
b. “Enter x coordinate between -10 and 10 of current location:”
Enter a value between -10 and 10, and hit Enter
c. “Enter angle theta between -45 and 90 degrees between direction of robot and destination:”
Enter a value between -45 and 90 and hit Enter
d. “Enter distance between 0 to 20 to target:”
Enter a value between 0 and 20 and hit Enter

The program should then execute, outputting the required values each iteration till the target is reached. Once reached, it should display the message "Target reached!"

