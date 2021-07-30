/**
 * @file imubin_node.cpp
 * Implementation of the imubinNode class.
 */

#include "imubin_node.h"

// fichier armadillo sans extension .h
#include <armadillo>
#define ARMA_USE_BOOST
#define ARMA_USE_BOOST_DATE
#define ARMA_NO_DEBUG

#include <ifr_comm/checksum.h>
#include <ifr_comm/udp_interface.h>
#include <ifr_msgs/topic_defs.h>
#include <ifr_utils/binary_helper.h>
#include <ifr_utils/math.h>
#include <ifr_utils/units/angle.h>
#include <ifr_utils/units/speed.h>

#include "imubin.h"

inline static unsigned char
ComputeChecksum(void* _start, void* _end)
{
  unsigned int   cs     = 0;
  unsigned char* cursor = static_cast<unsigned char*>(_start);
  unsigned char* end    = static_cast<unsigned char*>(_end);

  while(cursor < end)
    cs += *cursor++;

  return static_cast<unsigned char>(cs);
}

IMUBINNode::IMUBINNode()
    : ifr_ros::InterfaceNode2()
{
}

IMUBINNode::~IMUBINNode()
{
}

bool
IMUBINNode::Initialize()
{
  ros::NodeHandle nh_private("~");
  ros::NodeHandle nh_imubin("phins");

  double      timeout;
  std::string ip_address;
  int         port_data;

  // Get interfaces configuration
  nh_imubin.param<std::string>("ip_address", ip_address, "");
  nh_imubin.param<int>("outputs/port_imubin", port_data, 0);
  nh_private.param<double>("timeout", timeout, 3);
  nh_private.param<std::string>("frame_id", m_frame_id, "imubin");

  // Advertise
  m_data.Advertise(nh_private, "data");
  m_data->header.frame_id = m_frame_id;

  ifr::UdpInterface* intf = new ifr::UdpInterface(ip_address, port_data, 0, ifr::UdpInterface::MODE_IN);
  intf->set_timeout_ms(timeout * 1000);
  setDefaultInterface(intf);

  return InterfaceNode2::Initialize();
}

bool
IMUBINNode::OnNewFrame(ifr::FramePtr& _frame)
{
  // Hold the frame timestamp
  ros::Time received_time = ros::Time::now();

  // Parse frame
  IMUBINFrame* imu_frame = (IMUBINFrame*)_frame->data();

  if(true)
  {
    ifr_msgs::PhinsData* msg = m_data.msg();

    msg->rotation_rate.z = ifr::BinaryHelper::SwapEndian(imu_frame->delta_rot_xv3);
    msg->rotation_rate.y = ifr::BinaryHelper::SwapEndian(imu_frame->delta_rot_xv2);
    msg->rotation_rate.x = ifr::BinaryHelper::SwapEndian(imu_frame->delta_rot_xv1);

    msg->velocity.z = ifr::BinaryHelper::SwapEndian(imu_frame->delta_vel_xv3);
    msg->velocity.y = ifr::BinaryHelper::SwapEndian(imu_frame->delta_vel_xv2);
    msg->velocity.x = ifr::BinaryHelper::SwapEndian(imu_frame->delta_vel_xv1);

    // Timestamp and publish
    msg->header.stamp = received_time;

    if(!ifr::isNaN(msg->velocity.x))
      m_data.Publish();
    else
      return false;

    return true;
  }
  return false;
}
