
#include "life.h"

#include <iostream>
#include <iomanip>
#include <string>
#include <fstream>
#include <cmath>
#include <cassert>
using namespace std;

namespace dthorne0_life
{
Life::Life( const size_t ni, const size_t nj
          , const string filename, const string povfilename)
          : m_filename(filename)
          , m_povfilename(povfilename)
{
  m_max_ni = ni;
  m_max_nj = nj;
  m_ni = 0;
  m_nj = 0;

  // Make sure ni and nj are odd.
  if( (m_max_ni-1)%2) { m_max_ni++;}
  if( (m_max_nj-1)%2) { m_max_nj++;}

  m_i0 = (m_max_ni-1)/2;
  m_j0 = (m_max_nj-1)/2;

  m_grid = new char*[m_max_nj];
  int i, j;
  for( j=0; j<m_max_nj; j++)
  {
    m_grid[j] = new char[m_max_ni];
    for( i=0; i<m_max_ni; i++)
    {
      m_grid[j][i] = 0;
    }
  }

  m_num_generations = 0;

  m_fout = new ofstream;
  m_fout->open(filename.c_str());
  // Just initing the file to be empty for later appending.
  m_fout->close();

  m_povfout = new ofstream;
  m_povfout->open(povfilename.c_str());
  // Just initing the file to be empty for later appending.
  m_povfout->close();

}

Life::~Life()
{
  int j;
  for( j=0; j<m_max_nj; j++)
  {
    delete [] m_grid[j];
  }
  delete [] m_grid;
}

void Life::display( ostream& o) const
{
  int i, j;
  char glyphs[2] = { '-', 'O'};
  cout << "Generation " << m_num_generations << endl;
  for( j=m_max_nj-1; j>=0; j--)
  {
    for( i=0; i<m_max_ni; i++)
    {
      if( j!=m_j0)
      {
        cout << " " << glyphs[m_grid[j][i]];
      }
      else
      {
        if( i==m_i0)
        {
          cout << "(" << glyphs[m_grid[j][i]]; // Mark space before origin
        }
        else if( i==m_i0+1)
        {
          cout << ")" << glyphs[m_grid[j][i]]; // Mark space after origin
        }
        else
        {
          cout << " " << glyphs[m_grid[j][i]];
        }
      }
    }
    cout << "  //" << setw(4) << j << endl;
  }
}

void Life::birth( const int i, const int j)
{
  if( !coords_in_bounds(i+m_i0,j+m_j0)) { resize(i+m_j0,j+m_j0);}
  m_grid[j+m_j0][i+m_j0] = ALIVE;
}
void Life::death( const int i, const int j)
{
  if( !coords_in_bounds(i+m_j0,j+m_j0)) { return;}
  m_grid[j+m_j0][i+m_j0] = DEAD;
}

bool Life::coords_in_bounds( const size_t i, const size_t j) const
{
  // Ensure a two cell boundary layer of dead cells.
  return ( i>1 && i<m_max_ni-2 && j>1 && j<m_max_nj-2);
}

void Life::resize( const size_t i, const size_t j)
{
  cerr << "ERROR: Resize pending! (Exiting.)" << endl;
  exit(1);
}

void Life::resize_south()
{
  cout << "void Life::resize_south()" << endl;
  int i, j;
  char** temp;
  size_t new_max_nj = (m_max_nj-1)*2 + 1;
  cout << "                          "
       << m_max_ni << "x" << new_max_nj
       << " at generation "
       << m_num_generations
       << endl;
  temp = new char*[new_max_nj];
  for( j=0; j<m_max_nj; j++)
  {
    temp[j] = new char[m_max_ni];
    for( i=0; i<m_max_ni; i++)
    {
      temp[j][i] = DEAD;
    }
  }
  for( ; j<new_max_nj; j++)
  {
    temp[j] = m_grid[j-m_max_nj];
  }

  delete [] m_grid;
  m_grid = temp;

  // Update origin.
  m_j0 += ( new_max_nj - m_max_nj + 1);

  m_max_nj = new_max_nj;

}

void Life::resize_north()
{
  cout << "void Life::resize_north()" << endl;
  int i, j;
  char** temp;
  size_t new_max_nj = (m_max_nj-1)*2 + 1;
  cout << "                          "
       << m_max_ni << "x" << new_max_nj
       << " at generation "
       << m_num_generations
       << endl;
  temp = new char*[new_max_nj];
  for( j=0; j<m_max_nj; j++)
  {
    temp[j] = m_grid[j];
  }
  for( ; j<new_max_nj; j++)
  {
    temp[j] = new char[m_max_ni];
    for( i=0; i<m_max_ni; i++)
    {
      temp[j][i] = DEAD;
    }
  }

  delete [] m_grid;
  m_grid = temp;

  m_max_nj = new_max_nj;

}

void Life::resize_east()
{
  cout << "void Life::resize_east()" << endl;
  int i, j;
  char* temp;
  size_t new_max_ni = (m_max_ni-1)*2 + 1;
  cout << "                          "
       << new_max_ni << "x" << m_max_nj
       << " at generation "
       << m_num_generations
       << endl;
  for( j=0; j<m_max_nj; j++)
  {
    temp = new char[new_max_ni];
    for( i=0; i<m_max_ni; i++)
    {
      temp[i] = m_grid[j][i];
    }
    for( ; i<new_max_ni; i++)
    {
      temp[i] = DEAD;
    }
    delete [] m_grid[j];
    m_grid[j] = temp;
  }
  m_max_ni = new_max_ni;

}

void Life::resize_west()
{
  cout << "void Life::resize_west()" << endl;
  int i, j;
  char* temp;
  size_t new_max_ni = (m_max_ni-1)*2 + 1;
  cout << "                          "
       << new_max_ni << "x" << m_max_nj
       << " at generation "
       << m_num_generations
       << endl;
  for( j=0; j<m_max_nj; j++)
  {
    temp = new char[new_max_ni];
    for( i=0; i<m_max_ni; i++)
    {
      temp[i] = DEAD;
    }
    for( ; i<new_max_ni; i++)
    {
      temp[i] = m_grid[j][i-m_max_ni];
    }
    delete [] m_grid[j];
    m_grid[j] = temp;
  }

  // Update origin.
  m_i0 += ( new_max_ni - m_max_ni+1);

  m_max_ni = new_max_ni;

}

void Life::update( const size_t num_steps)
{
  int im, i, ip;
  int jm, j, jp;
  char temp, temp1, temp2, temp3;
  int sum;

  bool do_resize_north = false;
  bool do_resize_south = false;
  bool do_resize_east  = false;
  bool do_resize_west  = false;

  int n;

  m_fout->open(m_filename.c_str(),ios::app);
  m_povfout->open(m_povfilename.c_str(),ios::app);

  if( m_num_generations==0) { /*dump_coords();*/ dump_pov(0,num_steps-1);}

  for( n=0; n<num_steps; n++)
  {
    do_resize_north = false;
    do_resize_south = false;
    do_resize_east  = false;
    do_resize_west  = false;

    m_temp = new char[m_max_ni];
    for( i=0; i<m_max_ni; i++)
    {
      m_temp[i] = DEAD;
    }

#define UPDATE                                   \
      temp1 = m_temp[i];                           \
      temp = m_temp[i] = m_grid[j][i];             \
      sum = (    m_grid[j ][ip]                    \
            + /* m_grid[j ][im] */ temp3           \
            +    m_grid[jp][ip]                    \
            +    m_grid[jp][i ]                    \
            +    m_grid[jp][im]                    \
            + /* m_grid[jm][ip] */ m_temp[ip]      \
            + /* m_grid[jm][i ] */ temp1           \
            + /* m_grid[jm][im] */ temp2           \
            );                                     \
      if( sum!=2) { m_grid[j][i] = ( sum == 3);}   \
      temp2 = temp1;                               \
      temp3 = temp;

  //----------------------------------------------------------// First row
    j=1, jm=0, jp=2;
    temp = temp1 = temp2 = temp3 = DEAD;

    i=1, im=0, ip=2;
    UPDATE                                                    // First column
    if( !do_resize_south) { do_resize_south = ( sum == 3);}
    if( !do_resize_west ) { do_resize_west  = ( sum == 3);}

    for( i++, ip++, im++; i<m_max_ni-2; i++, ip++, im++)
    { UPDATE                                                  // Middle columns
      if( !do_resize_south) { do_resize_south = ( sum == 3);}}

    UPDATE                                                    // Last column
    if( !do_resize_south) { do_resize_south = ( sum == 3);}
    if( !do_resize_east ) { do_resize_east  = ( sum == 3);}

  //----------------------------------------------------------// Middle rows
    for( j++, jm++, jp++; j<m_max_nj-2; j++, jm++, jp++)
    {
      temp = temp1 = temp2 = temp3 = DEAD;

      i=1, im=0, ip=2;
      UPDATE                                                  // First column
      if( !do_resize_west ) { do_resize_west  = ( sum == 3);}

      for( i++, ip++, im++; i<m_max_ni-2; i++, ip++, im++)
      { UPDATE
      }                                               // Middle columns

      if( j==48 && i==31) { cout << temp1 << " " << temp2 << " " << temp3 << endl;}

      UPDATE                                                  // Last column
      if( j==48 && i==31) { cout << "sum(" << i << "," << j << ") = " << sum << endl;}
      if( !do_resize_east ) { do_resize_east  = ( sum == 3);}
    }

  //----------------------------------------------------------// Last row
    temp = temp1 = temp2 = temp3 = DEAD;

    i=1, im=0, ip=2;
    UPDATE                                                    // First column
    if( !do_resize_north) { do_resize_north = ( sum == 3);}
    if( !do_resize_west ) { do_resize_west  = ( sum == 3);}

    for( i++, ip++, im++; i<m_max_ni-2; i++, ip++, im++)
    { UPDATE                                                  // Middle columns
      if( !do_resize_north) { do_resize_north = ( sum == 3);}}

    UPDATE                                                    // Last column
    if( !do_resize_north) { do_resize_north = ( sum == 3);}
    if( !do_resize_east ) { do_resize_east  = ( sum == 3);}

  //----------------------------------------------------------//

  //cout << "   " << do_resize_north << endl;
  //cout << " "  << do_resize_west  << "   " << do_resize_east << endl;
  //cout << "   " << do_resize_south << endl;

    if( do_resize_north) { resize_north();}
    if( do_resize_south) { resize_south();}
    if( do_resize_west ) { resize_west ();}
    if( do_resize_east ) { resize_east ();}

    m_num_generations++;
    /*dump_coords();*/
    dump_pov( n+1, num_steps-1);
  }
  m_fout->close();
  m_povfout->close();
}

void Life::dump_coords()
{
  cout << "Updating file \"" << m_filename << "\"." << endl;
  (*m_fout) << "Generation " << m_num_generations << endl;
  //(*m_fout) << m_max_ni << "x" << m_max_nj << endl;
  int i, j;
  for( j=0; j<m_max_nj; j++)
  {
    for( i=0; i<m_max_ni; i++)
    {
      if( m_grid[j][i]==ALIVE)
      {
        (*m_fout) << i-int(m_i0) << " " << j-int(m_j0) << endl;
      }
    }
  }
}

void Life::dump_pov( const int cur_gen, const int num_gens)
{
  //cout << "Updating file \"" << m_povfilename << "\"." << endl;
  //(*m_povfout) << "Generation " << m_num_generations << endl;
  //(*m_povfout) << m_max_ni << "x" << m_max_nj << endl;
  int i, j;
  for( j=0; j<m_max_nj; j++)
  {
    for( i=0; i<m_max_ni; i++)
    {
      if( m_grid[j][i]==ALIVE)
      {
        (*m_povfout)
        << "box { "
        << "<" << i-int(m_i0) - 0.45
        << "," << j-int(m_j0) - 0.45
        << "," << m_num_generations - 0.45
        << "> "
        << "<" << i-int(m_i0) + 0.45
        << "," << j-int(m_j0) + 0.45
        << "," << m_num_generations + 0.45
        << "> "
        << "pigment { rgbf "
#if 0
        << "<" << abs(( (2*(i-int(m_i0)))%256)/255.)
        << "," << abs(( (2*(j-int(m_j0)))%256)/255.)
        //<< "," << abs(( (m_num_generations)%256)/255.)
        << "," << (-1+16*(1+rand()%32)/255.)
        << "> "
#else
#if 0
        << "<" << .7 + .3*(1. - m_num_generations%2)
        << "," << .7 + .3*(1. - m_num_generations%2)
        << "," << 1. //.7 + .3*(1. - m_num_generations%2)
        << "," << .9
        << "> "
#else
        //<< "<" << ((cur_gen!=0)?((cur_gen/double(num_gens))):(1.))
        << "<" << (cur_gen/double(num_gens))
        << "," << (cur_gen/double(num_gens))
        << "," << 1.
        << "," << 0.
        << "> "
#endif
#endif
        << "}"
        //<< " finish { ambient 1} "
        << "}"
        << endl;
      }
    }
  }
  if( cur_gen==num_gens)
  {
    // Done with current batch of updates, so update povlife.pov for
    // latest m_num_generations.
    ofstream fout;
    fout.open("povlife.pov");
    fout << "#version 3.6;" << endl;

    fout << "global_settings {" << endl;
    fout << "  assumed_gamma 1.0" << endl;
    fout << "  ambient_light color rgb <1,1,1>" << endl;
    fout << "}" << endl;

    fout << "camera {" << endl;
    fout << "  orthographic" << endl;
    fout << "  location <0,"
         << m_num_generations
         << ","
         << 2*m_num_generations
         << ">" << endl;
    fout << "  look_at  <0,"
         << 0
         << ",0>" << endl;
    fout << "  right "
         << 2*m_num_generations
         << "*x" << endl;
    fout << "  up "
         << 2*m_num_generations
         << "*(image_height/image_width)*y" << endl;
    fout << "}" << endl;

    fout << "light_source {" << endl;
    fout << "  0*x" << endl;
    fout << "  color rgb <1,1,1>" << endl;
    fout << "  translate <-200, "
         << 20*m_num_generations
         << ", 200>" << endl;
    fout << "}" << endl;
    fout << "light_source {" << endl;
    fout << "  0*x" << endl;
    fout << "  color rgb <1,1,1>" << endl;
    fout << "  translate <200, "
         << 2*m_num_generations
         << ", 20>" << endl;
    fout << "}" << endl;
    fout << "light_source {" << endl;
    fout << "  0*x" << endl;
    fout << "  color rgb <1,1,1>" << endl;
    fout << "  translate <-100, "
         << 20*m_num_generations
         << ",-70>" << endl;
    fout << "}" << endl;
    fout << "light_source {" << endl;
    fout << "  0*x" << endl;
    fout << "  color rgb <1,1,1>" << endl;
    fout << "  translate <"
         << m_num_generations/2.0
         << ", "
         << 0
         << ","
         << m_num_generations/2.0
         << ">" << endl;
    fout << "}" << endl;

#if 0
    fout << "light_source {" << endl;
    fout << "  0*x" << endl;
    fout << "  color rgb <1,0,1>" << endl;
    fout << "  spotlight" << endl;
    fout << "  translate <"
         << -double(m_num_generations)/2.0
         << ", "
         << -double(m_num_generations)/2.0 - 1.
         << ", "
         << -double(m_num_generations)/2.0
         << ">" << endl;
    fout << "  point_at <0, "
         << m_num_generations/2.0
         << ", 0>" << endl;
    fout << "  radius 5" << endl;
    fout << "  tightness 5" << endl;
    fout << "  falloff 8" << endl;
    fout << "}" << endl;
#endif


    fout << "#declare thing = union" << endl;
    fout << "{" << endl;
    fout << "#include \"povlife.inc\"" << endl;
    fout << "}" << endl;

    fout << "plane { <0,1,0>, " << -double(m_num_generations)/2.0 - 1.5
         << " pigment { rgb <1,.3,1>}"
         << " finish { reflection .5}"
         << "}"
         << endl;

    fout << "cylinder { <0,-9999,0>,<0,9999,0>,.1 "
         << "pigment { rgb <1,0,1>}}" << endl;

    fout << "object { thing rotate 90*x translate "
         << m_num_generations/2.
         << "*y rotate clock*360*y "
         //<< "rotate 45*x "
         << "scale "
         << 1 //0.6/m_num_generations
         << "}" << endl;

    //object { thing rotate 180*x scale .007}

    // R Pentominoe
    // object { thing rotate 90*x rotate 20*y translate 2*270*y rotate 1*x scale .02 translate -.4*x }

    fout.close();
  }
}

ostream& operator<<( ostream& o, const Life& life)
{
  life.display(o);
  return o;
}

}
