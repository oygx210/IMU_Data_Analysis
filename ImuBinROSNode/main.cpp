/**
 * @file main.cpp
 * Entry point for the node iPhins
 */

#include "imubin_node.h"

int
main(int argc, char **argv)
{
  ros::init(argc, argv, "iphins_imubin", ros::init_options::NoRosout);

  IMUBINNode node;
  node.Run();

  exit(EXIT_SUCCESS);
}
