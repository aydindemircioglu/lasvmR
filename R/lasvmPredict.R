#
# lasvmPredict.R
#
# Copyright (C) 2015  Aydin Demircioglu, aydin.demircioglu /at/ ini.rub.de
#
# This file is part of the lasvmR library for GNU R.
# It is made available under the terms of the GNU General Public
# License, version 2, or at your option, any later version,
# incorporated herein by reference.
#
# This program is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
# PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Free
# Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
# MA 02111-1307, USA
#


#' lasvmPredict
#' 
#' Use lasvm to train a given problem.
#'
#'  @param	x		data matrix 
#'  @param SV		support vectors
#'  @param elif		alpha vector
#'  @param gamma		gamma for RBFF kernel
#'  @param bias		bias term
#'  @param	verbose		verbose output?
#'
#'  @return	a list consisting of
#'	predictions		the predicted labels
#'
#' @export
lasvmPredict = function (x, model, verbose = FALSE)
{
	# check arguments
	checkmate::assertMatrix(x, min.rows = 1)
	checkmate::assertClass (model, "lasvmR.model")
	checkmate::assertFlag (verbose)
	
	results = lasvmPredictWrapper (x, model$SV, model$alpha, 
		gamma = model$gamma,
		kdegree = model$degree,
		kcoef0 = model$coef0,
		bias = 	 model$bias,
		kerneltype = model$kernel,
		verbose = verbose)

	return (results);
}

