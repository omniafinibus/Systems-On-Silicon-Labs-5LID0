SIM_PERIOD = 5

targets:
	@echo "targets: [ synth | power | tempus |clean ]"


synth :
		genus -batch -legacy_ui -overwrite -f ./script/synth.tcl -log logs/genus

power : sdf
	    $(MAKE) -C ../sim tcf CLOCK_TIME_PERIOD=$(SIM_PERIOD)	
		genus -batch -legacy_ui -overwrite -f ./script/load_netlist.tcl -f ./script/analysePower.tcl -log logs/genus_power
tempus :
		tempus -files script/tempus_for_power.tcl -files ../p+r/mMIPS_system.invs_setup.tcl -log logs/tempus -overwrite
voltus :
		voltus -files ../p+r/mMIPS_system.invs_setup.tcl -log logs/voltus -overwrite

sdf :
		genus -legacy_ui -overwrite -f ./script/load_netlist.tcl -f ./script/generateSDF.tcl -log logs/genus_sdf
load : 
ifeq ($(DES),)
	@echo "DES not set"
else
	genus -legacy_ui -overwrite -f $(DES) -log logs/genus_l
endif

STA: 
	genus -legacy_ui -overwrite -f ./script/load_netlist.tcl -f ./script/generateSTA.tcl -log logs/genus_sta

clean:
		rm -rf fv
		rm -rf logs/*
		rm -rf reports/*
		rm genus.*

clean_all:
		@echo "Write Total Cleaning Rule"

