#
#	Puts the node ID'S in a file for evaluation process
#
#
#

proc CreateNodeIDFile {iNodeList numInFile outFileNodeIDName} {
    # Open output file for writing
    set outFileNodeID [open $outFileNodeIDName w]

	for {set i 0} {$i <= [expr [llength [lindex $iNodeList $numInFile]]-1]} {incr i 1} {	
		# Echo ground motion values to output file
		puts $outFileNodeID [lindex $iNodeList $numInFile $i 0]
	}

    # Close the output file
    close $outFileNodeID

}; 

proc CreateEltIDFile {iElementwColumns numInFile outFileEltIDName} {
    # Open output file for writing
    set outFileEltID [open $outFileEltIDName w]

	for {set i 0} {$i <= [expr [llength [lindex $iElementwColumns $numInFile]]-1]} {incr i 1} {	
		# Echo ground motion values to output file
		puts $outFileEltID [lindex $iElementwColumns $numInFile $i 0]
	}

    # Close the output file
    close $outFileEltID

};                                                                                                                                    #
