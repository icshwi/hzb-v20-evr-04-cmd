require evr_timestamp_buffer,2.6.0

epicsEnvSet("EPICS_CMDS", "/epics/iocs/cmds")
# Find the PCI bus number for the cards in the crate
system("$(EPICS_CMDS)/mrfioc2-common-cmd/find_pci_bus_id.bash")
< "$(EPICS_CMDS)/mrfioc2-common-cmd/pci_bus_id"
epicsEnvSet("PCI_SLOT", "$(PCI_BUS_NUM):0b.0")

epicsEnvSet("SYS", "HZB-V20:TS")
epicsEnvSet("DEVICE", "EVR-04")
epicsEnvSet("EVR", "$(DEVICE)")
epicsEnvSet("CHIC_SYS", "HZB-V20:")
epicsEnvSet("CHOP_DRV", "Chop-Drv-04")
epicsEnvSet("CHIC_DEV", "TS-$(DEVICE)")
epicsEnvSet("MRF_HW_DB", "evr-cpci-230-ess.db")
#epicsEnvSet("E3_MODULES", "/epics/iocs/e3")
epicsEnvSet("BUFFSIZE", "100")

######## Temporary until chopper group ###########
######## changes PV names              ###########
epicsEnvSet("NCG_SYS", "HZB-V20:")
# Change to 01a: to avoid conflict with EVR2 names
epicsEnvSet("NCG_DRV", "Chop-Drv-04tmp:")
##################################################

< "$(EPICS_CMDS)/mrfioc2-common-cmd/st.evr.cmd"

# Load EVR database
dbLoadRecords("$(MRF_HW_DB)","EVR=$(EVR),SYS=$(SYS),D=$(DEVICE),FEVT=88.0525,PINITSEQ=0")

# Load timestamp buffer database
#iocshLoad("$(evr-timestamp-buffer_DIR)/evr-timestamp-buffer.iocsh", "CHIC_SYS=$(CHIC_SYS), CHIC_DEV=$(CHIC_DEV), CHOP_DRV=$(CHOP_DRV), SYS=$(SYS)")
iocshLoad("$(evr_timestamp_buffer_DIR)/evr_timestamp_buffer.iocsh", "CHIC_SYS=$(CHIC_SYS), CHIC_DEV=$(CHIC_DEV), CHOP_DRV=$(CHOP_DRV), SYS=$(SYS), BUFFSIZE=$(BUFFSIZE)")

dbLoadRecords("/epics/iocs/cmds/hzb-v20-evr-04-cmd/evr4alias.db")

iocInit()

# Global default values
# Set the frequency that the EVR expects from the EVG for the event clock
dbpf $(SYS)-$(DEVICE):Time-Clock-SP 88.0525

dbpf $(SYS)-$(DEVICE):Ena-Sel 1

# Set delay compensation target. This is required even when delay compensation
# is disabled to avoid occasionally corrupting timestamps.
#dbpf $(SYS)-$(DEVICE):DC-Tgt-SP 70
#dbpf $(SYS)-$(DEVICE):DC-Tgt-SP 100

######### INPUTS #########

# Set up of UnivIO 0 as Input. Generate Code 10 locally on rising edge.
dbpf $(SYS)-$(DEVICE):In0-Lvl-Sel "Active High"
dbpf $(SYS)-$(DEVICE):In0-Edge-Sel "Active Rising"
#dbpf $(SYS)-$(DEVICE):OutFPUV00-Src-SP 61
dbpf $(SYS)-$(DEVICE):In0-Trig-Ext-Sel "Edge"
dbpf $(SYS)-$(DEVICE):In0-Code-Ext-SP 10
dbpf $(SYS)-$(DEVICE):EvtA-SP.OUT "@OBJ=$(EVR),Code=10"
dbpf $(SYS)-$(DEVICE):EvtA-SP.VAL 10

