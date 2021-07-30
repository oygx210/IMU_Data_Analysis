#ifndef PHINS_IMUBIN_H
#define PHINS_IMUBIN_H

/**
 * @file phins_node.cpp
 * Declaration of variables
 */

#pragma pack(push)
#pragma pack(1)
typedef struct
{
  uint8_t  header;
  uint32_t time_stamp;    /**< Unsigned 32 bit interger. LSB= 50e-6s */
  float    delta_rot_xv1; /**< IEEE float 32 bits in radian */
  float    delta_rot_xv2; /**< IEEE float 32 bits in radian */
  float    delta_rot_xv3; /**< IEEE float 32 bits in radian */
  float    delta_vel_xv1; /**< IEEE float 32 bits in m/s */
  float    delta_vel_xv2; /**< IEEE float 32 bits in m/s */
  float    delta_vel_xv3; /**< IEEE float 32 bits in m/s */
  uint32_t status;        /**< Unsigned 32 bit inter. INS sensor status */
  int16_t  temperature;   /**< Signed 16 bit integer, x10 Kelvin */
  uint16_t checksum;      /**< Unsigned 16 bit integer*/

} IMUBINFrame;
#pragma pack(pop)

#endif  // PHINS_IMUBIN_H
