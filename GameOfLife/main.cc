
#include <iostream>
#include <iomanip>
using namespace std;

#include "life.h"
using namespace dthorne0_life;

int main()
{
  Life life;
  // R Pentominoe
  //life.birth( 0, 0);
  //life.birth( 0, 1);
  //life.birth( 0,-1);
  //life.birth( 1, 1);
  //life.birth(-1, 0);

  // Hexominoe
  //life.birth( 0, 0);
  //life.birth( 0, 1);
  //life.birth( 0,-1);
  //life.birth( 1, 1);
  //life.birth(-1, 0);
  //life.birth( 1,-1);

  // Stick figure thing
  //life.birth(-2, 0);
  //life.birth(-1, 0);
  //life.birth( 0,-3); life.birth( 0,-2); life.birth( 0,-1); life.birth( 0, 0);
  //life.birth( 1, 0);
  //life.birth( 2,-2); life.birth( 2,-1);
  //life.birth( 2, 0);
  //life.birth( 2, 1); life.birth( 2, 2); life.birth( 2, 3); life.birth( 2, 4);

  // Stick thing variation
  //life.birth(-2, 0);
  //life.birth(-1, 0);
  //life.birth( 0,-3); life.birth( 0,-2); life.birth( 0,-1);
  //life.birth( 1, 0);
  //life.birth( 2,-2); life.birth( 2,-1);
  //life.birth( 2, 0);
  //life.birth( 2, 1); life.birth( 2, 2); life.birth( 2, 3); life.birth( 2, 4);

  // Glider 1
  //life.birth( 0, 0);
  //life.birth( 1, 0);
  //life.birth( 2, 0);
  //life.birth( 2, 1);
  //life.birth( 1, 2);
  // Glider 2
  //life.birth( 0, 0);
  //life.birth( 1, 0);
  //life.birth( 1, 1);
  //life.birth( 0,-1);
  //life.birth(-1, 1);

  // Glider tweak 1 // 21 gens
  //life.birth( 0, 0);
  //life.birth( 1, 0);
  //life.birth( 2, 0);
  //life.birth( 2, 1);
  //life.birth( 1, 2);
  //life.birth( 3,-1);

  // Glider tweak 2 // 180 gens
  //life.birth( 0, 0);
  //life.birth( 1, 0);
  //life.birth( 2, 0);
  //life.birth( 2, 1);
  //life.birth( 1, 2);
  //life.birth( 2,-1);
  //life.birth(-1,-1);

  // Scorpion // 30 gens
  //life.birth( 0, 0);
  //life.birth( 1, 0);
  //life.birth( 2, 0);
  //life.birth( 3, 0);
  //life.birth( 3, 1);
  //life.birth( 2, 2);
  //life.birth(-1,-1);
  //life.birth(-2,-1);
  //life.birth(-1, 1);
  //life.birth(-2, 1);

  // Scorpion long // 1104 gens (with glider production)
  //life.birth( 0, 0);
  //life.birth( 1, 0);
  //life.birth( 2, 0);
  //life.birth( 3, 0);
  //life.birth( 4, 0);
  //life.birth( 4, 1);
  //life.birth( 3, 2);
  //life.birth(-1,-1);
  //life.birth(-2,-1);
  //life.birth(-1, 1);
  //life.birth(-2, 1);

  // Scorpion long, asymmetric // 184 gens (with glider production)
  //life.birth( 0, 0);
  //life.birth( 1, 0);
  //life.birth( 2, 0);
  //life.birth( 3, 0);
  //life.birth( 4, 0);
  //life.birth( 4, 1);
  //life.birth( 3, 2);
  //life.birth(-1,-1);
  //life.birth(-2,-1);
  //life.birth(-3,-1);
  //life.birth(-1, 1);
  //life.birth(-2, 1);

  // Oscillator Synth (13+15n)
  //int i0=1, j0=2;
  //life.birth(i0+ 0,j0+ 0); life.birth(i0+ 1,j0+ 0); life.birth(i0+ 2,j0+ 0);
  //life.birth(i0+ 0,j0+-1); life.birth(i0+ 1,j0+-2);
  //life.birth(i0+-2,j0+ 3); life.birth(i0+-1,j0+ 2);
  //life.birth(i0+ 0,j0+ 2); life.birth(i0+ 0,j0+ 3); life.birth(i0+ 0,j0+ 4);
  //life.birth(i0+-2,j0+-3); life.birth(i0+-4,j0+-3); life.birth(i0+-2,j0+-4);
  //life.birth(i0+-3,j0+-4); life.birth(i0+-3,j0+-5);

  // 8 Line (50 gens)
  //life.birth(-4,0);
  //life.birth(-3,0);
  //life.birth(-2,0);
  //life.birth(-1,0);
  //life.birth( 0,0);
  //life.birth( 1,0);
  //life.birth( 2,0);
  //life.birth( 3,0);

  // 13 Line (25 gens)
  //life.birth(-6,0);
  //life.birth(-5,0);
  //life.birth(-4,0);
  //life.birth(-3,0);
  //life.birth(-2,0);
  //life.birth(-1,0);
  //life.birth( 0,0);
  //life.birth( 1,0);
  //life.birth( 2,0);
  //life.birth( 3,0);
  //life.birth( 4,0);
  //life.birth( 5,0);
  //life.birth( 6,0);

  // 13 Line with tick (216 gens)
  //life.birth(-6,0);
  //life.birth(-5,0);
  //life.birth(-4,0);
  //life.birth(-3,0);
  //life.birth(-2,0);
  //life.birth(-1,0);
  //life.birth( 0,0); life.birth( 0,1);
  //life.birth( 1,0);
  //life.birth( 2,0);
  //life.birth( 3,0);
  //life.birth( 4,0);
  //life.birth( 5,0);
  //life.birth( 6,0);

  // 13 Line with tick (280 gens)
  life.birth(-6,0);
  life.birth(-5,0);
  life.birth(-4,0);
  life.birth(-3,0);
  life.birth(-2,0);
  life.birth(-1,0);
  life.birth( 0,0);
  life.birth( 1,0);
  life.birth( 2,0);
  life.birth( 3,0);
  life.birth( 4,0);
  life.birth( 5,0);
  life.birth( 6,0); life.birth( 6,1);



  // Box
  //int i, j;
  //int n = 4;
  //for( j=0; j<=n; j++)
  //{
  //  life.birth( n, j);
  //  life.birth( n,-j-1);
  //  life.birth(-n-1, j);
  //  life.birth(-n-1,-j-1);
  //  life.birth( j, n);
  //  life.birth(-j, n);
  //  life.birth( j,-n-1);
  //  life.birth(-j-1,-n-1);
  //}
  //life.birth( n+1, -n-2);
  //life.birth( n+1, n);
  //life.birth(-n, n+1);
  //life.birth(-n-2,-n+1);
  ////life.death(  n  , n-4);

#if 1
  cout << life << endl;
  life.update(280);
  cout << life << endl;
#else
  cout << life << endl;
  life.update();
  cout << life << endl;
  life.update();
  cout << life << endl;
  life.update();
  cout << life << endl;
  life.update();
  cout << life << endl;
  life.update();
  cout << life << endl;
  life.update();
  cout << life << endl;
  life.update();
  cout << life << endl;
  life.update();
  cout << life << endl;
  life.update(4);
  cout << life << endl;
  life.update(6);
  cout << life << endl;
  life.update(1);
  cout << life << endl;
  life.update(1);
  cout << life << endl;
  life.update(1);
  cout << life << endl;
  life.update(1);
  cout << life << endl;
  life.update(1);
  cout << life << endl;
  life.update(1);
  cout << life << endl;
  life.update(1);
  cout << life << endl;
  life.update(1);
  cout << life << endl;
  life.update(1);
  cout << life << endl;
  //life.update(64);
  //cout << life << endl;
  //life.update(3150);
  //cout << life << endl;
//life.update(1024);
//cout << life << endl;
#endif

#if 0
  char c;
  for( c=32; c<127; c++)
  {
    cout << " " << c << " 0x" << hex << int(c) << dec << setw(4) << int(c) << endl;
  }
#endif

  return 0;
}
