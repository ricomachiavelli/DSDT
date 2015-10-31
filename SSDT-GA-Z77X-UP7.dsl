DefinitionBlock ("SSDT-GA-Z77X-UP7.aml", "SSDT", 1, "APPLE ", "General", 0x00000001)
{
	External (_SB.PCI0, DeviceObj)

	External (_SB.LNKA._STA, IntObj)
	External (_SB.LNKB._STA, IntObj)
	External (_SB.LNKC._STA, IntObj)
	External (_SB.LNKD._STA, IntObj)
	External (_SB.LNKE._STA, IntObj)
	External (_SB.LNKF._STA, IntObj)
	External (_SB.LNKG._STA, IntObj)
	External (_SB.LNKH._STA, IntObj)

	External (_SB.PCI0.B0D4, DeviceObj)
	External (_SB.PCI0.EH01, DeviceObj)
	External (_SB.PCI0.IGPU, DeviceObj)
	External (_SB.PCI0.LPCB, DeviceObj)
	External (_SB.PCI0.PEG0, DeviceObj)
	External (_SB.PCI0.PEG2, DeviceObj)
	External (_SB.PCI0.RP02, DeviceObj)
	External (_SB.PCI0.RP04, DeviceObj)
	External (_SB.PCI0.RP05, DeviceObj)
	External (_SB.PCI0.RP06, DeviceObj)
	External (_SB.PCI0.RP07, DeviceObj)
	External (_SB.PCI0.RP08, DeviceObj)
	External (_SB.PCI0.SAT1, DeviceObj)
	External (_SB.PCI0.USB1, DeviceObj)
	External (_SB.PCI0.USB2, DeviceObj)
	External (_SB.PCI0.USB3, DeviceObj)
	External (_SB.PCI0.USB4, DeviceObj)
	External (_SB.PCI0.USB5, DeviceObj)
	External (_SB.PCI0.USB6, DeviceObj)
	External (_SB.PCI0.USB7, DeviceObj)
	External (_SB.PCI0.WMI1, DeviceObj)

	External (_SB.PCI0.LPCB.RMSC, DeviceObj)
	External (_SB.PCI0.PEG0.GFX0, DeviceObj)
	External (_SB.PCI0.PEG2.MVL3, DeviceObj)
	External (_SB.PCI0.PEG2.MVL4, DeviceObj)
	External (_SB.PCI0.RP02.PXSX, DeviceObj)
	External (_SB.PCI0.RP04.PXSX, DeviceObj)
	External (_SB.PCI0.RP05.MVL1, DeviceObj)
	External (_SB.PCI0.RP05.MVL2, DeviceObj)
	External (_SB.PCI0.RP05.PXSX, DeviceObj)
	External (_SB.PCI0.RP06.PXSX, DeviceObj)
	External (_SB.PCI0.RP07.PXSX, DeviceObj)
	External (_SB.PCI0.RP08.PXSX, DeviceObj)
	External (_SB.PCI0.TPMX._STA, IntObj)

	External (_SB.PCI0.LPCB.CWDT._STA, IntObj)

	External (_TZ.FAN0, DeviceObj)
	External (_TZ.FAN1, DeviceObj)
	External (_TZ.FAN2, DeviceObj)
	External (_TZ.FAN3, DeviceObj)
	External (_TZ.FAN4, DeviceObj)
	External (_TZ.TZ00, PkgObj)
	External (_TZ.TZ01, PkgObj)

	/* Calls to _OSI in DSDT are routed to here */
	Method(XOSI, 1, Serialized)
	{
		/* Simulates Windows 2012 (Windows 8) */
		Return (Arg0 == "Windows 2012")
	}

	Method (\_SB._INI)
	{
		/* These devices already have _STA objects, we set them to 0 to disable them */

		/* Disabling the LNKx devices */
		\_SB.LNKA._STA = Zero
		\_SB.LNKB._STA = Zero
		\_SB.LNKC._STA = Zero
		\_SB.LNKD._STA = Zero
		\_SB.LNKE._STA = Zero
		\_SB.LNKF._STA = Zero
		\_SB.LNKG._STA = Zero
		\_SB.LNKH._STA = Zero

		/* Disabling the TPMX device */
		\_SB.PCI0.TPMX._STA = Zero

		/* Disabling the CWDT device */
		\_SB.PCI0.LPCB.CWDT._STA = Zero

		/* Disabling the ThermalZones */
		\_TZ.TZ00 = Zero
		\_TZ.TZ01 = Zero
	}

	Scope (\_SB.PCI0)
	{
		/* Disabling the B0D4 device */
		Scope (B0D4) { Name (_STA, Zero) }

		/* Adding the BUS0 device to SBUS */
		Device (SBUS.BUS0)
		{
			Name (_ADR, Zero)
			Name (_CID, "smbus")
			Device (DVL0)
			{
				Name (_ADR, 0x57)
				Name (_CID, "diagsvault")
			}
		}

		/* Adding device properties to EH01 */
		Scope (EH01)
		{
			Name (AAPL, Package()
			{
				"AAPL,current-available", 2100,
				"AAPL,current-extra", 2200,
				"AAPL,current-extra-in-sleep", 1600,
				"AAPL,current-in-sleep", 1600,
				"AAPL,device-internal", 0x02,
				"AAPL,max-port-current-in-sleep", 2100
			})

			Method (_DSM, 4, NotSerialized)
			{
				If (Arg2 == Zero) { Return (Buffer() { 0x03 }) }
				Return (AAPL)
			}
		}

		/* Adding device properties to EH02 */
		Method (EH02._DSM, 4)
		{
			If (Arg2 == Zero) { Return (Buffer() { 0x03 }) }
			Return (^^EH01.AAPL)
		}

		/* Adding device properties to ETH1 */
		Method (ETH1._DSM, 4)
		{
			If (Arg2 == Zero) { Return (Buffer() { 0x03 }) }
			/* Injecting device properties for Intel 82579V Gigabit Ethernet */
			Return (Package()
			{
				"device_type", Buffer() { "Ethernet Controller" },
				"location", Buffer() { "2" }
			})
		}

		Scope (RP02)
		{
			/* Disabling the PXSX device */
			Scope (PXSX) { Name (_STA, Zero) }
			/* Adding a new SATA device */
			Device (SATA) { Name (_ADR, Zero) }
		}

		Scope (RP04)
		{
			/* Disabling the PXSX device */
			Scope (PXSX) { Name (_STA, Zero) }
			/* Adding a new XH02 device (USB 3.0) */
			Device (XH02)
			{
				Name (_ADR, Zero)
				Method (_DSM, 4)
				{
					If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 }) }
					/* Injecting device properties for VIA VL800 USB 3.0 */
					Return (^^^EH01.AAPL)
				}
			}
		}

		Scope (RP05)
		{
			/* Disabling the MVLx devices */
			Scope (MVL1) { Name (_STA, Zero) }
			Scope (MVL2) { Name (_STA, Zero) }
			/* Disabling the PXSX device */
			Scope (PXSX) { Name (_STA, Zero) }
			/* Adding a new ARPT device (AirPort) */
			Device (ARPT) { Name (_ADR, Zero) }
		}

		Scope (RP06)
		{
			/* Disabling the PXSX device */
			Scope (PXSX) { Name (_STA, Zero) }
			/* Adding a new XH03 device (USB 3.0) */
			Device (XH03)
			{
				Name (_ADR, Zero)
				Method (_DSM, 4)
				{
					If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 }) }
					/* Injecting device properties for Etron EJ168 USB 3.0 */
					Return (^^^EH01.AAPL)
				}
			}
		}

		Scope (RP07)
		{
			/* Disabling the PXSX device */
			Scope (PXSX) { Name (_STA, Zero) }
			/* Adding a new ETH0 device */
			Device (ETH0)
			{
				Name (_ADR, Zero)
				Method (_DSM, 4)
				{
					If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 }) }
					/* Injecting device properties for Atheros AR8151/AR8161 Gigabit Ethernet */
					Return (Package()
					{
						"device_type", Buffer() { "Ethernet Controller" },
						"location", Buffer() { "1" }
					})
				}
			}
		}

		Scope (RP08)
		{
			/* Disabling the PXSX device */
			Scope (PXSX) { Name (_STA, Zero) }
			/* Adding a new SATA device */
			Device (SATA) { Name (_ADR, Zero) }
		}

		Scope (PEG0)
		{
			/* Adding device properties to GFX0 */
			Scope (GFX0)
			{
				/* The vendor ID/device ID of the GFX0 device is stored here */
				OperationRegion (GFXH, PCI_Config, Zero, 0x40)
				Field (GFXH, ByteAcc, NoLock, Preserve)
				{
					VID0,	16,
					DID0,	16
				}

				Method (_DSM, 4)
				{
					If (Arg2 == Zero) { Return (Buffer() { 0x03 }) }
					/* If there isn't a discrete GPU present (only IGPU), the vendor ID of the GFX0 device will be 0x8086 (Intel) */
					/* We first need to check if the vendor ID of GFX0 isn't 0x8086 before injecting the device properties */
					If (VID0 != 0x8086)
					{
						/* Injecting generic device properties for discrete graphics with HDMI audio */
						Return (Package()
						{
							"AAPL,slot-name", Buffer() { "Slot-1" },
							"hda-gfx", Buffer() { "onboard-1" }
						})
					}

					Else { Return (Package() { Zero }) }
				}
			}

			Device (HDAU)
			{
				Name (_ADR, One)
				Method (_DSM, 4)
				{
					If (Arg2 == Zero) { Return (Buffer() { 0x03 }) }
					/* Again, we check if the vendor ID of GFX0 isn't 0x8086 before injecting the device properties */
					If (^^GFX0.VID0 != 0x8086)
					{
						/* Injecting generic device properties for discrete graphics with HDMI audio */
						Return (Package()
						{
							"device_type", Buffer() { "Audio Controller" },
							"hda-gfx", Buffer() { "onboard-1" }
						})
					}

					Else { Return (Package() { Zero }) }
				}
			}
		}

		/* Adding device properties to HDEF */
		Method (HDEF._DSM, 4)
		{
			If (Arg2 == Zero) { Return (Buffer() { 0x03 }) }
			/* We first need to check if the vendor ID of GFX0 is 0x8086 before injecting the device properties */
			If (^^PEG0.GFX0.VID0 == 0x8086)
			{
				/* Since only an IGPU is present, the layout ID needs to be set to 3 for HDMI audio to work properly */
				/* Injecting device properties for layout ID 3 & Intel HDMI audio */
				Return (Package ()
				{
					"layout-id", Unicode("\x03"),
					"hda-gfx", Buffer() { "onboard-1" }
				})
			}
			Else
			{
				/* If the vendor ID of GFX0 isn't 0x8086, we can assume a discrete GPU is present, so we will use layout ID 1 instead */
				/* Injecting device properties for layout ID 1 */
				Return (Package() { "layout-id", Unicode("\x01") })
			}
		}

		/* Adding device properties to IGPU */
		Scope (IGPU)
		{
			/* The vendor ID/device ID of the IGPU device is stored here */
			OperationRegion (IGPH, PCI_Config, Zero, 0x40)
			Field (IGPH, ByteAcc, NoLock, Preserve)
			{
				VID0,	16,
				DID0,	16
			}

			Method (_DSM, 4)
			{
				If (Arg2 == Zero) { Return (Buffer() { 0x03 }) }
				/* We first need to check if the vendor ID of GFX0 is 0x8086 to confirm that there isn't a discrete GPU */
				If (^^PEG0.GFX0.VID0 == 0x8086)
				{
					/* If the device ID of the IGPU matches one of the HD (P)3000 device IDs, we will inject the proper snb-platform-id */
					If ((DID0 == 0x112) || (DID0 == 0x122) || (DID0 == 0x10A))
					{
						/* Injecting device properties for Intel HD Graphics (P)3000 (Sandy Bridge DT/SRV GT2) */
						Return (Package()
						{
							"AAPL,snb-platform-id", Buffer() { 0x10, 0x00, 0x03, 0x00 },
							"device-id", Buffer() { 0x26, 0x01, 0x00, 0x00 },
							"hda-gfx", Buffer() { "onboard-1" }
						})
					}

					/* If the device ID of the IGPU matches the HD (P)4000 device ID, we will inject the proper ig-platform-id */
					ElseIf ((DID0 == 0x162) || (DID0 == 0x16A))
					{
						/* Injecting device properties for Intel HD Graphics (P)4000 (Ivy Bridge DT/SRV GT2) */
						Return (Package()
						{
							"AAPL,ig-platform-id", Buffer() { 0x0A, 0x00, 0x66, 0x01 },
							"device-id", Buffer() { 0x62, 0x01, 0x00, 0x00 },
							"hda-gfx", Buffer() { "onboard-1" }
						})
					}

					Else { Return (Package() { Zero }) }
				}

				/* If the vendor ID of GFX0 is not 0x8086, we can assume a discrete GPU is present and the IGPU is being used for AirPlay Mirroring */
				Else
				{
					/* If the device ID of the IGPU matches the HD 2000 device ID, we will inject the proper snb-platform-id */
					If (DID0 == 0x102)
					{
						/* Injecting device properties for Intel HD Graphics 2000 (Sandy Bridge DT GT1) */
						Return (Package() { "AAPL,snb-platform-id", Buffer() { 0x01, 0x00, 0x03, 0x00 } })
					}

					/* If the device ID of the IGPU matches one of the HD (P)3000 device IDs, we will inject the proper snb-platform-id */
					ElseIf ((DID0 == 0x112) | (DID0 == 0x122) | (DID0 == 0x10A))
					{
						/* Injecting device properties for Intel HD Graphics (P)3000 (Sandy Bridge DT/SRV GT2) */
						Return (Package()
						{
							"AAPL,snb-platform-id", Buffer() { 0x01, 0x00, 0x03, 0x00 },
							"device-id", Buffer() { 0x26, 0x01, 0x00, 0x00 }
						})
					}

					/* If the device ID of the IGPU matches the HD 2500/HD 4000 device ID, we will inject the proper ig-platform-id */
					ElseIf ((DID0 == 0x152) | (DID0 == 0x162))
					{
						/* Injecting device properties for Intel HD Graphics 2500/4000 (Ivy Bridge DT GT1/GT2) */
						Return (Package() { "AAPL,ig-platform-id", Buffer() { 0x07, 0x00, 0x62, 0x01 } })
					}

					/* If the device ID of the IGPU matches the HD P4000 device ID, we will inject the proper ig-platform-id */
					ElseIf (DID0 == 0x16A)
					{
						/* Injecting device properties for Intel HD Graphics P4000 (Ivy Bridge SRV GT2) */
						Return (Package()
						{
							"AAPL,ig-platform-id", Buffer() { 0x07, 0x00, 0x62, 0x01 },
							"device-id", Buffer() { 0x66, 0x01, 0x00, 0x00 }
						})
					}

					Else { Return (Package() { Zero }) }
				}
			}
		}

		/* Adding device properties to IMEI */
		Method (IMEI._DSM, 4)
		{
			If (Arg2 == Zero) { Return (Buffer() { 0x03 }) }
			/* If HD 2000/(P)3000 is present, the MEI device ID must be changed for the HD 3000 kexts to load on a 7 Series chipset */
			If ((^^IGPU.DID0 == 0x102) || (^^IGPU.DID0 == 0x112) || (^^IGPU.DID0 == 0x122) | (^^IGPU.DID0 == 0x10A))
			{
				/* Injecting device properties for 6 Series MEI on a 7 Series Chipset */
				Return (Package() { "device-id", Buffer() { 0x3A, 0x1C, 0x00, 0x00 } })
			}

			Else { Return (Package() { Zero }) }
		}

		Scope (LPCB)
		{
			/* Disabling the RMSC device */
			Scope (RMSC) { Name (_STA, Zero) }
		}

		Scope (PEG2)
		{
			/* Disabling the MVLx devices */
			Scope (MVL3) { Name (_STA, Zero) }
			Scope (MVL4) { Name (_STA, Zero) }
		}

		/* Disabling the SAT1 device */
		Scope (SAT1) { Name (_STA, Zero) }

		/* Disabling the USBx devices */
		Scope (USB1) { Name (_STA, Zero) }
		Scope (USB2) { Name (_STA, Zero) }
		Scope (USB3) { Name (_STA, Zero) }
		Scope (USB4) { Name (_STA, Zero) }
		Scope (USB5) { Name (_STA, Zero) }
		Scope (USB6) { Name (_STA, Zero) }
		Scope (USB7) { Name (_STA, Zero) }

		/* Disabling the WMI1 device */
		Scope (WMI1) { Name (_STA, Zero) }

		/* Adding device properties to XH01 */
		Method (XH01._DSM, 4)
		{
			If (Arg2 == Zero) { Return (Buffer() { 0x03 }) }
			Return (^^EH01.AAPL)
		}
	}

	Scope (\_TZ)
	{
		/* Disabling the FANx devices */
		Scope (FAN0) { Name (_STA, Zero) }
		Scope (FAN1) { Name (_STA, Zero) }
		Scope (FAN2) { Name (_STA, Zero) }
		Scope (FAN3) { Name (_STA, Zero) }
		Scope (FAN4) { Name (_STA, Zero) }
	}
}
