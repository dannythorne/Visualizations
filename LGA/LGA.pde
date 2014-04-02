
float g_x0, g_y0; // coord of top-left corner of display
float g_dx, g_dy; // size of pixel
float g_lu; // size (scale factor) of lattice unit
float g_cospio3 = sqrt(3)/2;

boolean g_body_force = false;
boolean g_velocity_bc = true;

HexGrid g_grid;

PFont g_font_times;

boolean g_list_all = false;

boolean g_tick_on = false;

//##############################################################################
void setup() {

  if( g_list_all) { size(800,600); noLoop(); smooth();}
             else { size(400,300);}

  background(187,187,170);

  int ni, nj;

  if( g_list_all) { ni=nj=8  ;}
             else { ni=nj=125;}

  g_grid = new HexGrid( ni, nj);

  g_dx = 1;
  g_dy = 1;
  g_lu = width/10;
  g_x0 = g_lu*g_dx*(5./8.); //width/2 - g_lu*g_dx;
  g_y0 = g_lu*g_dy*(5./8.); // height/2 - (((float)(nj-1)/2)*g_lu*g_cospio3)*g_dy;

  g_font_times = loadFont("Times-Bold-24.vlw");

}

//##############################################################################
void draw() {

  background(187,187,170);

  // Axes
  stroke(192,192,176);
  line(       0,     g_y0, width  ,   g_y0);
  line(    g_x0,        0,    g_x0, height);

  if( g_tick_on) { g_grid.tick(1);}
  g_grid.draw();

  if(false) {

    strokeWeight(4);
    stroke(  0,255,  0);
    line(    g_x0, g_y0, g_x0+g_lu, g_y0);
    stroke(  0,  0,255);
    line(    g_x0, g_y0, g_x0, g_y0+g_lu);

    strokeWeight(1);
    stroke(192,192,176);
  }

  // Origin
  stroke(192,192,176);
  fill(192,192,176);
  ellipse( g_x0, g_y0, 3, 3);

  //save("list_all.png");

}

//##############################################################################
class HexGrid {

  int m_ni, m_nj;
  int m_ave_size = 5;

  float m_h = width/10;
  float m_hsin60 = m_h*g_cospio3;

  int[] m_vmap = new int[256];

  class HexNode {

    float m_x, m_y; // coord of node in plane
    float m_h; // size of mesh

    boolean

      m_v1=false,
      m_v2=false,
      m_v3=false,
      m_v4=false,
      m_v5=false,
      m_v6=false,

      m_random = false,
      m_solid  = false;

    boolean m_label_dirs = false;

    int m_v, m_nv;

    HexNode( float x, float y, float h, int i, int j) {

      m_x = x;
      m_y = y;
      m_h = h;
      m_nv = 0;

      if( g_list_all) {

        m_v = int(j*m_ni + i);
        println(m_v + " " + binary(m_v) +
        " (" +
        (m_v & 0x1) +
        "," +
        (m_v & 0x2) +
        "," +
        (m_v & 0x4) +
        "," +
        (m_v & 0x8) +
        "," +
        (m_v & 0x10) +
        "," +
        (m_v & 0x20) +
        ")");
        if( (m_v & 0x1 ) == 1 ) { m_v1 = true; m_nv++;}
        if( (m_v & 0x2 ) == 2 ) { m_v2 = true; m_nv++;}
        if( (m_v & 0x4 ) == 4 ) { m_v3 = true; m_nv++;}
        if( (m_v & 0x8 ) == 8 ) { m_v4 = true; m_nv++;}
        if( (m_v & 0x10) == 16) { m_v5 = true; m_nv++;}
        if( (m_v & 0x20) == 32) { m_v6 = true; m_nv++;}
        println(m_nv);
      }
      else {

        // Randomly assign velocities in the six directions.
        if( floor(random(6))==0) { m_v1=true;} else { m_v1=false;}
        if( floor(random(6))==0) { m_v2=true;} else { m_v2=false;}
        if( floor(random(6))==0) { m_v3=true;} else { m_v3=false;}
        if( floor(random(6))==0) { m_v4=true;} else { m_v4=false;}
        if( floor(random(6))==0) { m_v5=true;} else { m_v5=false;}
        if( floor(random(6))==0) { m_v6=true;} else { m_v6=false;}
        if( floor(random(2))==0) { m_random=true;} else { m_random=false;}
        m_solid = false;

        // Encode the six velocities into a single integer along with a random
        // bit. (TODO: Should use a single byte for this.) NOTE: The eighth bit
        // (0x80 = 1000 0000) is used to encode solids.
        m_v = 0;
        m_v |= ((m_v1)?(0x1 ):(0));
        m_v |= ((m_v2)?(0x2 ):(0));
        m_v |= ((m_v3)?(0x4 ):(0));
        m_v |= ((m_v4)?(0x8 ):(0));
        m_v |= ((m_v5)?(0x10):(0));
        m_v |= ((m_v6)?(0x20):(0));
        m_v |= ((m_random)?(0x40):(0));
        m_v |= ((m_solid)?(0x80):(0));
      }
    }

