///
///@file phins_node.h
/// Header file for the class PhinsNode.
///
///@date 25/06/21
///@version 1.0
///@copyright (c) Ifremer
///
///@author Mathis PROVOST (Seatech/Ifremer)
///

#ifndef IFRDRIVERS_PHINS_IMUBIN_H_
#define IFRDRIVERS_PHINS_IMUBIN_H_

#include <ifr_msgs/PhinsData.h>
#include <ifr_ros/alarm.h>
#include <ifr_ros/interface_node_2.h>
#include <ifr_ros/topic.h>

///
/// Class <b>PhinsNode</b>.
/// This node creates the interface
/// between a PHINS and ROS world.
///
class IMUBINNode : public ifr_ros::InterfaceNode2
{
public:
  ///
  /// Constructor.
  ///
  IMUBINNode();

  ///
  /// Destructor.
  ///
  ~IMUBINNode();

protected:
  ///
  /// Initialization Stage
  ///@see InterfaceNode
  ///
  bool Initialize();

  bool OnNewFrame(ifr::FramePtr& _frame);

private:
  // Publisher
  //-------------------------
  ifr_ros::Topic<ifr_msgs::PhinsData> m_data;
  std::string                         m_frame_id;
};

#endif  // IFRDRIVERS_PHINS_IMUBIN_H_
