#puts "Write NEW SDF"
#write_sdf -edges check_edge -setuphold split > gate/$DESIGN.sdf
puts "Report Timing:"
#report timing -num_path
report timing -worst 5 > report/mMIPS_system.STA.5.worst
report timing -worst 5 -summary > report/mMIPS_system.STA.5.worst.summary
exit
