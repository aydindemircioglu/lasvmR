// -*- mode: c++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-
//
// lasvmR
//
//
//
// Copyright (C) 2015  Aydin Demircioglu, aydin.demircioglu /at/ ini.rub.de
//
// This file is part of the lasvmR library for GNU R.
// It is made available under the terms of the GNU General Public
// License, version 2, or at your option, any later version,
// incorporated herein by reference.
//
// This program is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
// PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public
// License along with this program; if not, write to the Free
// Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
// MA 02111-1307, USA
//

#include <sstream>
#include <stdio.h>
#include <string.h>
#include <iomanip>
#include <Rcpp.h>
#include "vector.h"


using namespace std;
using namespace Rcpp;



#define LINEAR  0
#define POLY    1
#define RBF     2
#define SIGMOID 3 


extern int m;
extern int msv;                         // training and test set sizes
extern vector <lasvm_sparsevector_t*> X; // feature vectors for test set
extern vector <lasvm_sparsevector_t*> Xsv;// feature vectors for SVs
extern vector <int> Y;                   // labels
extern vector <double> alpha;            // alpha_i, SV weights
extern double b0;                        // threshold
// extern int use_b0;                     // use threshold via constraint \sum a_i y_i =0
extern int kernel_type;              // LINEAR, POLY, RBF or SIGMOID kernels
// extern double degree;
extern double kgamma;
// extern double coef0; // kernel params
// extern vector <double> x_square;         // norms of input vectors, used for RBF
extern vector <double> xsv_square;        // norms of test vectors, used for RBF
// extern char split_file_name[1024];         // filename for the splits
// extern int binary_files;
// extern vector <ID> splits;             
extern int max_index;
extern double alpha_tol;

void la_svm_parse_command_line (int argc, char **argv, char *input_file_name, char *model_file_name);
void adapt_data(int msz);
void train_online(char *model_file_name, char *input_file_name);
int count_svs();
double kernel(int i, int j, void *kparam);


char *convert(const std::string & s)
{
	char *pc = new char[s.size()+1];
	strcpy(pc, s.c_str());
	return pc; 
}



//' lasvmTrain
//' 
//' Use lasvm to train a given problem.
//'
//'  @param	x		data matrix 
//'  @param	rounds		number of rounds (orthogonal views)
//'  @param	k		number of clusters
//'  @param	iter	numer of iterations in one round
//'  @param	initType		centroid initialization via Random or KMeans++
//'  @param	verbose		verbose output?
//'
//'  @return	a list consisting of
//'	centers	these are the resulting centroids of the kmean algorithm (as a std::vector of NumericMatrix)
//'	cluster 	these are the labels for the resulting clustering (as a std::vector of NumericVector)
//'	obj			this is a vector with the final objective value for each round
//'
// [[Rcpp::export]]
List lasvmTrainWrapper(
	Rcpp::NumericMatrix x,
	Rcpp::NumericVector y,
	double gamma,
	double cost,
	int degree = 3,
	int coef0 = 0,
	int optimizer = 1,
	int kernel = 2,
	int selection = 0,
	int termination = 0,
	int cachesize = 256,
	int bias = 1,
	int epochs = 1,
	double epsilon = 0.001,
	bool verbose = false
)
{
	// 	-wi weight: set the parameter C of class i to weight*C (default 1)
	std::vector<std::string>  vec;
	
	// sorry for this shit.
	stringstream tmpS;
	tmpS << "lasvm"; vec.push_back(tmpS.str()); tmpS.str(""); tmpS.clear(); 
	tmpS << "-o"; vec.push_back(tmpS.str()); tmpS.str(""); tmpS.clear(); tmpS <<  optimizer; vec.push_back(tmpS.str()); tmpS.str (""); tmpS.clear();
	tmpS << "-t"; vec.push_back(tmpS.str()); tmpS.str(""); tmpS.clear(); tmpS <<  kernel; vec.push_back(tmpS.str()); tmpS.str (""); tmpS.clear();
	tmpS << "-s"; vec.push_back(tmpS.str()); tmpS.str(""); tmpS.clear(); tmpS <<  selection; vec.push_back(tmpS.str()); tmpS.str (""); tmpS.clear();
	tmpS << "-T"; vec.push_back(tmpS.str()); tmpS.str(""); tmpS.clear(); tmpS <<  termination; vec.push_back(tmpS.str()); tmpS.str (""); tmpS.clear();
	tmpS << "-g"; vec.push_back(tmpS.str()); tmpS.str(""); tmpS.clear(); tmpS <<  gamma; vec.push_back(tmpS.str()); tmpS.str (""); tmpS.clear();
	tmpS << "-c"; vec.push_back(tmpS.str()); tmpS.str(""); tmpS.clear(); tmpS <<  cost; vec.push_back(tmpS.str()); tmpS.str (""); tmpS.clear();
	tmpS << "-d"; vec.push_back(tmpS.str()); tmpS.str(""); tmpS.clear(); tmpS <<  degree; vec.push_back(tmpS.str()); tmpS.str (""); tmpS.clear();
	tmpS << "-r"; vec.push_back(tmpS.str()); tmpS.str(""); tmpS.clear(); tmpS <<  coef0; vec.push_back(tmpS.str()); tmpS.str (""); tmpS.clear();
	tmpS << "-m"; vec.push_back(tmpS.str()); tmpS.str(""); tmpS.clear(); tmpS <<  cachesize; vec.push_back(tmpS.str()); tmpS.str (""); tmpS.clear();
	tmpS << "-b"; vec.push_back(tmpS.str()); tmpS.str(""); tmpS.clear(); tmpS <<  bias; vec.push_back(tmpS.str()); tmpS.str (""); tmpS.clear();
	tmpS << "-e"; vec.push_back(tmpS.str()); tmpS.str(""); tmpS.clear(); tmpS <<  epsilon; vec.push_back(tmpS.str()); tmpS.str (""); tmpS.clear();
	tmpS << "-p"; vec.push_back(tmpS.str()); tmpS.str(""); tmpS.clear(); tmpS <<  epochs; vec.push_back(tmpS.str()); tmpS.str (""); tmpS.clear();

	
	char ** arr = new char*[vec.size()];
	for(size_t i = 0; i < vec.size(); i++){
		arr[i] = new char[vec[i].size() + 1];
		strcpy(arr[i], vec[i].c_str());
	}
	
	
	// initalize the options
	if (verbose == true) {
		Rcout << "Parameters:\n";
	}

	
	char input_file_name[1024];
	char model_file_name[1024];
	std::string s = "dummy";
	strcpy (input_file_name, s.c_str());
	strcpy (model_file_name, s.c_str());
	
	la_svm_parse_command_line (vec.size(), arr, input_file_name, model_file_name);

	// remove our temporary arguments array
	for(size_t i = 0; i < vec.size(); i++){
		delete [] arr[i];
	}
	delete [] arr;
	
	// convert data into libsvm format
	lasvm_sparsevector_t* v;
	for (int i = 0; i < x.rows(); i++) {
		v = lasvm_sparsevector_create();
		X.push_back(v);
		
		for (int j = 0; j < x.cols(); j++) {
			if (x(i, j) != 0)
				lasvm_sparsevector_set(X[i], j, x(i, j));
		}
	}
	adapt_data (x.rows());
	max_index = x.cols();
	
	Y.resize(y.size());
	for (int i = 0; i < y.size(); i++) {
		Y[i] = round(y[i]);
	}
	
	
	// now start training
	train_online(model_file_name, input_file_name);
	
	if (verbose == TRUE)
		Rcout << count_svs() << " support vectors found.\n";
	
	// extract SVs
	NumericMatrix SV (count_svs(), x.cols());
	NumericVector elif (count_svs()); // alpha
	
	int c = 0;
	for(int j=0; j<2; j++) {
		for(int i=0; i<x.rows(); i++) {
			if (j==0 && Y[i]==-1) continue;
			if (j==1 && Y[i]==1) continue;
			if (alpha[i]*Y[i]< alpha_tol) continue; // not an SV
			
			elif [c] = alpha[i];
			
			lasvm_sparsevector_pair_t *p1 = X[i]->pairs;
			while (p1) {
				SV (c, p1->index) = p1->data;
				p1 = p1->next;
			}
			c++;
		}
	}
	
	// return list
	Rcpp::List rl = Rcpp::List::create (
		Rcpp::Named ("SV", SV),
		Rcpp::Named ("alpha", elif)
	);
		
	return (rl);
}




