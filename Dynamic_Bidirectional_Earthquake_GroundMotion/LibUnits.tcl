# --------------------------------------------------------------------------------------------------
# LibUnits.tcl -- define system of units
#		Silvia Mazzoni & Frank McKenna, 2006
#
# define UNITS ----------------------------------------------------------------------------
if {[string match $unitsystem "us"] == 1} {
	set in 1.; 				# define basic units -- output units
	set kip 1.; 			# define basic units -- output units
	set sec 1.; 			# define basic units -- output units
	set LunitTXT "inch";			# define basic-unit text for output
	set FunitTXT "kip";			# define basic-unit text for output
	set TunitTXT "sec";			# define basic-unit text for output
	set ft [expr 12.*$in]; 		# define engineering units
	set ksi [expr $kip/pow($in,2)];
	set psi [expr $ksi/1000.];
	set lbf [expr $psi*$in*$in];		# pounds force
	set pcf [expr $lbf/pow($ft,3)];		# pounds per cubic foot
	set psf [expr $lbf/pow($ft,2)];		# pounds per square foot
	set in2 [expr $in*$in]; 		# inch^2
	set in4 [expr $in*$in*$in*$in]; 		# inch^4
	set cm [expr $in/2.54];		# centimeter, needed for displacement input in MultipleSupport excitation
	set PI [expr 2*asin(1.0)]; 		# define constants
	set g [expr 32.2*$ft/pow($sec,2)]; 	# gravitational acceleration
	set Ubig 1.e10; 			# a really large number
	set Usmall [expr 1/$Ubig]; 		# a really small number
}
if {[string match $unitsystem "metric"] == 1} {
	#set in 0.394; 				# cm --> in
	set in 2.54;				# in --> cm      1 Zoll = 2.54 cm
	#set kip 2.2046; 			# ton --> kip
	set kip 0.4536;				# kip --> ton    1 kip = 0.4536 ton
	set sec 1.; 				# define basic units -- output units
	set LunitTXT "cm";		# define basic-unit text for output
	set FunitTXT "ton";			# define basic-unit text for output
	set TunitTXT "sec";			# define basic-unit text for output
	set ft [expr 12.*$in]; 		# define engineering units
	set ksi [expr $kip/pow($in,2)];
	set psi [expr $ksi/1000.];
	set lbf [expr $psi*$in*$in];		# pounds force
	set pcf [expr $lbf/pow($ft,3)];		# pounds per cubic foot
	set psf [expr $lbf/pow($ft,2)];		# pounds per square foot
	set in2 [expr $in*$in]; 		# inch^2
	set in4 [expr $in*$in*$in*$in]; 		# inch^4
	set cm [expr $in/2.54];		# centimeter, needed for displacement input in MultipleSupport excitation
	set PI [expr 2*asin(1.0)]; 		# define constants
	set g [expr 32.2*$ft/pow($sec,2)]; 	# gravitational acceleration
	set Ubig 1.e10; 			# a really large number
	set Usmall [expr 1/$Ubig]; 		# a really small number
}
#
#