    void draw( float dx, float dy) {

      float x0 = m_x*g_dx+g_x0;
      float y0 = g_dy*m_y+g_y0;
      float pt9dx = .9*dx;
      float pt9dy = .9*dy;

      // Display velocity in direction 1.
      stroke(128,128,112);
      line( x0, y0, x0+dx  , y0   );
      //if( m_v1)
      if( (m_v & 0x1) != 0)
      {
        strokeWeight(4);
        stroke( ((is_solid())?(0):(255)),  0,  0);
        line( x0, y0, x0+pt9dx  , y0   );
        strokeWeight(1);
      }

      // Display velocity in direction 2.
      stroke(128,128,112);
      line( x0, y0, x0+dx/2, y0+dy);
      //if( m_v2)
      if( (m_v & 0x2) != 0)
      {
        strokeWeight(4);
        stroke( ((is_solid())?(0):(255)),  0,  0);
        line( x0, y0, x0+pt9dx/2, y0+pt9dy);
        strokeWeight(1);
      }

      // Display velocity in direction 3.
      stroke(128,128,112);
      line( x0, y0, x0-dx/2, y0+dy);
      //if( m_v3)
      if( (m_v & 0x4) != 0)
      {
        strokeWeight(4);
        stroke( ((is_solid())?(0):(255)),  0,  0);
        line( x0, y0, x0-pt9dx/2, y0+pt9dy);
        strokeWeight(1);
      }

      // Display velocity in direction 4.
      stroke(128,128,112);
      line( x0, y0, x0-dx  , y0   );
      //if( m_v4)
      if( (m_v & 0x8) != 0)
      {
        strokeWeight(4);
        stroke( ((is_solid())?(0):(255)),  0,  0);
        line( x0, y0, x0-pt9dx  , y0   );
        strokeWeight(1);
      }

      // Display velocity in direction 5.
      stroke(128,128,112);
      line( x0, y0, x0-dx/2, y0-dy);
      //if( m_v5)
      if( (m_v & 0x10) != 0)
      {
        strokeWeight(4);
        stroke( ((is_solid())?(0):(255)),  0,  0);
        line( x0, y0, x0-pt9dx/2, y0-pt9dy);
        strokeWeight(1);
      }

      // Display velocity in direction 6.
      stroke(128,128,112);
      line( x0, y0, x0+dx/2, y0-dy);
      //if( m_v6)
      if( (m_v & 0x20) != 0)
      {
        strokeWeight(4);
        stroke( ((is_solid())?(0):(255)),  0,  0);
        line( x0, y0, x0+pt9dx/2, y0-pt9dy);
        strokeWeight(1);
      }

      if( false) // is_solid())
      {
        stroke(0,0,0);
        fill(0,0,0);
        ellipse( x0, y0, g_dx*m_h, g_dy*m_h);
      }

      if( g_list_all) {
        color c;
        switch(m_nv)
        {
          case  2: c = color(255,255,  0); break;
          case  3: c = color(  0,255,255); break;
          default: c = color(134,134,119); break;
        }
        c = color(255,255,255);
        println(red(c)+" "+green(c)+" "+blue(c));
        fill(c);
        textFont(g_font_times,24);
        textAlign(CENTER);
        text(m_v,x0,y0+8);
      }

    } // void draw()

    boolean is_solid() { return (m_v & 0x80) == 0x80;}

  } // class HexNode