//' lasvmTrain
//' 
//' Use lasvm to train a given problem.
//'
//'  @param	x		data matrix 
//'  @param	rounds		number of rounds (orthogonal views)
//'  @param	k		number of clusters
//'  @param	iter	numer of iterations in one round
//'  @param	initType		centroid initialization via Random or KMeans++
//'  @param	verbose		verbose output?
//'
//'  @return	a list consisting of
//'	centers	these are the resulting centroids of the kmean algorithm (as a std::vector of NumericMatrix)
//'	cluster 	these are the labels for the resulting clustering (as a std::vector of NumericVector)
//'	obj			this is a vector with the final objective value for each round
//'
//; @TODO: support other kernels than RBF
//'
// [[Rcpp::export]]
List lasvmPredictWrapper(
	Rcpp::NumericMatrix x,
	Rcpp::NumericMatrix SV,
	Rcpp::NumericVector elif,
	double gamma,
	double bias,
	bool verbose = false
)
{
	// copy alpha over to lasvm
	alpha.clear();
	std::copy (elif.begin(), elif.end(), alpha.begin());

	// copy SV over to lasvm
	msv = elif.size();
	lasvm_sparsevector_t* v;
	for (int i = 0; i < msv; i++) {
		v = lasvm_sparsevector_create();
		Xsv.push_back(v);
		
		for (int j = 0; j < x.cols(); j++) {
			if (x(i, j) != 0)
				lasvm_sparsevector_set(X[i], j, x(i, j));
				lasvm_sparsevector_set(Xsv[i], j, x(i,j) );
		}
	}
	
	if (kernel_type==RBF)
	{
		xsv_square.resize(msv);
		for (int i=0;i<msv;i++)
			xsv_square[i] = lasvm_sparsevector_dot_product(Xsv[i],Xsv[i]);
	}
	
	max_index = x.cols();
	
	
	// copy over data 
	for (int i = 0; i < x.rows(); i++) {
		v = lasvm_sparsevector_create();
		X.push_back(v);
		
		for (int j = 0; j < x.cols(); j++) {
			if (x(i, j) != 0)
				lasvm_sparsevector_set(X[i], j, x(i, j));
		}
	}
	adapt_data (x.rows());
	max_index = x.cols();
	
	// make sure all needed vars are set
	// kernel_type
	// gamma
	kgamma = gamma;
	b0 = bias;	
	
	// compute predictions
	NumericVector predictions (x.rows());
	for (int i=0;i<m;i++)	{
		double y=-b0;
		
		for(int j=0;j<msv;j++) {
			y+=alpha[j]*kernel(i,j,NULL);
		}

		if(y>=0) 
			y=1; 
		else 
			y=-1; 
		
		predictions[i] = y;
	}

	// return list
	Rcpp::List rl = Rcpp::List::create (
		Rcpp::Named ("predictions", predictions)
//		Rcpp::Named ("alpha", elif)
	);
	
	return (rl);
}

