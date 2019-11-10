
while 1 {
	puts "Which analysis do you prefer? <D> Dynamic Excitation / <S> Static Pushover "
    flush stdout;    # <<<<<<<< IMPORTANT!
	gets stdin word

	if {[string tolower $word] == "d"} {
		puts "Dynamic Analysis has been selected..."
		puts ""
		source Frame3D_analyze_Dynamic_EQ_bidirect.tcl
        break
    } elseif {[string tolower $word] == "s"} {
		puts "Static Pushover Analysis has been selected..."
		puts ""
        break
    }
    puts "Please respond with D for Dynamic Analysis or S for Static Pushover"
}
