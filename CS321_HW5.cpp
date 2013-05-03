// Name: John Ryles
// Date: April 16th, 2013
// Program Purpose: This is an implementation of
// problem 4 on CS321 Homework #5. This program
// implements Jacobi and Gauss-Seidel
// iterative methods on the given system of
// linear equations given on the HW sheet.
//
// Equations: 
//		[  7   1  -1   2  ] [ x1 ] = [  3  ] 
//		[  1   8   0  -2  ] [ x2 ] = [ -5  ]
//		[ -1   0   4  -1  ] [ x3 ] = [  4  ]
//		[  2  -2  -1   6  ] [ x4 ] = [ -3  ]
//
// Hint: Exact solution is x = (1, -1, 1, -1)

// Includes used
#include<iostream>
#include<math.h>
#include<iomanip>

using namespace std;

// Main function
int main()
{
	// initialize variables
	float x0, y0, z0, w0, x1, y1, z1, w1;
	int n;

	// print equations
	cout << "7x + 1y - 1z + 2w = 3" << endl;
	cout << "1x + 8y + 0z - 2w = -5" << endl;
	cout << "-1x + 0y + 4z - 1w = 4" << endl;
	cout << "2x - 2y - 1z + 6w = -3" << endl;

	// prompt user for number of iterations
	cout << "Enter number of iterations -> ";
	cin >> n;

	// run jacobi method
	cout << endl << "Running Jacobi Method: " << endl;

	// initial guess is (0,0,0,0)
	x0 = 0;
	y0 = 0;
	z0 = 0;
	w0 = 0;

	// loop to solve
	for(int i = 1; i <= n; i++)
	{
		// preform algorithm
		x1 = (1/7.0)*(3-y0+z0-(2*w0));
		y1 = (1/8.0)*(-5-x0+(2*w0));
		z1 = (1/4.0)*(4+x0+w0);
		w1 = (1/6.0)*(-3-(2*x0)+(2*y0)+z0);

		// display results
		cout << "x1" << " = " << setprecision(4) << x1 << "  ";
		cout << "x2" << " = " << setprecision(4) << y1 << "  ";
		cout << "x3" << " = " << setprecision(4) << z1 << "  ";
		cout << "x4" << " = " << setprecision(4) << w1 << endl;

		// set values for next iteration
		x0 = x1;
		y0 = y1;
		z0 = z1;
		w0 = w1;
		// Quick exit since it solves by 15 iterations
		if(i == 15)
		{
			cout << "Solved in " << i << " iterations" << endl;
			i = n+1;
		}
	}

	// run gauss-seidel method
	cout << endl << "Running Gauss-Siedel Method:" << endl;

	// initial guess is (0,0,0,0)
        x0 = 0;
        y0 = 0;
        z0 = 0;
        w0 = 0;

        // loop to solve
        for(int i = 1; i <= n; i++)
        {
                // preform algorithm
                x1 = (1/7.0)*(3-y0+z0-(2*w0));
                y1 = (1/8.0)*(-5-x1+(2*w0));
                z1 = (1/4.0)*(4+x1+w0);
                w1 = (1/6.0)*(-3-(2*x1)+(2*y1)+z1);

                // display results
                cout << "x1" << " = " << setprecision(4) << x1 << "  ";
                cout << "x2" << " = " << setprecision(4) << y1 << "  ";
                cout << "x3" << " = " << setprecision(4) << z1 << "  ";
                cout << "x4" << " = " << setprecision(4) << w1 << endl;

                // set values for next iteration
                x0 = x1;
                y0 = y1;
                z0 = z1;
                w0 = w1;
		
		// Quick exit as this is solved in 8 iterations
		if(i == 8)
		{
			cout << "Solved in " << i << " iterations" << endl;
			i = n+1;
		}
	}

	// end program
	return 0;
}
