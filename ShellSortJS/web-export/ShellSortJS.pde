
color g_background_color                = #e0e0e0;
color g_background_bar_fill_color       = #d0d0d0;
color g_cur_bar_fill_color              = #0000ff;
color g_cur_bar_stroke_color            = #0000ff;
color g_insertion_region_fill_color     = #78a8f0;
color g_insertion_region_stroke_color   = g_insertion_region_fill_color;
color g_last_insertion_bar_fill_color   = g_insertion_region_fill_color;
color g_last_insertion_bar_stroke_color = g_insertion_region_stroke_color;
color g_background_point_fill_color     = #909090;
color g_background_point_stroke_color   = #c0c0c0;
color g_point_fill_color                = #303030;

int g_screenWidth;
int g_screenHeight;

int g_x;   // x-coord of cur bar
int g_dx;  // width of bars
int g_ddx; // margin for bars
int g_dy;  // height of cur bar

int[] g_a; // array
int g_n;   // num bars

int g_i;   // index of cur bar
int g_j;   // index of last bar of insertion region

bool g_is_draw_time; // toggle draw activity
bool g_is_inserted;  // flag for successful insertion of current bar
bool g_is_sorted;
bool g_is_start_insertion;

int g_sorted_time;
int g_inserted_time;
int g_start_time;

int g_h;

//##############################################################################
void setup()
{
  g_screenWidth = 600;
  g_screenHeight = 600;
  size(600,600); // Can't use size variables in processing.js !?

  frameRate(100);

  g_dx = 10; // width of bars
  g_ddx = 2; // margin for bars

  g_n = g_screenWidth / g_dx; // num bars
  g_a = new int[g_n];

  int i, j, temp;

  init_array();
  shuffle_array(); // shuffle array
  init_params();
  init_gap_sequence();

  g_is_draw_time = true;
}

//##############################################################################
void draw()
{
  if( g_is_draw_time)
  {
    int i;

    if( g_is_sorted)
    {
      background(g_background_color);

      if( g_h > 1)
      {
        fill(g_background_bar_fill_color);
        noStroke();

        for( i=0; i<g_n; i++)
        {
          draw_bar(i);
        }
      }

      fill(g_insertion_region_fill_color);
      //stroke(g_insertion_region_stroke_color);
      noStroke();

      for( i=g_j%g_h; i<=g_j; i+=g_h)
      {
        draw_bar(i);
      }

      fill(g_background_point_fill_color);
      stroke(g_background_point_stroke_color);
      //noStroke();

      for( i=0; i<g_n; i++)
      {
        draw_point(i);
      }
    }
    else
    {
      background(g_background_color);

      fill(g_background_bar_fill_color);
      noStroke();

      for( i=0; i<g_n; i++)
      {
        draw_bar(i);
      }

      fill(g_insertion_region_fill_color);
      //stroke(g_insertion_region_stroke_color);
      noStroke();

      for( i=g_j%g_h; i<=g_j-g_h; i+=g_h)
      {
        draw_bar(i);
      }

      fill(g_last_insertion_bar_fill_color);
      //stroke(g_last_insertion_bar_stroke_color);
      noStroke();

      draw_bar(i);

      fill(g_cur_bar_fill_color);
      //stroke(g_cur_bar_stroke_color);
      noStroke();

      draw_bar(g_i);

      fill(g_background_point_fill_color);
      stroke(g_background_point_stroke_color);
      //noStroke();

      for( i=0; i<g_n; i++)
      {
        draw_point(i);
      }
    }

    g_is_draw_time = false;
  }

  else // update state instead of drawing
  {
    if( g_is_sorted)
    {
      if( millis() - g_sorted_time > 1000) // pause after sorted
      {
        if( g_h==1)
        {
          shuffle_array();
          init_params();
          init_gap_sequence();
        }
        else
        {
          next_h();
          init_params();
        }
      }
    }
    else
    {
      if( g_is_inserted)
      {
        if( millis() - g_inserted_time > 150) // pause after insertion
        {
          // move to next bar to insert
          g_x = ( g_x + g_dx) % g_screenWidth;
          g_j = ( g_j + 1) % g_n;
          if( g_j==0)
          {
            g_is_sorted = true;
            g_sorted_time = millis();
            // g_i and g_is_sorted will be updated after a pause (above)
          }
          else
          {
            // prep next insertion step
            g_i = g_j;
            g_is_inserted = false;
            g_is_start_insertion = true;
            g_start_time = millis();
          }
        }
      }
      else
      {
        if( g_i<=g_j%g_h || g_a[g_i-g_h]<g_a[g_i])
        {
          // done inserting current bar
          g_is_inserted = true;
          g_inserted_time = millis();
        }
        else
        {
          if( !g_is_start_insertion || millis() - g_start_time > 250)
          {
            // move cur bar to the left
            temp = g_a[g_i];
            g_a[g_i] = g_a[g_i-g_h];
            g_a[g_i-g_h] = temp;
            g_i-=g_h;
            g_x = g_x - g_dx*g_h;
            g_is_start_insertion = false;
          }
        }
      }
    }

    g_is_draw_time = true;
  }
}

void init_array()
{
  for( i=0; i<g_n; i++)
  {
    g_a[i] = 1 + i;
  }
}

void shuffle_array()
{
  int i, j, temp;
  for( i=g_n-1; i>0; i--)
  {
    j = int(random(i));
    temp = g_a[j];
    g_a[j] = g_a[i];
    g_a[i] = temp;
  }
}

void init_params()
{
  g_is_sorted = false;
  g_inserted = false;
  g_i = 0;         // index of cur bar
  g_x = g_i*g_dx;  // x-coord of cur bar
  g_j = g_i;       // index of last bar of insertion region
  g_is_start_insertion = true;
}

void init_gap_sequence()
{
  g_h = 4;
  while( g_h < g_n/9) { g_h = 3*g_h + 1;}
}

void next_h()
{
  g_h = (g_h-1)/3;
}

void draw_bar( int i)
{
  rect( /*   left */   i*g_dx + g_ddx
      , /*    top */ g_screenHeight - g_dx*g_a[  i]
      , /*  width */ g_dx - 2*g_ddx
      , /* height */ g_dx*g_a[  i]
      );
}
void draw_point( int i)
{
  rect( /*   left */   i*g_dx + g_ddx - 1
      , /*    top */ g_screenHeight - g_dx*g_a[  i]
      , /*  width */ g_dx - 2*g_ddx + 1
      , /* height */ g_dx - 2*g_ddx + 1
      );
}