# Set up of UnivIO 1 as Input. Generate Code 11 locally on rising edge.
dbpf $(SYS)-$(DEVICE):In1-Lvl-Sel "Active High"
dbpf $(SYS)-$(DEVICE):In1-Edge-Sel "Active Rising"
#dbpf $(SYS)-$(DEVICE):OutFPUV01-Src-SP 61
dbpf $(SYS)-$(DEVICE):In1-Trig-Ext-Sel "Edge"
dbpf $(SYS)-$(DEVICE):In1-Code-Ext-SP 11
dbpf $(SYS)-$(DEVICE):EvtB-SP.OUT "@OBJ=$(EVR),Code=11"
dbpf $(SYS)-$(DEVICE):EvtB-SP.VAL 11

######### OUTPUTS #########
dbpf $(SYS)-$(DEVICE):DlyGen1-Evt-Trig0-SP 14
dbpf $(SYS)-$(DEVICE):DlyGen1-Width-SP 2860 #1ms
dbpf $(SYS)-$(DEVICE):DlyGen1-Delay-SP 0 #0ms
dbpf $(SYS)-$(DEVICE):OutFPUV3-Src-SP 1 #Connect output2 to DlyGen-1

#Set up delay generator 2 to trigger on event 16
dbpf $(SYS)-$(DEVICE):DlyGen2-Width-SP 1000 #1ms
dbpf $(SYS)-$(DEVICE):DlyGen2-Delay-SP 0 #0ms
dbpf $(SYS)-$(DEVICE):DlyGen2-Evt-Trig0-SP 16

#Set up delay generator 0 to trigger on event 17 and set universal I/O 2
dbpf $(SYS)-$(DEVICE):DlyGen0-Width-SP 1000 #1ms
dbpf $(SYS)-$(DEVICE):DlyGen0-Delay-SP 0 #0ms
dbpf $(SYS)-$(DEVICE):DlyGen0-Evt-Trig0-SP 17
dbpf $(SYS)-$(DEVICE):OutFPUV2-Src-SP 0 #Connect to DlyGen-0

######## Sequencer #########
# Select trigger source for soft seq 0, trigger source 0, 2 means pulser 2
#dbpf $(SYS)-$(DEVICE):SoftSeq0-TrigSrc-0-Sel 2

# Load sequencer setup
#dbpf $(SYS)-$(DEVICE):SoftSeq0-Load-Cmd 1

# Enable sequencer
#dbpf $(SYS)-$(DEVICE):SoftSeq0-Enable-Cmd 1

#dbpf $(CHIC_SYS)$(CHOP_DRV)01:Freq-SP 28
#dbpf $(CHIC_SYS)$(CHOP_DRV)02:Freq-SP 28
#dbpf $(CHIC_SYS)$(CHOP_DRV)03:Tube-Pos-Delay 10
#dbpf $(CHIC_SYS)$(CHOP_DRV)04:Tube-Pos-Delay 20
# Check that this command is required.
#dbpf $(SYS)-$(DEVICE):RF-Freq 88052500

# Hints for setting input PVs from client
#caput -a $(SYS)-$(DEVICE):SoftSeq0-EvtCode-SP 2 17 18
#caput -a $(SYS)-$(DEVICE):SoftSeq0-Timestamp-SP 2 0 12578845
#caput -n $(SYS)-$(DEVICE):SoftSeq0-Commit-Cmd 1

######### TIME STAMP #########

#Forward links to esschicTimestampBuffer.template
#dbpf $(SYS)-$(DEVICE):EvtACnt-I.FLNK $(CHIC_SYS)$(CHOP_DRV):TDC
#dbpf $(SYS)-$(DEVICE):EvtECnt-I.FLNK $(CHIC_SYS)$(CHOP_DRV):Ref

#dbpf $(SYS)-$(DEVICE):EvtBCnt-I.FLNK $(CHIC_SYS)$(CHOP_DRV):TDC
#dbpf $(CHIC_SYS)$(CHOP_DRV)01:BPFO.LNK3 $(CHIC_SYS)$(CHOP_DRV):Ref


