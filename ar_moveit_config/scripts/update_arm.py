#!/usr/bin/env python

import rospy
from sensor_msgs.msg import JointState
from std_msgs.msg import Header
import time

def update_arm_position():
    # Initialize the ROS node
    rospy.init_node('update_arm', anonymous=True)
    
    # Create a publisher for JointState messages
    pub = rospy.Publisher('/joint_states', JointState, queue_size=10)
    
    # Set the rate to 10Hz
    rate = rospy.Rate(10)
    
    while not rospy.is_shutdown():
        # Create a JointState message
        joint_state = JointState()
        joint_state.header = Header()
        joint_state.header.stamp = rospy.Time.now()
        joint_state.name = ['joint_1', 'joint_2', 'joint_3', 'joint_4', 'joint_5', 'joint_6']
        joint_state.position = [45.0, 0.0, 0.0, 0.0, 0.0, 0.0]  # Update these positions as needed
        
        # Publish the joint state
        pub.publish(joint_state)
        
        # Log the current joint positions
        rospy.loginfo(f'Updated joint positions: {joint_state.position}')
        
        # Sleep to maintain the loop rate
        rate.sleep()

if __name__ == '__main__':
    try:
        update_arm_position()
    except rospy.ROSInterruptException:
        pass
