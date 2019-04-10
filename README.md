
Rosplan and APPIOT integration

1. Before using this repository, install ROS from http://wiki.ros.org/kinetic/Installation/Ubuntu, and ROSPlan framework from 
https://github.com/KCL-Planning/ROSPlan.

2. Complete tutorials 1 through 10 at http://kcl-planning.github.io/ROSPlan/documentation/ because we will be using the files      created in those.

3. Clone or download this repository.
    Place the following files in the following directories
    
      - The Domain and Problem .pddl files to /home/nags/ROSPlan/src/rosplan/rosplan_demos. These files define 
        the domain and problem in PDDL language.
      
      - Make directory here /home/nags/ROSPlan/src/rosplan/rosplan_planning_system called "RosplanClient" 
        and place the file "RosplanClient.cpp" in it. This file creates a node, which make service calls 
        to other nodes in ROSPlan framwork.
        
      - Make directory here /home/nags/ROSPlan/src/rosplan/rosplan_planning_system/include/rosplan_planning_system called
        "RosplanClient" and place the file "RosplanClient.h" in it.
        
      - We will be be using either the "asi.launch" or "logistics.launch" at a time. Copy them to the ROSPlan workspace.
      
      - Replace the file RPTutorial10.cpp and RPActionInterface.cpp in the directory 
        home/nags/ROSPlan/src/rosplan/rosplan_planning_system/src/ActionInterface with the same named files
        in this repository.
        
      - Paste the following "ros::Publisher appiot_action_pub;" in "RPActionInterface.h"
        located at "/home/nags/ROSPlan/src/rosplan/rosplan_planning_system/include/rosplan_action_interface"
        in line number  "49" below "ros::Publisher action_feedback_pub;".
        
      - Next open a terminal and change to the ROSPlan workspace and source the terminal using 
                "source devel/setup.bash"
        command, and then build the project using the command using 
                "catkin build". 
      
      - Place the file "rosplanappiot.py" on Desktop or anywhere in the system. 
        Before runnning this file for the fisrt time, run the following command only once 
                "pip install roslibpy" 
        to install roslibpy. Refer this website for detailed information on it
        https://roslibpy.readthedocs.io/en/latest/index.html


4. Open a terminal and change directory to the ROSPlan workspace created.
       
      - use the following command to source the terminal
                "source devel/setup.bash"
                
      - run the following command to launch the framework for the logistics problem.
                "roslaunch logistics.launch"
      
      - open a second terminal and change to directory, where the "rosplanappiot.py" has been saved.
      
      - run the python script using the following command 
                "python3 rosplanappiot.py"
                
      - Before running the next command please make sure, that the appiot client device is up and runnning.
      
      - open the third terminal, change the directory to ROSPlan workspace and source it using the command
                "source devel/setup.bash"
      
      - Execute the framework using the following command
                "rosservice call rosplanClient/execute_framework" 
            This command, generates a new problem, a new plan, parses the plan and dispactches each action,
            specifically in this order.
 
If all actions have been dispatched and executed completely, you see something like 
    "ROSPLANCLIENT Time taken for the execution is 21.337864" in the terminal where "roslaunch logistics.launch" is running.


              
      
                 

      
