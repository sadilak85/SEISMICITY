set iMasterNode ""
set filename "INPUT.txt"
array set myarray {}
set myarray(1) 0

glob -directory "inputs" "*.tcl"
set dene ""
puts [lindex $dene 0 0]
for {set i 1} {$i <= 3} {incr i 1} {
	lappend dene [expr $i+1]
}
puts $dene
lset dene 2 0 "ak"
puts $dene

set list ""
for {set i 1} {$i <= 4} {incr i 1} {
	lappend list $dene
}

puts $list
puts bak[llength $list]
puts bak[llength [lindex $list 1]]
lset list 0 2 "alal"
puts $list
puts [lindex $list 0]

set nblist {
    {1 2 "testout1.txt" {}}
    {3 7 5 9 1}
    {7 4 9 2 5}
    {1 2 4 6}
    {1 5 4}
}

set nblist2 {
    {"tek"}
    {"yek"}
	{"sek"}
	{"fek"}
	{"lek"}
}


puts [lindex $nblist2 0 0]
lset nblist2 0 0 "alal"
puts [lindex $nblist2 0 0]

# Reading...
set row 0
set column 2
set outname [lindex $nblist $row $column]

# Writing...
lset nblist $row 3 $outname
set outname [lindex $nblist $row 3]

lset nblist 2 0 [expr {[lindex $nblist 2 0] + 17}]
puts [lindex $nblist 2 0]

set outputfile [open $outname w]
    if [catch {open $filename r} inFileID] {
      puts stderr "Cannot open $inFilename for reading"
    } else {
      set flag 0
      foreach line [split [read $inFileID] \n] {
         if {[llength $line] == 0} {
            # Blank line --> do nothing
            continue
         } elseif {$flag == 1} {
		    foreach word [split $line] {
			   if {[string match $word "#RIGID"] == 1} {set flag 0}
            }
			if {$flag == 1} {
				puts $outputfile $line
				set list [regexp -all -inline -- {[-+]?[0-9]*\.?[0-9]+} $line]
				foreach MasterNodeID [split $list] {
					if {[string index $MasterNodeID 0] eq "1"} {
						set a [expr 1+[string index $MasterNodeID 1]]
						puts $MasterNodeID
						set myarray([string index $MasterNodeID 0]) $MasterNodeID
						set i [expr [string index $MasterNodeID 0]]
						set myarray($i) [expr $myarray($i) + 3];
						lappend iMasterNode $MasterNodeID
						puts orada$iMasterNode
						break
					} else {break}
				}
			}
         } else {
            foreach word [split $line] {
               if {$flag == 1} {
                  break
               }
               if {[string match $word "#MASTERNODES"] == 1} {set flag 1}
            }
         }
	  }
	  puts $myarray(1)
	  puts $iMasterNode
	  close $outputfile
      close $inFileID
   }