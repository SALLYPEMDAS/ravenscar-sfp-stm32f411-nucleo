------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--          Copyright (C) 2012-2013, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
--                                                                          --
--                                                                          --
--                                                                          --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------

--  This file provides register definitions for the STM32F4 (ARM Cortex M4F)
--  microcontrollers from ST Microelectronics.

package System.STM32F4.GPIO is

   ----------
   -- GPIO --
   ----------

   --------------
   -- Adresses --
   --------------
   GPIOH_Base : constant := AHB1_Peripheral_Base + 16#1C00#;
   GPIOE_Base : constant := AHB1_Peripheral_Base + 16#1000#;
   GPIOD_Base : constant := AHB1_Peripheral_Base + 16#0C00#;
   GPIOC_Base : constant := AHB1_Peripheral_Base + 16#0800#;
   GPIOB_Base : constant := AHB1_Peripheral_Base + 16#0400#;
   GPIOA_Base : constant := AHB1_Peripheral_Base + 16#0000#;

   -----------
   -- Types --
   -----------

   type IO_Index is range 0 .. 15;

   --  MODER enum
   type MODER is (Mode_IN, Mode_OUT, Mode_AF, Mode_AN)
     with Size => Bits_2'Size;
   for MODER use (Mode_IN => 0,
                  Mode_OUT => 1,
                  Mode_AF => 2,
                  Mode_AN => 3);

   type MODER_IOs is array (IO_Index) of MODER
     with Pack;

   --  OTYPER enum
   type OTYPER is (Type_PP, Type_OD) with Size => 1;
   for OTYPER use (Type_PP => 0,
                   Type_OD => 1);

   type OTYPER_IOs is array (IO_Index) of OTYPER
     with Pack, Size => Bits_16'Size;

   --  OSPEEDR enum
   type OSPEEDR is (Speed_4MHz, -- Low speed
                    Speed_25MHz, -- Medium speed
                    Speed_50MHz, -- Fast speed
                    Speed_100MHz -- High speed on 30pF, 80MHz on 15
                   )
     with Size => Bits_2'Size;

   for OSPEEDR use (Speed_4MHz => 0,
                    Speed_25MHz => 1,
                    Speed_50MHz => 2,
                    Speed_100MHz => 3);

   type OSPEEDR_IOs is array (IO_Index) of OSPEEDR
     with Pack;

   --  PUPDR enum
   type PUPDR is (No_Pull, Pull_Up, Pull_Down)
     with Size => Bits_2'Size;
   for PUPDR use (No_Pull => 0,
                  Pull_Up => 1,
                  Pull_Down => 2);

   type PUPDR_IOs is array (IO_Index) of PUPDR with Pack;

   type Inputs is array (IO_Index) of Boolean with Pack;
   type Outputs is array (IO_Index) of Boolean with Pack;

   type LCK is array (IO_Index) of Boolean with Pack;

   --  AFL constants
   AF_USART1    : constant Bits_4 := 7;
   AF_USART2    : constant Bits_4 := 7;

   --  Register definition
   type GPIO_Register is record
      MODER   : MODER_IOs := (others => Mode_IN);
      OTYPER  : OTYPER_IOs := (others => Type_PP);

      OSPEEDR : OSPEEDR_IOs := (others => Speed_4MHz);
      PUPDR   : PUPDR_IOs := (others => No_Pull);

      IDR     : Inputs := (others => False);

      ODR     : Outputs := (others => False);

      BSRR    : Word := 16#0000#;

      LCKR    : LCK := (others => False);
      LCKK    : Boolean := False;

      AFRL    : Bits_8x4 := (others => AF_USART1);
      AFRH    : Bits_8x4 := (others => AF_USART1);
   end record with Size => 10 * Word'Size;

   for GPIO_Register use
      record
         MODER at 0 range 0 .. 31;
         OTYPER at 1 * Offset_Size range 0 .. 15;
         OSPEEDR at 2 * Offset_Size range 0 .. 31;
         PUPDR at 3 * Offset_Size range 0 .. 31;
         IDR at 4 * Offset_Size range 0 .. 15;
         ODR at 5 * Offset_Size range 0 .. 15;
         BSRR at 6 * Offset_Size range 0 .. 31;
         LCKR at 7 * Offset_Size range 0 .. 15;
         LCKK at 7 * Offset_Size range 16 .. 16;
         AFRL at 8 * Offset_Size range 0 .. 31;
         AFRH at 9 * Offset_Size range 0 .. 31;
      end record;

   GPIOA : GPIO_Register
     with Volatile, Address => System'To_Address (GPIOA_Base);

   pragma Import (Ada, GPIOA);

   GPIOB : GPIO_Register with Volatile,
                               Address => System'To_Address (GPIOB_Base);
   pragma Import (Ada, GPIOB);

   GPIOC : GPIO_Register with Volatile,
                               Address => System'To_Address (GPIOC_Base);
   pragma Import (Ada, GPIOC);

   GPIOD : GPIO_Register with Volatile,
                               Address => System'To_Address (GPIOD_Base);
   pragma Import (Ada, GPIOD);

   GPIOE : GPIO_Register with Volatile,
                               Address => System'To_Address (GPIOE_Base);
   pragma Import (Ada, GPIOE);

   GPIOH : GPIO_Register with Volatile,
                               Address => System'To_Address (GPIOH_Base);
   pragma Import (Ada, GPIOH);

end System.STM32F4.GPIO;
