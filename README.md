# Buckling_scripts

This set of scripts was written to input buckled fibril height profiles, to find the peak/trough locations 
and fit them with quadratic functions.  The output is the peak/trough positions of the buckles and 
corresponding radius of curvature values (inverse quadratic curvature)

# buckle_data_read

*inputs = directory, in which there are several directories named 'Nperc' where N = 5*integer

*process = reads text files and populates a struct with the X,Y data and the name of the file(s)

*outputs = the populated structure

# quadfit_profile

*inputs = X,Y data from a profile, lpoly (#point on eahc side of peak/trough, to fit quadratic), 
N (number of peak finding iterations, default 1), filtnum (size of moving average)

*process = finds peaks/troughs as the points where slope changes from neg to pos (or vise versa),
and fits this point and lpoly surrounding on each side to a quadratic function.  Ignores the left/right-most
peaks (these are likely incorrect due to edge effects on the derivative)

*output = returns a populated structure with X,Y position of peak/troughs and radius of curvatures for a 
single profile. In the configuration {[R_p,x_p,y_p],[R_t,x_t,y_t]}

# rad_curv

*process = loads the buckle_data_read output, and calls the function quadfit_profile for each profile. User 
input for each function call: 
w,s increases, decreases (resp) filtnum and re-calls quadfit_profile
a,d increases, decreases (resp) lpoly and re-calls quadfit_profile

*output = returns a populated structure with X,Y position of peak/troughs and radius of curvatures for all
profiles read by buckle_data_read

# Misc

data plotting: plots inter-peak distance versus radius of curvature versus, ratio of peak/trough curvature, etc.

PDMS_deformation_theory: based on point deflection of half space, plots surface curvature as a function of 
applied force
