DefinitionBlock ("SSDT-GA-B75M-D3H.aml", "SSDT", 1, "APPLE", "tinySSDT", 0x00000001)
{
	External (_SB.PCI0, DeviceObj)
	External (_SB.PWRB, DeviceObj)

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
	External (_SB.PCI0.EH02, DeviceObj)
	External (_SB.PCI0.GLAN, DeviceObj)
	External (_SB.PCI0.IGPU, DeviceObj)
	External (_SB.PCI0.LPCB, DeviceObj)
	External (_SB.PCI0.PEG0, DeviceObj)
	External (_SB.PCI0.RP05, DeviceObj)
	External (_SB.PCI0.RP06, DeviceObj)
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
	External (_SB.PCI0.RP05.PXSX, DeviceObj)
	External (_SB.PCI0.RP06.PXSX, DeviceObj)
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
		Return (LEqual (Arg0, "Windows 2012"))
	}

	Method (\_SB._INI)
	{
		/* These devices already have _STA objects, we set them to 0 to disable them */

		/* Disabling the LNKx devices */
		Store (Zero, \_SB.LNKA._STA)
		Store (Zero, \_SB.LNKB._STA)
		Store (Zero, \_SB.LNKC._STA)
		Store (Zero, \_SB.LNKD._STA)
		Store (Zero, \_SB.LNKE._STA)
		Store (Zero, \_SB.LNKF._STA)
		Store (Zero, \_SB.LNKG._STA)
		Store (Zero, \_SB.LNKH._STA)

		/* Disabling the TPMX device */
		Store (Zero, \_SB.PCI0.TPMX._STA)

		/* Disabling the CWDT device */
		Store (Zero, \_SB.PCI0.LPCB.CWDT._STA)

		/* Disabling the ThermalZones */
		Store (Zero, \_TZ_.TZ00)
		Store (Zero, \_TZ_.TZ01)
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
		Method (EH01._DSM, 4)
		{
			If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 }) }
			Return (Package()
			{
				"AAPL,clock-id", Buffer() { 0x01 },
				"AAPL,current-available", 0x0834,
				"AAPL,current-extra", 0x0898,
				"AAPL,current-extra-in-sleep", 0x0640,
				"AAPL,current-in-sleep", 0x03E8,
				"AAPL,device-internal", 0x02,
				"AAPL,max-port-current-in-sleep", 0x0834
			})
		}

		/* Adding device properties to EH02 */
		Method (EH02._DSM, 4)
		{
			If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 }) }
			Return (Package()
			{
				"AAPL,clock-id", Buffer() { 0x01 },
				"AAPL,current-available", 0x0834,
				"AAPL,current-extra", 0x0898,
				"AAPL,current-extra-in-sleep", 0x0640,
				"AAPL,current-in-sleep", 0x03E8,
				"AAPL,device-internal", 0x02,
				"AAPL,max-port-current-in-sleep", 0x0834
			})
		}

		/* Disabling the GLAN device */
		Scope (GLAN) { Name (_STA, Zero) }

		Scope (RP03)
		{
			/* Disabling the PXSX device */
			Scope (PXSX) { Name (_STA, Zero) }
			/* Adding a new ARPT device (AirPort) */
			Device (ARPT) { Name (_ADR, Zero) }
		}

		Scope (RP05)
		{
			/* Disabling the PXSX device */
			Scope (PXSX) { Name (_STA, Zero) }
			/* Adding a new GIGE device */
			Device (GIGE)
			{
				Name (_ADR, Zero)
				Method (_DSM, 4)
				{
					If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 }) }
					/* Injecting device properties for Realtek RTL8168E Gigabit Ethernet */
					Return (Package() { "device_type", Buffer() { "Ethernet Controller" } })
				}
			}
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
					If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 }) }
					/* If there isn't a discrete GPU present (only IGPU), the vendor ID of the GFX0 device will be 0x8086 (Intel) */
					/* We first need to check if the vendor ID of GFX0 isn't 0x8086 before injecting the device properties */
					If (LNotEqual (\_SB.PCI0.PEG0.GFX0.VID0, 0x8086))
					{
						/* Injecting generic device properties for discrete graphics with HDMI audio */
						Return (Package()
						{
							"AAPL,slot-name", Buffer() { "Slot-1" },
							"hda-gfx", Buffer() { "onboard-1" }
						})
					}

					Return (Zero)
				}
			}

			Device (HDAU)
			{
				Name (_ADR, One)
				Method (_DSM, 4)
				{
					If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 }) }
					/* Again, we check if the vendor ID of GFX0 isn't 0x8086 before injecting the device properties */
					If (LNotEqual (\_SB.PCI0.PEG0.GFX0.VID0, 0x8086))
					{
						/* Injecting generic device properties for discrete graphics with HDMI audio */
						Return (Package()
						{
							"device_type", Buffer() { "Audio Controller" },
							"hda-gfx", Buffer() { "onboard-1" }
						})
					}

					Return (Zero)
				}
			}
		}

		/* Adding device properties to HDEF */
		Method (HDEF._DSM, 4)
		{
			If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 }) }
			/* We first need to check if the vendor ID of GFX0 is 0x8086 before injecting the device properties */
			If (LEqual (\_SB.PCI0.PEG0.GFX0.VID0, 0x8086))
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
				If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 }) }
				/* We first need to check if the vendor ID of GFX0 is 0x8086 to confirm that there isn't a discrete GPU */
				If (LEqual (\_SB.PCI0.PEG0.GFX0.VID0, 0x8086))
				{
					/* If the device ID of the IGPU matches one of the HD (P)3000 device IDs, we will inject the proper snb-platform-id */
					If (LOr (LOr (LEqual (\_SB.PCI0.IGPU.DID0, 0x112), LEqual (\_SB.PCI0.IGPU.DID0, 0x122)), LEqual (\_SB.PCI0.IGPU.DID0, 0x10A)))
					{
						/* Injecting device properties for Sandy Bridge Intel HD Graphics (P)3000 (Primary) */
						Return (Package()
						{
							"AAPL,snb-platform-id", Buffer() { 0x10, 0x00, 0x03, 0x00 },
							"device-id", Buffer() { 0x26, 0x01, 0x00, 0x00 },
							"hda-gfx", Buffer() { "onboard-1" }
						})
					}

					/* If the device ID of the IGPU matches the HD 2500/HD 4000 device ID, we will inject the proper ig-platform-id */
					If (LOr (LEqual (\_SB.PCI0.IGPU.DID0, 0x152), LEqual (\_SB.PCI0.IGPU.DID0, 0x162)))
					{
						/* Injecting device properties for Ivy Bridge HD 2500/HD 4000 (Primary) */
						Return (Package()
						{
							"AAPL,ig-platform-id", Buffer() { 0x0A, 0x00, 0x66, 0x01 },
							"hda-gfx", Buffer() { "onboard-1" }
						})
					}

					/* If the device ID of the IGPU matches the HD P4000 device ID, we will inject the proper ig-platform-id */
					If (LEqual (\_SB.PCI0.IGPU.DID0, 0x16A))
					{
						/* Injecting device properties for Ivy Bridge HD P4000 (Primary) */
						Return (Package()
						{
							"AAPL,ig-platform-id", Buffer() { 0x0A, 0x00, 0x66, 0x01 },
							"device-id", Buffer() { 0x66, 0x01, 0x00, 0x00 },
							"hda-gfx", Buffer() { "onboard-1" }
						})
					}

					Return (Zero)
				}

				/* If the vendor ID of GFX0 is not 0x8086, we can assume a discrete GPU is present and the IGPU is being used for AirPlay Mirroring */
				Else
				{
					/* If the device ID of the IGPU matches the HD 2000 device ID, we will inject the proper snb-platform-id */
					If (LEqual (\_SB.PCI0.IGPU.DID0, 0x102))
					{
						/* Injecting device properties for Sandy Bridge Intel HD Graphics 2000 (AirPlay) */
						Return (Package() { "AAPL,snb-platform-id", Buffer() { 0x01, 0x00, 0x03, 0x00 } })
					}

					/* If the device ID of the IGPU matches one of the HD (P)3000 device IDs, we will inject the proper snb-platform-id */
					If (LOr (LOr (LEqual (\_SB.PCI0.IGPU.DID0, 0x112), LEqual (\_SB.PCI0.IGPU.DID0, 0x122)), LEqual (\_SB.PCI0.IGPU.DID0, 0x10A)))
					{
						/* Injecting device properties for Sandy Bridge Intel HD Graphics (P)3000 (AirPlay) */
						Return (Package()
						{
							"AAPL,snb-platform-id", Buffer() { 0x01, 0x00, 0x03, 0x00 },
							"device-id", Buffer() { 0x26, 0x01, 0x00, 0x00 }
						})
					}

					/* If the device ID of the IGPU matches the HD 2500/HD 4000 device ID, we will inject the proper ig-platform-id */
					If (LOr (LEqual (\_SB.PCI0.IGPU.DID0, 0x152), LEqual (\_SB.PCI0.IGPU.DID0, 0x162)))
					{
						/* Injecting device properties for Ivy Bridge HD 2500/HD 4000 (AirPlay) */
						Return (Package() { "AAPL,ig-platform-id", Buffer() { 0x07, 0x00, 0x62, 0x01 } })
					}

					/* If the device ID of the IGPU matches the HD P4000 device ID, we will inject the proper ig-platform-id */
					If (LEqual (\_SB.PCI0.IGPU.DID0, 0x16A))
					{
						/* Injecting device properties for Ivy Bridge HD P4000 (AirPlay) */
						Return (Package()
						{
							"AAPL,ig-platform-id", Buffer() { 0x07, 0x00, 0x62, 0x01 },
							"device-id", Buffer() { 0x66, 0x01, 0x00, 0x00 }
						})
					}

					Return (Zero)
				}
			}
		}

		/* Adding device properties to IMEI */
		Method (IMEI._DSM, 4)
		{
			If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 }) }
			/* If HD 2000/(P)3000 is present, the device ID of the IMEI device must be changed for the HD 3000 kexts to load on a 7 Series chipset */
			If (LOr (LOr (LOr (LEqual (\_SB.PCI0.IGPU.DID0, 0x0102), LEqual (\_SB.PCI0.IGPU.DID0, 0x0112)), LEqual (\_SB.PCI0.IGPU.DID0, 0x0122)), LEqual (\_SB.PCI0.IGPU.DID0, 0x010A)))
			{
				/* Injecting device properties for Sandy Bridge HD 2000/(P)3000 with Ivy Bridge chipset */
				Return (Package() { "device-id", Buffer() { 0x3A, 0x1C, 0x00, 0x00 } })
			}

			Return (Zero)
		}

		Scope (LPCB)
		{
			/* Disabling the RMSC device */
			Scope (RMSC) { Name (_STA, Zero) }
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
			If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 }) }
			Return (Package()
			{
				"AAPL,clock-id", Buffer() { 0x02 },
				"AAPL,current-available", 0x0834,
				"AAPL,current-extra", 0x0898,
				"AAPL,current-extra-in-sleep", 0x0640,
				"AAPL,current-in-sleep", 0x03E8,
				"AAPL,device-internal", 0x02,
				"AAPL,max-port-current-in-sleep", 0x0834
			})
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
