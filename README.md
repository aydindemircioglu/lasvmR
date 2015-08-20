# lasvmR

lasvmR is a simple wrapper for the K-Means C++ library 
(see www.tkl.iis.u-tokyo.ac.jp/~ynaga/yakmo/) developed
by Naoki Yoshinaga.

lasvmR implements orthogonal K-Means. It can work in several rounds.
In the first round, a normal K-Means is applied to the data.
In each subsequent round, the next clustering is done on a subspace orthogonal
to the centroids of the last clustering. This way one produces different
views on the data.
To speed up the whole procedure, Greg Hamerlys faster K-Means
is utilized. Initilization can be done either classically (uniformly random)
or by using the K-Means++ scheme.


# Note

To circumvent platform-dependent floating point problems, there are some differences to the original yakmo package:

- The different random number generators are replaced by the R::unif random number generator
- The projection is rounded to 14 digits precision. 

Therefore the results are not directly comparable to the original yakmo package. As the package is also enforced not to use 
specific C-compiler flags, compiling is NOT done with the -ffloat-store flag. This means now that different precision is used
on different platforms (32bit vs 64bit, possibly also linux vs windows). To circumvent that problem and to be somewhat platform-independent the projection is rounded to 14 digits. That might hurt a bit, but hopefully not too much. 




# Changelist

- v0.1.1: fix sun solaris build (32bit)
- v0.1.0: Initial release.
