set OK 0
set in bla
set TOP_DES_NAME mMIPS_system 

#clear


puts "\n\n\n\n\n\n\n\n\n\n"
puts  "\033\[33m###############################################################"
puts           "######   Welcome to the 5LID0 Course Synthesis Tutorial  ######"
puts           "###############################################################\n"
puts "\033\[33m!>\033\[36m This tutorial will guide you through the \033\[35mMMIPS sytem \033\[36m synthesis\n"
puts "\033\[33m!>\033\[36m Almost all state-of-arts EDA tools are controlled by \033\[35mtk/tcl\033\[36m based scripts. The design tools in this course are not an exception and all scripts are written in \033\[35mtcl\033\[36m.\n"
puts "\033\[33m!>\033\[36m The script execution is in a pause mode now due to \033\[35msuspend\033\[36m command written in the script. \033\[35mSuspend\033\[36m is a powerfull command as it gives the user full control over the tool for corrections and debugging\n"
puts "\033\[33m!>\033\[36m In this script \033\[35msuspend\033\[36m is inserted on critical points in the script. \033\[33mYou\033\[36m are asked then to enter crucial configuration commands for a successful and optimal synthesis.\n"
puts "\033\[33m!>\033\[36m These messages are printed using \033\[35mputs\033\[36m command \033\[36m\n"
puts "\033\[33m!>\033\[36m When you are ready to continue, type \033\[35mresume\033\[36m and hit enter. This is the way to \"unpause\" the script execution.\n"
puts "\033\[0m"

suspend


while {$OK != "OK"} {
	puts "\033\[33m###############################################################"
        puts "#####   How to define variables in tcl              ############"
	puts "################################################################\033\[36m\n"
	puts "\033\[33m!>\033\[36m This part of the script is in a \033\[35mloop\033\[36m, which repeats while the content of variable OK is not \"OK\" "
	puts "\033\[33m!>\033\[36m Set the value of the variable to OK and then resume in order to escape the loop and proceed with: \033\[32mset OK \"OK\"\033\[36m"
	puts "\033\[33m!>\033\[36m The variables defined with command \033\[35mset <variable_name> <variable_content>\033\[36m"
	puts "\033\[33m!>\033\[36m <set OK OK> and <set OK \"OK\"> have same effect as tcl generally interprets everything as a string\033\[0m"
	suspend


}

set DESIGN design
while {$DESIGN != $TOP_DES_NAME} {
	puts "\033\[33m################################################################"
        puts "#####        How to use variables in tcl            ############"
	puts "################################################################\033\[36m\n"
	puts "\033\[33m!>\033\[36m Now transfer the content of variable \033\[35mTOP_DES_NAME\033\[36m to the variable \033\[35mDESIGN\033\[36m."
	puts "\033\[33m!>\033\[36m The TOP_DES_NAME variable is already defined."
	puts "\033\[33m!>\033\[36m You can use a tcl variable by puting special character \033\[32m\$ \033\[36m in front of variable name"
	puts "\033\[33m!>\033\[36m For example with puts command you can print the content of \033\[35mOK\033\[36m variable, entering \033\[35mputs \$OK\033\[0m"
	puts "\033\[34mHint:\033\[36m try to hit TAB key while typing \$TOP_D and magic will happen.\033\[0m"
	puts "\033\[36m      This magic works with every other variable/command provided by the tool\033\[0m"
	suspend
}

puts "\033\[33m################################################################"
puts "#####        Now to the real synthesis              ############"
puts "################################################################\033\[36m\n"
puts "\033\[33m!>\033\[36m Now you know how to set and use the tcl variables. This is essential for this tutorial."
puts "\033\[33m!>\033\[36m For more information about tcl language, please, visit \033\[35mwww.tcl.tk. \033\[36mIn the following section we assume you did that.\033\[0m"
puts "\033\[36mFor the imformation of the genus specific commands and attributes you can use \033\[35mhelp command|attribute\033\[036m command.\033\[0m"
puts "\033\[36mThis tutorial is executed in the script with  \033\[35msource\033\[36m command.\033\[0m"
puts "\033\[36mYou can do this also with your own tcl scripts.\033\[0m"
suspend
