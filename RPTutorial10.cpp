#include "rosplan_action_interface/RPTutorial10.h"

/* The implementation of RPTutorial.h */
namespace KCL_rosplan {

	/* constructor */
	RPTutorialInterface::RPTutorialInterface(ros::NodeHandle &nh) {
		// perform setup

	}

	
	/* action dispatch callback */
	bool RPTutorialInterface::concreteCallback(const rosplan_dispatch_msgs::ActionDispatch::ConstPtr& msg) {

		// The action implementation goes here.
		ros::NodeHandle nh;
		boost::shared_ptr<std_msgs::String const> sharedEdge;
  		std_msgs::String edge;
		// complete the action
		appiot_action_pub.publish(msg);
		double begin = ros::Time::now().toSec();
		ROS_INFO("Before waiting for the message on /ros_in");
  		sharedEdge = ros::topic::waitForMessage<std_msgs::String>("/ros_in",nh);
  		if(sharedEdge != NULL){
    	edge = *sharedEdge;
  		}
		double end = ros::Time::now().toSec();
  		double timetaken = end - begin;
  		
		ROS_INFO(" NAGS (%s) Time taken get response from API call to APPIOT is: %lf",params.name.c_str(), timetaken);  
		
		return true;
	}
} // close namespace

	/*-------------*/
	/* Main method */
	/*-------------*/

	int main(int argc, char **argv) {
		
		ros::init(argc, argv, "rosplan_tutorial_action", ros::init_options::AnonymousName);
		ros::NodeHandle nh("~");

		// create PDDL action subscriber
		KCL_rosplan::RPTutorialInterface rpti(nh);

		rpti.runActionInterface();
		

		return 0;
	}
