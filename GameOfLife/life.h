
#include <iostream>
#include <string>
#include <fstream>

namespace dthorne0_life
{
class Life
{
public:
  enum { DEAD, ALIVE};
  Life( const size_t ni=33, const size_t nj=33
      , const std::string filename = "life.dat"
      , const std::string povfilename = "povlife.inc");
  ~Life();

  void display( std::ostream& o) const;

  void birth( const int i, const int j);
  void death( const int i, const int j);

  void update( const size_t num_steps = 1);

private:
//##############################################################################
  char** m_grid;
  char*  m_temp; // temp row during update
  size_t m_ni;
  size_t m_max_ni;
  size_t m_nj;
  size_t m_max_nj;

  // Origin
  size_t m_i0;
  size_t m_j0;

  size_t m_num_generations;

  std::string m_filename;
  std::string m_povfilename;
  std::ofstream* m_fout;
  std::ofstream* m_povfout;

//########################################################## H E L P E R S #####
  bool coords_in_bounds( const size_t i, const size_t j) const;
  void resize( const size_t i, const size_t j);
  void resize_north();
  void resize_south();
  void resize_east();
  void resize_west();

  void dump_coords();
  void dump_pov( const int cur_gen, const int num_gens);

};

std::ostream& operator<<( std::ostream& o, const Life& life);

}
