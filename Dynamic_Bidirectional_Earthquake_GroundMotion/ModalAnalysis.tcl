# ------------   Eigenvalue analysis  -------------------------------------------------------
set lambda [eigen $numModes];

# calculate frequencies and periods of the structure ---------------------------------------------------
set omega {}
set f {}
set T {}
set pi 3.141593

foreach lam $lambda {
	lappend omega [expr sqrt($lam)]
	lappend f [expr sqrt($lam)/(2*$pi)]
	lappend T [expr (2*$pi)/sqrt($lam)]
}

puts "periods are $T"

# write the output file cosisting of periods
set period "modes/Periods.txt"
set Periods [open $period "w"]
foreach t $T {
	puts $Periods " $t"
}
close $Periods

# record the eigenvectors
# ------------------------
 record

# Define DISPLAY -------------------------------------------------------------
DisplayModel3D ModeShape ;	 # options: DeformedShape NodeNumbers ModeShape