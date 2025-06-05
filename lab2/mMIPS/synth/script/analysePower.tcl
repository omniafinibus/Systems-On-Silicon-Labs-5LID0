
read_tcf ../sim/tcf.dump
set TOP_DES_NAME mMIPS_system
# write reports:
report timing       > ./report/${TOP_DES_NAME}_tcf.timing
report power        > ./report/${TOP_DES_NAME}_tcf.power
report summary      > ./report/${TOP_DES_NAME}_tcf.summary

puts "The RUNTIME is [get_attr runtime /] seconds"

##exit

