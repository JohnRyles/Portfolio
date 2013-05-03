// Author: John Ryles
// Date: February 6th, 2013
// Program Purpose: This is an implementation of CS321
// Homework assignment #2. This program finds the root of
// the equation by using Newton's method using double 
// precision. I was given x0 to be 0.49 and to iterate
// a number of 5 times.
//
// Equation: 
//		f(x) = 2x(1-x^2+x)ln(x) = x^2-1
//		in the interval [0,1]

// Includes used
#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

// Epsilon value
const double EPSILON = 0.000001;

// Main function
int main()
{
	// Variables used
	double x0 = 0.49;
	double x1 = 0.0;
	double fx,fx1;

	// Iterate 5 times
	for(int i = 0; i < 6; i++)
	{
		fx = (2*x0)*( 1-pow(x0,2)+x0 )*log(x0)-pow(x0,2)+1;
		fx1 = -2*(x0-1)*(x0+(3*x0+1)*log(x0)+1);
		x1 = x0 - (fx/fx1);
		cout << "Old xn: " << setprecision(20) << x0 << endl;
		cout << "fx: " << fx << endl;
		cout << "fx1: " << fx1 << endl;
		cout << "New xn: " << setprecision(20) << x1 << endl;
		x0 = x1;
		cout << endl << endl;
	}
	return 0;
}
