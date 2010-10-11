/* $Id: M16c62pAdcConfig.nc,v 1.1 2009-09-07 14:12:25 r-studio Exp $
 * Copyright (c) 2005 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

#include "M16c62pAdc.h"

/**
 * Clients of higher level must provide this interface to
 * specify which channel to sample, and with what parameters.
 *
 * @author Fan Zang <fanzha@ltu.se>
 */
interface M16c62pAdcConfig {
  /**
   * Obtain channel.
   * @return The A/D channel to use. Must be one of the M16c62p_ADC_CHL_xxx
   *    values from M16c62pAdc.h.
   */
  async command uint8_t getChannel();

  /**
   * Obtain precision setting.
   * @return The number of bits, valid values are 8 (M16c62p_ADC_PRECISION_8BIT)
   *   or 10 (M16c62p_ADC_PRECISION_10BIT)
   */
  async command uint8_t getPrecision();

  /**
   * Obtain prescaler value.
   * @return The prescaler value to use. Must be one of the 
   *   M16c62p_ADC_PRESCALE_xxx values from M16c62pAdc.h.
   */
  async command uint8_t getPrescaler();
  
  
}
