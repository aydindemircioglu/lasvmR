
## Resubmission

This is a resubmission in which I tried to 

- remove the (apparent) memory bug. Alas i was not able to reproduce it on any of my environments 
(incl. e.g. R-devel from svn, compiled with ASAN and working sanitizers::stackAddressSanitize(1)). 

- remove a few clang compile warnings.

 
## Test environments
* local ubuntu 15.10 alpha2 install (64bit), R 3.2.1
* virtual ubuntu 15.04 install (32bit), R 3.2.1
* win-builder (devel and release)
* virtual sun os 11 (32bit) R latest



## R CMD check results

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘Aydin Demircioglu <aydin.demircioglu@ini.rub.de>’
New submission

Status: 1 NOTE

To be expected for the first version of a package.



## Downstream dependencies
There are currently no downstream dependencies for this package.

