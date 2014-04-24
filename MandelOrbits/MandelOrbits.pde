
Loopy loopy;
int g_orbitI = width/2;
int g_orbitJ = height/2;

boolean g_drawAxes = true;
boolean g_drawSet = true;
boolean g_drawOrbits = true;
boolean g_continuousOrbitUpdate = true;

void setup()
{
  //size(screen.width,screen.height);
  size(640,480);

  float aspect = float(height)/float(width);
  loopy = new Loopy( -2.0, 1.0
                   , -3.*aspect/2., 3.*aspect/2. );

  if( g_continuousOrbitUpdate)
  {
    frameRate(10);
  }
  else
  {
    noLoop();
  }
}

void draw()
{
  background(0);

  loopy.draw(g_orbitI,g_orbitJ);
}

class Loopy
{
  Loopy( float x0, float x1, float y0, float y1)
  {
    m_x0 = x0; m_x1 = x1; m_dx = ( m_x1-m_x0)/float(width);
    m_y0 = y0; m_y1 = y1; m_dy = ( m_y1-m_y0)/float(height);

    println(m_x0 + " " + m_x1 + " " + m_dx);
    println(m_y0 + " " + m_y1 + " " + m_dy);
  }

  void draw( int orbitI, int orbitJ)
  {
    int i, j, n;
    int itns;
    int max_itns=511;//255;
    float zi, zitemp, zj;
    float ci, cj;
    n=0;

    if( g_drawSet)
    {
      loadPixels();

      for( j=0, cj=m_y0; j<height; j++, cj+=m_dy)
      {
        for( i=0, ci=m_x0; i<width; i++, ci+=m_dx)
        {
          for( itns=0, zi=ci, zj=cj; zi*zi+zj*zj<=4. && itns<max_itns; itns++)
          {
            zitemp = zi*zi - zj*zj + ci;
            zj     = 2.*zi*zj      + cj;
            zi     = zitemp;
          }

          //print( itns + ", ");

          //if( itns != 255) { pixels[n] = color( itns, 255-itns, 255-itns);}//25*(itns%11)
          //if( itns != 255) { pixels[n] = color( 25*(itns%11), 100*(itns%3), 50*(itns%6));}
          if( itns != 255) { pixels[n] = color( 0, 0, 10*(itns%11));}
          //if( itns != 255) { pixels[n] = color( 22*(itns%11), 21*(itns%12), (20*(itns%13))%256);}
          //if( itns != 255) { pixels[n] = color( 0, 0, itns%256);}
          //if( itns != 255) { pixels[n] = color( random(255), random(255), itns%256);}
          n++;

        } // for( i=0; i<width; i++)
      } // for( j=0; j<height; j++)
    }

    // Plot orbit of coordinate (orbitI,orbitJ).
    int ii, jj;
    if( g_continuousOrbitUpdate)
    {
      i = mouseX; zi = ci = m_x0 + i*m_dx;
      j = mouseY; zj = cj = m_y0 + j*m_dy;
    }
    else
    {
      i = orbitI; zi = ci = m_x0 + i*m_dx;
      j = orbitJ; zj = cj = m_y0 + j*m_dy;
    }
    n = i + j*width;

    if( g_drawSet)
    {
      pixels[n        ] = color(255);
      pixels[n+1      ] = color(255);
      pixels[n  +width] = color(255);
      pixels[n+1+width] = color(255);
      updatePixels();
    }

    if( g_drawAxes)
    {
      stroke(255,255,255, 32);

      line( 0, int( floor( (0.-m_y0)/m_dy)), width, int( floor( (0.-m_y0)/m_dy)));
      line( int( floor( (0.-m_x0)/m_dx)), 0, int( floor( (0.-m_x0)/m_dx)), height);

    }

    if( g_drawOrbits)
    {
      for( itns=0; zi*zi+zj*zj<=4. && itns<max_itns; itns++)
      {
        zitemp = zi*zi - zj*zj + ci;
        zj     = 2.*zi*zj      + cj;
        zi     = zitemp;

        ii = int( floor( (zi-m_x0)/m_dx));
        jj = int( floor( (zj-m_y0)/m_dy));

        stroke((itns%6)*25 + 130);
        line( i, j, ii, jj);
        i = ii;
        j = jj;

      }

      fill(0,255,0);
      stroke(0,255,0);
      ellipse( i, j, 8, 8);

      if( g_continuousOrbitUpdate)
      {
        fill(255,0,0);
        stroke(255,0,0);
        ellipse( mouseX, mouseY, 8, 8);
      }
      else
      {
        fill(255,0,0);
        stroke(255,0,0);
        ellipse( orbitI, orbitJ, 8, 8);
      }
    }

  } // void draw()

  void up(    int fac) { m_y0+=(fac*m_dy); m_y1+=(fac*m_dy);}
  void down(  int fac) { m_y0-=(fac*m_dy); m_y1-=(fac*m_dy);}
  void left(  int fac) { m_x0+=(fac*m_dx); m_x1+=(fac*m_dx);}
  void right( int fac) { m_x0-=(fac*m_dx); m_x1-=(fac*m_dx);}

  void zoomin( int fac)
  {
    float x = (m_x1+m_x0)/2.;
    float y = (m_y1+m_y0)/2.;
    m_x0 = x - (x-m_x0)/fac;
    m_x1 = x + (m_x1-x)/fac;
    m_dx = (m_x1-m_x0)/width;
    m_y0 = y - (y-m_y0)/fac;
    m_y1 = y + (m_y1-y)/fac;
    m_dy = (m_y1-m_y0)/height;
    println( m_dx);
    println( m_dy);
  }

  void zoomout( int fac)
  {
    float x = (m_x1+m_x0)/2.;
    float y = (m_y1+m_y0)/2.;
    m_x0 = x - (x-m_x0)*fac;
    m_x1 = x + (m_x1-x)*fac;
    m_dx = (m_x1-m_x0)/width;
    m_y0 = y - (y-m_y0)*fac;
    m_y1 = y + (m_y1-y)*fac;
    m_dy = (m_y1-m_y0)/height;
  }

  float m_x0, m_x1, m_dx;
  float m_y0, m_y1, m_dy;

};

void keyPressed()
{
  if( key==CODED)
  {
    switch( keyCode)
    {
      case UP   : loopy.up(   50); redraw(); break;
      case DOWN : loopy.down( 50); redraw(); break;
      case LEFT : loopy.left( 50); redraw(); break;
      case RIGHT: loopy.right(50); redraw(); break;
    }
  }
  else
  {
    switch( key)
    {
      case ' ': loopy.zoomin( 2); redraw(); break;
      case 'b': loopy.zoomout(2); redraw(); break;
    }
  }
}

void mouseClicked()
{
  g_orbitI = mouseX;
  g_orbitJ = mouseY;
  redraw();
}