  HexNode[][] nodes;

  HexGrid( int ni, int nj) {

    m_ni = ni;
    m_nj = nj;
    nodes = new HexNode[m_ni][m_nj];
    int i, j;
    int n;
    float rowoff = 0; // Offset every other row to get hex pattern.

    for( j=0; j<m_nj; j++) {
      for( i=0; i<m_ni; i++) {

        nodes[i][j] = new HexNode( 0+i*m_h+rowoff, 0+j*m_hsin60, m_h, i, j);
      }
      if( rowoff==0) { rowoff=.5*m_h;} else { rowoff=0;}
    }

    if( !g_list_all) {

      if( true)
      {
        // A solid obstacle.
        for( j=floor(.35*nj); j<floor(.65*nj); j++) {
          for( i=floor(.5*ni); i<floor(.5*ni)+1; i++) {

            nodes[i][j].m_v = 0x80; // 1000 0000
            nodes[i][j].m_solid = true;
          }
        }
      }
      else if( false)
      {
        // Solid walls on top and bottom.
        for( i=0; i<ni; i++)
        {
          nodes[i][0].m_v = 0x80; // 1000 0000
          nodes[i][0].m_solid = true;

          nodes[i][nj-1].m_v = 0x80; // 1000 0000
          nodes[i][nj-1].m_solid = true;
        }
      }
      else
      {
        // No solids.
      }
    } // if( !g_list_all)

    // Build collision map for non-solids.
    // Bit 2^64 is the random bit.
    for( n=0; n<64; n++)
    { m_vmap[  n   ] =  n   ;
      m_vmap[  n+64] =  n+64; }

    // Special cases:

    m_vmap[  9   ] = (int)((floor(random(2))==0)?(18):(64+18));
    m_vmap[  9+64] = (int)((floor(random(2))==0)?(36):(64+36));
    m_vmap[ 18   ] = (int)((floor(random(2))==0)?( 9):(64+ 9));
    m_vmap[ 18+64] = (int)((floor(random(2))==0)?(36):(64+36));
    m_vmap[ 36   ] = (int)((floor(random(2))==0)?( 9):(64+ 9));
    m_vmap[ 36+64] = (int)((floor(random(2))==0)?(18):(64+18));

    m_vmap[ 21   ] = 42;
    m_vmap[ 21+64] = 42+64;
    m_vmap[ 42   ] = 21;
    m_vmap[ 42+64] = 21+64;

  //m_vmap[ 26   ] = 44;
  //m_vmap[ 26+64] = 44+64;
  //m_vmap[ 44   ] = 26;
  //m_vmap[ 44+64] = 26+64;

  //m_vmap[ 19   ] = 37;
  //m_vmap[ 19+64] = 37+64;
  //m_vmap[ 37   ] = 19;
  //m_vmap[ 37+64] = 19+64;

  //m_vmap[ 27   ] = (int)((floor(random(2))==0)?(45):(64+45));
  //m_vmap[ 27+64] = (int)((floor(random(2))==0)?(54):(64+54));
  //m_vmap[ 45   ] = (int)((floor(random(2))==0)?(27):(64+27));
  //m_vmap[ 45+64] = (int)((floor(random(2))==0)?(54):(64+54));
  //m_vmap[ 54   ] = (int)((floor(random(2))==0)?(27):(64+27));
  //m_vmap[ 54+64] = (int)((floor(random(2))==0)?(45):(64+45));

    // Build collision map for solids.
    // Solids with leading bit (2^128) set.
    for( n=0; n<64; n++) { j = n/8; i = n%8;
      //println(n+" = ("+i+","+j+")");
      m_vmap[  n   +128] =  j+8*i    +128;
      m_vmap[  n+64+128] =  j+8*i +64+128;
    }

  } // HexGrid( int ni, int nj)

