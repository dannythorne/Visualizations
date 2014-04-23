
int ss = 2;

int n = 93*ss;
int[] a = new int[n];

int s = 8/ss;

int g_h = 0;
int g_i;
int g_j;
int g_v;

boolean do_update = true;
boolean is_looping = true;
boolean bing = false;
boolean done = false;

int init_type = 1; // 1 shuffle, 2 reverse, 3 sorted
int frame_rate = 20;

void setup()
{
  //size(s*n,s*n);
  size(744,744); // Can't have variable size with processing.js
  frameRate(frame_rate);
}

void draw()
{
  if( do_update)
  {
    if( g_h==0)
    {
      int i;
      for( i=0; i<n; i++)
      {
        a[i] = i;
      }
      int j, k, temp;
      switch( init_type)
      {
        case 1: // shuffle
          for( k=0; k<100*n; k++)
          {
            i = int(random(n));
            j = int(random(n));
            temp = a[i];
            a[i] = a[j];
            a[j] = temp;
          }
          break;
        case 2: // reverse
          for( k=0; k<n; k++)
          {
            a[k] = n-k-1;
          }
          break;
        case 3: // sorted
          break;
      }
      for( g_h=1; g_h<=(n+1)/9; g_h=3*g_h+1) {}
      g_i = g_h;
      g_v = a[g_i];
      g_j = g_i;
    }
    else
    {
      if( !done)
      {
        if( bing)
        {
          bing = false;
        }
        else
        {
          if( g_j>g_h-1 && a[g_j-g_h]>g_v)
          {
            a[g_j] = a[g_j-g_h];
            g_j-=g_h;
          }
          else
          {
            a[g_j] = g_v;
            bing = true;
          }
        }
      }
    }

    background(192);

    int i;
    for( i=0; i<n; i++)
    {
      if( g_h > 0)
      {
        stroke(128);
        fill(164);
      }
      else
      {
        stroke(128,0,0);
        fill(255,0,0);
      }
      rect(  s*i, s*(n-1-a[i]), s+1, s+1);
    }
    if( g_h > 0)
    {
      for( i=g_i; i>=0; i-=g_h)
      {
        if( bing || i==g_i || i!=g_j)
        {
          if( bing)
          {
            //stroke(112,224,112);
            //fill(128,224,128);
            //rect( s*i, s*(n-1-a[i]), s, s*(a[i]+1));
          }
          else
          {
            stroke(255,128,128);
            fill(255,192,192);
            rect( s*i, s*(n-1-a[i]), s, s*(a[i]+1));
          }
          if( bing)
          {
            //stroke(0,112,0);
            //fill(0,192,0);
            stroke(128,0,0);
            fill(255,0,0);
            rect(  s*i-1, s*(n-1-a[i])-1, s+3, s+3);
          }
          else
          {
            stroke(128,0,0);
            fill(255,0,0);
            rect(  s*i, s*(n-1-a[i]), s+1, s+1);
          }
        }
        else
        {
          stroke(128,0,0);
          fill(255,0,0);
          rect( s*i, s*(n-1-g_v), s, s*(g_v+1));
        }
      }
    }

    if( bing)
    {
      g_i++;
      if( g_i==n)
      {
        g_h = g_h/3;
        g_i = g_h;
      }
      g_v = a[g_i];
      g_j = g_i;
    }

    if( done)
    {
      delay(1000);
      done = false;
    }
    else if( g_h == 0)
    {
      done = true;
    }

  }
}

void keyPressed()
{
  switch( key)
  {
    case 'n':
      if( is_looping)
      {
        noLoop();
        is_looping = false;
      }
      else
      {
        redraw();
      }
      break;
    case 'l':
      loop();
      is_looping = true;
      break;
    case 'r': // shuffle (random)
      init_type = 1;
      g_h = 0;
      done = true;
      break;
    case 'b': // reverse (backward)
      init_type = 2;
      g_h = 0;
      done = true;
      break;
    case 's': // sorted
      init_type = 3;
      g_h = 0;
      done = true;
      break;
    case '+': // increase frame rate
      frame_rate++;
      frameRate(frame_rate);
      break;
    case '-': // increase frame rate
      if( frame_rate > 1) { frame_rate--; frameRate(frame_rate);}
      break;
  }
}

