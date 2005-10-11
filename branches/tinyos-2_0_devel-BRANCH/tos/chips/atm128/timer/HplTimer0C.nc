/// $Id: HplTimer0C.nc,v 1.1.2.1 2005-10-11 22:14:49 idgay Exp $

/**
 * Copyright (c) 2004-2005 Crossbow Technology, Inc.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL CROSSBOW TECHNOLOGY OR ANY OF ITS LICENSORS BE LIABLE TO 
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL 
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CROSSBOW OR ITS LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
 * DAMAGE. 
 *
 * CROSSBOW TECHNOLOGY AND ITS LICENSORS SPECIFICALLY DISCLAIM ALL WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS 
 * ON AN "AS IS" BASIS, AND NEITHER CROSSBOW NOR ANY LICENSOR HAS ANY 
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR 
 * MODIFICATIONS.
 */

/// @author Martin Turon <mturon@xbow.com>

#include <Atm128Timer.h>

module HplTimer0C
{
  provides {
    // 8-bit Timers
    interface HplTimer<uint8_t>   as Timer0;
    interface HplTimerCtrl8       as Timer0Ctrl;
    interface HplCompare<uint8_t> as Compare0;
  }
}
implementation
{
  //=== Read the current timer value. ===================================
  async command uint8_t  Timer0.get() { return TCNT0; }

  //=== Set/clear the current timer value. ==============================
  async command void Timer0.set(uint8_t t)  { TCNT0 = t; }

  //=== Read the current timer scale. ===================================
  async command uint8_t Timer0.getScale() { return TCCR0 & 0x7; }

  //=== Turn off the timers. ============================================
  async command void Timer0.off() { call Timer0.setScale(AVR_CLOCK_OFF); }

  //=== Write a new timer scale. ========================================
  async command void Timer0.setScale(uint8_t s)  { 
    Atm128TimerControl_t x = call Timer0Ctrl.getControl();
    x.bits.cs = s;
    call Timer0Ctrl.setControl(x);  
  }

  //=== Read the control registers. =====================================
  async command Atm128TimerControl_t Timer0Ctrl.getControl() { 
    return *(Atm128TimerControl_t*)&TCCR0; 
  }

  //=== Write the control registers. ====================================
  async command void Timer0Ctrl.setControl( Atm128TimerControl_t x ) { 
    TCCR0 = x.flat; 
  }

  //=== Read the interrupt mask. =====================================
  async command Atm128_TIMSK_t Timer0Ctrl.getInterruptMask() { 
    return *(Atm128_TIMSK_t*)&TIMSK; 
  }

  //=== Write the interrupt mask. ====================================
  DEFINE_UNION_CAST(TimerMask8_2int, Atm128_TIMSK_t, uint8_t);
  DEFINE_UNION_CAST(TimerMask16_2int, Atm128_ETIMSK_t, uint8_t);

  async command void Timer0Ctrl.setInterruptMask( Atm128_TIMSK_t x ) { 
    TIMSK = TimerMask8_2int(x); 
  }

  //=== Read the interrupt flags. =====================================
  async command Atm128_TIFR_t Timer0Ctrl.getInterruptFlag() { 
    return *(Atm128_TIFR_t*)&TIFR; 
  }

  //=== Write the interrupt flags. ====================================
  DEFINE_UNION_CAST(TimerFlags8_2int, Atm128_TIFR_t, uint8_t);
  DEFINE_UNION_CAST(TimerFlags16_2int, Atm128_ETIFR_t, uint8_t);

  async command void Timer0Ctrl.setInterruptFlag( Atm128_TIFR_t x ) { 
    TIFR = TimerFlags8_2int(x); 
  }

  //=== Timer 8-bit implementation. ====================================
  async command void Timer0.reset() { TIFR = 1 << TOV0; }
  async command void Timer0.start() { SET_BIT(TIMSK, TOIE0); }
  async command void Timer0.stop()  { CLR_BIT(TIMSK, TOIE0); }
  async command bool Timer0.test()  { 
    return (call Timer0Ctrl.getInterruptFlag()).bits.tov0; 
  }
  async command bool Timer0.isOn()  { 
    return (call Timer0Ctrl.getInterruptMask()).bits.toie0; 
  }
  async command void Compare0.reset() { TIFR = 1 << OCF0; }
  async command void Compare0.start() { SET_BIT(TIMSK,OCIE0); }
  async command void Compare0.stop()  { CLR_BIT(TIMSK,OCIE0); }
  async command bool Compare0.test()  { 
    return (call Timer0Ctrl.getInterruptFlag()).bits.ocf0; 
  }
  async command bool Compare0.isOn()  { 
    return (call Timer0Ctrl.getInterruptMask()).bits.ocie0; 
  }

  //=== Read the compare registers. =====================================
  async command uint8_t Compare0.get()   { return OCR0; }

  //=== Write the compare registers. ====================================
  async command void Compare0.set(uint8_t t)   { OCR0 = t; }

  //=== Timer interrupts signals ========================================
  default async event void Compare0.fired() { }
  AVR_NONATOMIC_HANDLER(SIG_OUTPUT_COMPARE0) {
    signal Compare0.fired();
  }

  default async event void Timer0.overflow() { }
  AVR_NONATOMIC_HANDLER(SIG_OVERFLOW0) {
    signal Timer0.overflow();
  }
}