  void draw() {

    int i , j ;
    int ii, jj;
    float vx, vy;
    float x , y ;
    float x0, y0;
    float rowoff = 0;

    if( m_ave_size > 1) {

      if( m_ave_size%5 != 0)
      {
        println("Only multiples of 5 averaging implemented so far.");
        m_ave_size -= m_ave_size%5;
      }
      for( j=0; j<m_nj; j+=m_ave_size)
      {
        for( i=0; i<m_ni; i+=m_ave_size)
        {
          vx = 0;
          vy = 0;
          for( jj=j; jj<j+m_ave_size; jj++)
          {
            for( ii=i; ii<i+m_ave_size; ii++)
            {
              vx += ((nodes[ii][jj].m_v1)?(1):(0));
              vx += ((nodes[ii][jj].m_v2)?(.5):(0));
              vx += ((nodes[ii][jj].m_v3)?(-.5):(0));
              vx += ((nodes[ii][jj].m_v4)?(-1):(0));
              vx += ((nodes[ii][jj].m_v5)?(-.5):(0));
              vx += ((nodes[ii][jj].m_v6)?(.5):(0));

              vy += ((nodes[ii][jj].m_v2)?(g_cospio3):(0));
              vy += ((nodes[ii][jj].m_v3)?(g_cospio3):(0));
              vy += ((nodes[ii][jj].m_v5)?(-g_cospio3):(0));
              vy += ((nodes[ii][jj].m_v6)?(-g_cospio3):(0));

              if( nodes[ii][jj].is_solid())
              {
                // TODO: Draw a black hexagon at (ii+rowoff,jj).
                x = (ii)*m_h+rowoff;
                y = (jj)*m_hsin60;
                x0 = x*g_dx+g_x0;
                y0 = g_dy*y+g_y0;
                stroke(0,0,0);
                fill(0,0,0);
                ellipse( x0, y0, g_dx*m_h, g_dy*m_h);
              }
            }
            if( rowoff==0) { rowoff=.5*m_h;} else { rowoff=0;}
          }
          x = (i+2)*m_h+rowoff;
          y = (j+2)*m_hsin60;
          x0 = x*g_dx+g_x0;
          y0 = g_dy*y+g_y0;
          vx /= (m_ave_size*m_ave_size/25);
          vy /= (m_ave_size*m_ave_size/25);

          stroke(  0,  0,255);
          line( x0, y0, x0+vx*g_dx*m_ave_size, y0-vy*g_dy*m_ave_size);
        }
      }
    } // if( m_ave_size > 1)
    else {

      float dx = m_h*g_dx/2;
      float dy = g_dy*m_h*g_cospio3/2;

      for( j=0; j<m_nj; j++)
      {
        for( i=0; i<m_ni; i++)
        {
          nodes[i][j].draw(dx,dy);
        }
      }
    } // if( m_ave_size > 1) else

  } // void draw()

