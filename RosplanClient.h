#include "ros/ros.h"

#include "std_srvs/Empty.h"



#ifndef rosplan_client
#define rosplan_client

/**
 * This file contains an interface to the RosplanClient.
 */
namespace KCL_rosplan {

	class RosplanClient
	{
	private:

		ros::NodeHandle* node_handle;

	public:

		RosplanClient(ros::NodeHandle& nh);
		virtual ~RosplanClient();
        
        bool execute_framework(std_srvs::Empty::Request &req, std_srvs::Empty::Response &res);
		
	};

} // close namespace

#endif
