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

- Though LASVM works internally with sparse data, the interface to R works with dense matrices and vectors. Therefore data has to be copied over. If this bugs you too much, you are free to open an issue and/or propose a solution.

- LASVM is a binary classificator. It does not work with multiclasses and only accepts labels -1, 1.



# Changelist

- v0.1.0: Initial release.