  void stream() {

    int i , j ;
    int im, jm;
    int ip, jp;

    // Traverse pairs of rows, swapping adjacent velocities between nodes. This
    // will leave the velocities pointing backwards which will then be
    // corrected in a separate step after this loop.
    for( j=0; j<m_nj; j++) {

      jp = ((j<m_nj-1)?(j+1):(     0));
      jm = ((j>     0)?(j-1):(m_nj-1));

      for( i=0; i<m_ni; i++) {

        ip = ((i<m_ni-1)?(i+1):(     0));
        im = ((i>     0)?(i-1):(m_ni-1));

        // 4 --  -- 1
        if( nodes[i][j].m_v1 != nodes[ip][j].m_v4)
        {
          nodes[i ][j].m_v1 = !nodes[i ][j].m_v1;
          nodes[ip][j].m_v4 = !nodes[ip][j].m_v4;
        }

        //    2
        //   /
        //  /
        // 5
        if( nodes[i][j].m_v2 != nodes[i ][jm].m_v5)
        {
          nodes[i ][j ].m_v2 = !nodes[i ][j ].m_v2;
          nodes[i ][jm].m_v5 = !nodes[i ][jm].m_v5;
        }

        // 3
        //  \
        //   \
        //    6
        if( nodes[i][j].m_v3 != nodes[im][jm].m_v6)
        {
          nodes[i ][j ].m_v3 = !nodes[i ][j ].m_v3;
          nodes[im][jm].m_v6 = !nodes[im][jm].m_v6;
        }

        if( g_body_force)
        {
          // Body force. Tweak a velocity in a prescribed direction every now
          // and then to force a flow.
          if( !nodes[i][j].is_solid() && floor(random(2))==0)
          {
            switch( floor(random(3)))
            {
              case 0:
                if( nodes[i][j].m_v1 && !nodes[i][j].m_v4)
                { nodes[i][j].m_v1 = false;
                  nodes[i][j].m_v4 = true; }
                break;
              case 1:
                if( nodes[i][j].m_v2 && !nodes[i][j].m_v3)
                { nodes[i][j].m_v2 = false;
                  nodes[i][j].m_v3 = true; }
                break;
              case 2:
                if( nodes[i][j].m_v6 && !nodes[i][j].m_v5)
                { nodes[i][j].m_v6 = false;
                  nodes[i][j].m_v5 = true; }
                break;
            }
          } // if( floor(random(10))==0)
        }
      } // for( i=0; i<m_ni; i++)

      if( j<m_nj-1) { // Process the next row. The rows are processed in pairs
        // to handle the offsets of every other row due to the hexagonal grid.

        j++;
        jp = ((j<m_nj-1)?(j+1):(     0));
        jm = ((j>     0)?(j-1):(m_nj-1));

        for( i=0; i<m_ni; i++) {

          ip = ((i<m_ni-1)?(i+1):(     0));
          im = ((i>     0)?(i-1):(m_ni-1));

          // 4 --  -- 1
          if( nodes[i][j].m_v1 != nodes[ip][j].m_v4)
          {
            nodes[i ][j].m_v1 = !nodes[i ][j].m_v1;
            nodes[ip][j].m_v4 = !nodes[ip][j].m_v4;
          }

          //    2
          //   /
          //  /
          // 5
          if( nodes[i][j].m_v2 != nodes[ip][jm].m_v5)
          {
            nodes[i ][j ].m_v2 = !nodes[i ][j ].m_v2;
            nodes[ip][jm].m_v5 = !nodes[ip][jm].m_v5;
          }

          // 3
          //  \
          //   \
          //    6
          if( nodes[i][j].m_v3 != nodes[i][jm].m_v6)
          {
            nodes[i][j ].m_v3 = !nodes[i][j ].m_v3;
            nodes[i][jm].m_v6 = !nodes[i][jm].m_v6;
          }

          if( g_body_force)
          {
            // Body force. Tweak a velocity in a prescribed direction every now
            // and then to force a flow.
            if( !nodes[i][j].is_solid() && floor(random(2))==0)
            {
              switch( floor(random(3)))
              {
                case 0:
                  if( nodes[i][j].m_v1 && !nodes[i][j].m_v4)
                  { nodes[i][j].m_v1 = false;
                    nodes[i][j].m_v4 = true; }
                  break;
                case 1:
                  if( nodes[i][j].m_v2 && !nodes[i][j].m_v3)
                  { nodes[i][j].m_v2 = false;
                    nodes[i][j].m_v3 = true; }
                  break;
                case 2:
                  if( nodes[i][j].m_v6 && !nodes[i][j].m_v5)
                  { nodes[i][j].m_v6 = false;
                    nodes[i][j].m_v5 = true; }
                  break;
              }
            }
          }

        } // for( i=0; i<m_ni; i++)

      } // if( j<m_nj-1)

    } // for( j=0; j<m_nj; j++)

    if( g_velocity_bc)
    {
      i = 0;
      for( j=0; j<m_nj; j++) { // Velocity boundary condition.

        if( i==0) //&& floor(random(100))<=20)
        {
          nodes[i][j].m_v4 = true;
          nodes[i][j].m_v3 = true;
          nodes[i][j].m_v5 = true;
          nodes[i][j].m_v1 = false;
          nodes[i][j].m_v2 = false;
          nodes[i][j].m_v6 = false;
        }
      }
    }


    if(true) { // Correct the reversed velocities.
      for( j=0; j<m_nj; j++)
      {
        for( i=0; i<m_ni; i++)
        {
          if( nodes[i][j].m_v1 != nodes[i][j].m_v4)
          {   nodes[i][j].m_v1 = !nodes[i][j].m_v1;
              nodes[i][j].m_v4 = !nodes[i][j].m_v4; }
          if( nodes[i][j].m_v2 != nodes[i][j].m_v5)
          {   nodes[i][j].m_v2 = !nodes[i][j].m_v2;
              nodes[i][j].m_v5 = !nodes[i][j].m_v5; }
          if( nodes[i][j].m_v3 != nodes[i][j].m_v6)
          {   nodes[i][j].m_v3 = !nodes[i][j].m_v3;
              nodes[i][j].m_v6 = !nodes[i][j].m_v6; }

          nodes[i][j].m_v = 0;
          nodes[i][j].m_v |= ((nodes[i][j].m_v1)?(0x1 ):(0));
          nodes[i][j].m_v |= ((nodes[i][j].m_v2)?(0x2 ):(0));
          nodes[i][j].m_v |= ((nodes[i][j].m_v3)?(0x4 ):(0));
          nodes[i][j].m_v |= ((nodes[i][j].m_v4)?(0x8 ):(0));
          nodes[i][j].m_v |= ((nodes[i][j].m_v5)?(0x10):(0));
          nodes[i][j].m_v |= ((nodes[i][j].m_v6)?(0x20):(0));
          nodes[i][j].m_v |= ((nodes[i][j].m_random)?(0x40):(0));
          nodes[i][j].m_v |= ((nodes[i][j].m_solid)?(0x80):(0));

        }
      }
    } // if(true)


  } // void stream()
  void collide() {

    int i, j;

    for( j=0; j<m_nj; j++)
    {
      for( i=0; i<m_ni; i++)
      {
        //println("m_vmap[" + nodes[i][j].m_v + "] = " + m_vmap[  nodes[i][j].m_v  ]);

//     /===============  /  / ////// / =========== \  \                       //
// ===/                 /  /        /               \  \                      //
        nodes[i][j].m_v  =  m_vmap[  nodes[i][j].m_v  ];                      //
// ===\                 \  \        \               /  /                      //
//     \===============  \  \ \\\\\\ \ =========== /  /                       //

        // Update v1..v6
        // Either that or use m_v in the draw() method instead of v1..v6
        nodes[i][j].m_v1     = (( nodes[i][j].m_v & 0x1 ) != 0)?(true):(false);
        nodes[i][j].m_v2     = (( nodes[i][j].m_v & 0x2 ) != 0)?(true):(false);
        nodes[i][j].m_v3     = (( nodes[i][j].m_v & 0x4 ) != 0)?(true):(false);
        nodes[i][j].m_v4     = (( nodes[i][j].m_v & 0x8 ) != 0)?(true):(false);
        nodes[i][j].m_v5     = (( nodes[i][j].m_v & 0x10) != 0)?(true):(false);
        nodes[i][j].m_v6     = (( nodes[i][j].m_v & 0x20) != 0)?(true):(false);
        nodes[i][j].m_random = (( nodes[i][j].m_v & 0x40) != 0)?(true):(false);

      } // for( i=0; i<m_ni; i++)
    } // for( j=0; j<m_nj; j++)

  } // void collide()
  void tick( int num_ticks) {

    int n;
    for( n=0; n<num_ticks; n++)
    {
      stream();
      collide();
    }

  } // void tick()

} // class HexGrid

//##############################################################################
void keyPressed() {

  if(key==CODED) {

    switch(keyCode)
    {
      case LEFT:
        g_x0 -= g_lu/2;
        break;
      case RIGHT:
        g_x0 += g_lu/2;
        break;
      case UP:
        g_y0 -= g_lu/2;
        break;
      case DOWN:
        g_y0 += g_lu/2;
        break;
    }
  }
  else {

    switch( key)
    {
      case ' ': g_dx*=1.1; g_dy*=1.1;
        //println("Zoom in");
        break;
      case 'b': g_dx/=1.1; g_dy/=1.1;
        //println("Zoom out");
        break;
      case 't': g_grid.tick( 1); g_tick_on = false;
        //println("Tick");
        break;
      case 'T': g_tick_on = true;
        //println("Tick");
        break;
      case 's': g_grid.stream();
        //println("Stream");
        break;
      case 'c': g_grid.collide();
        //println("Collide");
        break;
      case 'a':
        g_grid.m_ave_size *= 5;
        //println("average");
        break;
      case 'A':
        g_grid.m_ave_size /= 5;
        //println("average");
        break;
    }
  }
}

// vim: set ft=cpp : syn on
