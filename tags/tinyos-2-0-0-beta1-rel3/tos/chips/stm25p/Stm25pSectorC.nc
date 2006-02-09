/**
 * Copyright (c) 2005-2006 Arched Rock Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Arched Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * Implementation of the sector storage absraction for the ST M25P
 * serial code flash.
 *
 * @author Jonathan Hui <jhui@archedrock.com>
 * @version $Revision: 1.1.2.5 $ $Date: 2006-02-07 19:43:02 $
 */

configuration Stm25pSectorC {

  provides interface Resource as ClientResource[ storage_volume_t volume ];
  provides interface Stm25pSector as Sector[ storage_volume_t volume ];
  provides interface Stm25pVolume as Volume[ storage_volume_t volume ];

}

implementation {

  components MainC;

  components Stm25pSectorP as SectorP;
  ClientResource = SectorP;
  Sector = SectorP;
  Volume = SectorP;
  MainC.SoftwareInit -> SectorP;

  components new FcfsArbiterC( "Stm25p.Volume" ) as Arbiter;
  MainC.SoftwareInit -> Arbiter;
  SectorP.Stm25pResource -> Arbiter;

  components Stm25pSpiC as SpiC;
  SectorP.SpiResource -> SpiC;
  SectorP.Spi -> SpiC;
  MainC.SoftwareInit -> SpiC;

  components LedsC as Leds;
  SectorP.Leds -> Leds;

}

