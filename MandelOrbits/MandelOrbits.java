import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class MandelOrbits extends PApplet {


Loopy loopy;
int g_orbitI = width/2;
int g_orbitJ = height/2;

boolean g_drawAxes = true;
boolean g_drawSet = true;
boolean g_drawOrbits = true;
boolean g_continuousOrbitUpdate = true;

public void setup()
{
  //size(screen.width,screen.height);
  size(640,480);

  float aspect = PApplet.parseFloat(height)/PApplet.parseFloat(width);
  loopy = new Loopy( -2.0f, 1.0f
                   , -3.f*aspect/2.f, 3.f*aspect/2.f );

  if( g_continuousOrbitUpdate)
  {
    frameRate(10);
  }
  else
  {
    noLoop();
  }
}

public void draw()
{
  background(0);

  loopy.draw(g_orbitI,g_orbitJ);
}

class Loopy
{
  Loopy( float x0, float x1, float y0, float y1)
  {
    m_x0 = x0; m_x1 = x1; m_dx = ( m_x1-m_x0)/PApplet.parseFloat(width);
    m_y0 = y0; m_y1 = y1; m_dy = ( m_y1-m_y0)/PApplet.parseFloat(height);

    println(m_x0 + " " + m_x1 + " " + m_dx);
    println(m_y0 + " " + m_y1 + " " + m_dy);
  }

  public void draw( int orbitI, int orbitJ)
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
          for( itns=0, zi=ci, zj=cj; zi*zi+zj*zj<=4.f && itns<max_itns; itns++)
          {
            zitemp = zi*zi - zj*zj + ci;
            zj     = 2.f*zi*zj      + cj;
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

      line( 0, PApplet.parseInt( floor( (0.f-m_y0)/m_dy)), width, PApplet.parseInt( floor( (0.f-m_y0)/m_dy)));
      line( PApplet.parseInt( floor( (0.f-m_x0)/m_dx)), 0, PApplet.parseInt( floor( (0.f-m_x0)/m_dx)), height);

    }

    if( g_drawOrbits)
    {
      for( itns=0; zi*zi+zj*zj<=4.f && itns<max_itns; itns++)
      {
        zitemp = zi*zi - zj*zj + ci;
        zj     = 2.f*zi*zj      + cj;
        zi     = zitemp;

        ii = PApplet.parseInt( floor( (zi-m_x0)/m_dx));
        jj = PApplet.parseInt( floor( (zj-m_y0)/m_dy));

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

  public void up(    int fac) { m_y0+=(fac*m_dy); m_y1+=(fac*m_dy);}
  public void down(  int fac) { m_y0-=(fac*m_dy); m_y1-=(fac*m_dy);}
  public void left(  int fac) { m_x0+=(fac*m_dx); m_x1+=(fac*m_dx);}
  public void right( int fac) { m_x0-=(fac*m_dx); m_x1-=(fac*m_dx);}

  public void zoomin( int fac)
  {
    float x = (m_x1+m_x0)/2.f;
    float y = (m_y1+m_y0)/2.f;
    m_x0 = x - (x-m_x0)/fac;
    m_x1 = x + (m_x1-x)/fac;
    m_dx = (m_x1-m_x0)/width;
    m_y0 = y - (y-m_y0)/fac;
    m_y1 = y + (m_y1-y)/fac;
    m_dy = (m_y1-m_y0)/height;
    println( m_dx);
    println( m_dy);
  }

  public void zoomout( int fac)
  {
    float x = (m_x1+m_x0)/2.f;
    float y = (m_y1+m_y0)/2.f;
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

public void keyPressed()
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

public void mouseClicked()
{
  g_orbitI = mouseX;
  g_orbitJ = mouseY;
  redraw();
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "MandelOrbits" });
  }
}
