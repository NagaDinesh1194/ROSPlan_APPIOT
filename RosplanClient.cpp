/*
Author: Naga Dinesh
Date: 13/2/2019
Explanation:  This node is created to make the service call to the necessary node of the ROSPLan \
              framework. It automate the process of generating the problem, generate the plan, parse it and dispatch it. 
              Other node might as well this funtionality by makinng a service call to "/rosplanClient/execute_framework".
*/
#include "rosplan_planning_system/NagsRosplanClient/NagsRosplanClient.h"
#include "rosplan_planning_system/ProblemGeneration/ProblemInterface.h"
#include "rosplan_planning_system/PlanDispatch/EsterelPlanDispatcher.h"
#include <fstream>
#include <sstream>
#include <string>
#include <ctime>
#include <string>
#include <streambuf>
#include "ros/ros.h"
#include "rosplan_knowledge_msgs/KnowledgeItem.h"
#include "rosplan_knowledge_msgs/KnowledgeUpdateServiceArray.h"
#include <thread> 
#include "std_msgs/String.h"
#include "std_srvs/Empty.h"

class execution_server
{
public:
  ros::ServiceClient problem_client;
  ros::ServiceClient planner_client;
  ros::ServiceClient parsing_client;
  ros::ServiceClient dispatch_client;
  std_srvs::Empty srv;
  rosplan_dispatch_msgs::DispatchService dsrv;
  bool execute_framework(std_srvs::Empty::Request &req, std_srvs::Empty::Response &res);
};

bool problem_interface_client_function(ros::ServiceClient client, std_srvs::Empty srv)
    {
      ROS_INFO("Inside problem_interface_client_function");
      if(client.call(srv))
      //ROS_INFO("Nags: %s",srv.response);
      return true;
    }

// Planner interface service calling function.
bool planner_interface_client_function(ros::ServiceClient client, std_srvs::Empty srv)
    {
      ROS_INFO("Inside planner_interface_client_function");
      if(client.call(srv))
      return true;
    }
// Parsing interface service calling function.
bool parsing_interface_client_function(ros::ServiceClient client, std_srvs::Empty srv)
    {
      ROS_INFO("Inside parsing_interface_client_function");
      if(client.call(srv))
      return true;
    }
// Dispatcher interface service calling function.
bool dispatcher_interface_client_function(ros::ServiceClient client, rosplan_dispatch_msgs::DispatchService srv)
    {
      ROS_INFO("Inside dispatcher_interface_client_function");
      if(client.call(srv))
      return true;
    }
//Knowledgebase update calling function
bool knowledge_base_client_function(ros::ServiceClient client, rosplan_knowledge_msgs::KnowledgeUpdateServiceArray ksrv)
    {
       
        
        rosplan_knowledge_msgs::KnowledgeItem item;
				item.knowledge_type = rosplan_knowledge_msgs::KnowledgeItem::FACT;
				item.attribute_name = "truck-healthy";
				item.values.clear();
				diagnostic_msgs::KeyValue pair;
				
				pair.key = "t";
				pair.value = "t0001";
				item.values.push_back(pair);
        
        ksrv.request.knowledge.push_back(item);
				ksrv.request.update_type.push_back(rosplan_knowledge_msgs::KnowledgeUpdateServiceArray::Request::REMOVE_KNOWLEDGE);
				ROS_INFO("Inside knowledge_base_client_function");
			  if(client.call(ksrv))
          return true;
    }

//service funstion to execute the whole framework    
bool execution_server::execute_framework(std_srvs::Empty::Request &req, std_srvs::Empty::Response &res){


  double begin = ros::Time::now().toSec();
  problem_interface_client_function(this->problem_client,this->srv);
  sleep(0.5);
  planner_interface_client_function(this->planner_client,this->srv);
  sleep(0.5);
  parsing_interface_client_function(this->parsing_client,this->srv);
  sleep(0.5);
  dispatcher_interface_client_function(this->dispatch_client, this->dsrv);
  double end = ros::Time::now().toSec();
  double timetaken = end - begin;
  ROS_INFO(" ROSPLANCLIENT Time taken for the execution is %lf", timetaken);
  
}


int main(int argc, char **argv)
{          
          ros::init(argc, argv, "nags_rosplan_client");
          ros::NodeHandle n("~");
          

          //creating the client object for call their respective servers
          ros::ServiceClient problem_interface_client = n.serviceClient<std_srvs::Empty>("/rosplan_problem_interface/problem_generation_server");
          ros::ServiceClient planner_interface_client = n.serviceClient<std_srvs::Empty>("/rosplan_planner_interface/planning_server");
          ros::ServiceClient parsing_interface_client = n.serviceClient<std_srvs::Empty>("/rosplan_parsing_interface/parse_plan");
          ros::ServiceClient dispatcher_interface_client = n.serviceClient<rosplan_dispatch_msgs::DispatchService>("/rosplan_plan_dispatcher/dispatch_plan");
          ros::ServiceClient knowledge_update_client = n.serviceClient<rosplan_knowledge_msgs::KnowledgeUpdateServiceArray>("/rosplan_knowledge_base/update");
          
          //creating the service messages type for the services
          std_srvs::Empty srv;
          rosplan_dispatch_msgs::DispatchService dsrv;
          rosplan_knowledge_msgs::KnowledgeUpdateServiceArray ksrv;
          
          //creting a object the execution_server class
          execution_server a;
          a.problem_client = problem_interface_client;
          a.planner_client = planner_interface_client;
          a.parsing_client = parsing_interface_client;
          a.dispatch_client = dispatcher_interface_client;
          a.srv = srv;
          a.dsrv = dsrv; 
          ROS_INFO(" NAGS: (%s) Ready to Receive", ros::this_node::getName().c_str());
          
          //advertising a execute framework from this node
          ros::ServiceServer ss = n.advertiseService("execute_framework", &execution_server::execute_framework, &a);
          
  ros::spin();
  return 0;
}
