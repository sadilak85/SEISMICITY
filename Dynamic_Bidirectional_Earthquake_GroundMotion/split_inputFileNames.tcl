#
#	Assumed input file names are like "xxx_123.tcl"
#	where xxx and 123 are seperated by "_"
#	and the file has an extension ".tcl"
#   123 is the building ID (BID)
#
set contents [glob -directory  "inputs" "*.tcl"]

foreach item $contents {
    lappend Filenames $item
}

foreach e $Filenames {
    set e [split $e "_"]
    lappend l1 [lindex $e 1]
}
foreach e $l1 {
    set e [split $e $FileExt]
	set iBID [lindex $e 0]
    lappend BID $iBID
	lappend ainputFilename $inputFilename$iBID$FileExt
	set Buildingnum [expr $Buildingnum+1]
}