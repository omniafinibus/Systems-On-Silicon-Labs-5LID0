
puts "\033\[36mThis file applies the content produced by prepare_CPF_input.tcl and     \033\[0m"
puts "\033\[36mproduces final MIPS.cpf file                                         \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
puts "\033\[36m                                                                        \033\[0m"
set fid_in [open "cpf/MIPS_tmpl.cpf" r]
set fid_out [open "cpf/MIPS.cpf" w]
puts $fid_out [subst -nobackslashes [read $fid_in]]
close $fid_in
close $fid_out
