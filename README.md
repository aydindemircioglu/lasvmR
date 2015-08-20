# lasvmR

lasvmR is a simple wrapper for the LASVM Solver (see http://leon.bottou.org/projects/lasvm). LASVM is basically an online variant of the SMO solver, but citing the original webpage is better:

> LASVM is an approximate SVM solver that uses online approximation. It reaches accuracies similar to that of a real SVM after performing a single sequential pass through the training examples. Further benefits can be achieved using selective sampling techniques to choose which example should be considered next.


# Note

- Though LASVM works internally with sparse data, the interface to R works with dense matrices and vectors. Therefore data has to be copied over. If this bugs you too much, you are free to open an issue and/or propose a solution.

- LASVM is a binary classificator. It does not work with multiclasses and only accepts labels -1, 1.



# Changelist

- v0.1.0: Initial release.
