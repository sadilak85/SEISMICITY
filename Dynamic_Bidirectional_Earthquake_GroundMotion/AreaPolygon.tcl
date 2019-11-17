# python3 program to evaluate 
# area of a polygon using 
# shoelace formula 
  
# (X[i], Y[i]) are coordinates of i'th point. 
proc polygonArea {X Y n} {
    # Initialze area 
    set area 0.0
  
    # Calculate value of shoelace formula 
    set j [expr $n - 1]
	for {set i 0} {$i <= [expr $n-1]} {incr i 1} {
        set tmparea [expr [expr [lindex $X $j]+[lindex $X $i]]*[expr [lindex $Y $j]-[lindex $Y $i]]]
		set area [expr $area + $tmparea]
        set j $i;   # j is previous vertex to i 
	}
  
    # Return absolute value
	set halfarea [expr $area / 2.0]
	set result [expr abs($halfarea)]
    return $result 
}

