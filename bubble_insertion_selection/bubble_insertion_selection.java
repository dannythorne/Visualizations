import processing.core.*; 
import processing.xml.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class bubble_insertion_selection extends PApplet {


int ss = 8;

int n = 93*ss;
int[] a_bubble = new int[n];
int[] a_insertion = new int[n];
int[] a_selection = new int[n];

int s = 8/ss;

int g_i = 1;
int g_imin = 0;
int num_draws = 0;

public void setup()
{
  size(s*n,s*n);
  frameRate(40);
  int i;
  for( i=0; i<n; i++)
  {
    a_bubble[i] = i;
    a_insertion[i] = i;
    a_selection[i] = i;
  }
  int j, k, temp;
  if(true) { shuffle();}
}

public void draw()
{
 if( g_i < n)
 {
  background(192);
  int i;
  
  bubble_sort();
  insertion_sort();
  selection_sort();

  for( i=0; i<n; i++)
  {
    stroke(128,0,0);
    fill(255,0,0);
    rect(  s*i, s*(n-1-a_bubble[i]), s, s); // squares
    stroke(0,128,0);
    fill(0,255,0);
    rect(  s*i, s*(n-1-a_insertion[i]), s, s); // squares
    stroke(0,0,128);
    fill(0,0,255);
    rect(  s*i, s*(n-1-a_selection[i]), s, s); // squares
    //rect( s*i, s*(n-1-a_bubble[i]), s, s*(a_bubble[i]+1)); // bars
  }
   
  num_draws++;
  g_i++;
 }
 else
 {
   delay(1000);
   shuffle();
   g_i=1;
 }
}

public void shuffle()
{
  int i, j, k, temp;
  for( k=0; k<100*n; k++)
  {
    i = PApplet.parseInt(random(n));
    j = PApplet.parseInt(random(n));
    temp = a_bubble[i];
    a_bubble[i] = a_bubble[j];
    a_bubble[j] = temp;
    temp = a_insertion[i];
    a_insertion[i] = a_insertion[j];
    a_insertion[j] = temp;
    temp = a_selection[i];
    a_selection[i] = a_selection[j];
    a_selection[j] = temp;
  }
}
public void bubble_sort()
{
  int i, j, v;
  i = g_i;
    
    for( j=0; j<n-i; j++)
    {
      if( a_bubble[j] > a_bubble[j+1])
      {
        v = a_bubble[j];
        a_bubble[j] = a_bubble[j+1];
        a_bubble[j+1] = v;
      }
    }
}

public void insertion_sort()
{
  int i, j, v;
  i = g_i;
    v = a_insertion[i];
    j = i;
    while( j>0 && a_insertion[j-1]>v)
    {
      a_insertion[j] = a_insertion[j-1];
      j--;
    }
    a_insertion[j] = v;
}

public int get_min()
{
  int i=g_i-1, j;
  int imin, amin, temp;

    imin = i;
    amin = a_selection[i];
    for( j=i+1; j<n; j++)
    {
      if( a_selection[j] < amin)
      {
        imin = j;
        amin = a_selection[j];
      }
    }
  return imin;
}

public void selection_sort()
{
  int i=g_i-1, j;
  int imin, amin, temp;
  if( i<n)
  {
    imin = get_min();
    amin = a_selection[imin];
    if( amin != a_selection[i])
    {
      a_selection[imin] = a_selection[i];
      a_selection[i] = amin;
    }
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#d4d0c8", "bubble_insertion_selection" });
  }
}
