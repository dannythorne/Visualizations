
color g_background_color                = color(192);
color g_background_bar_fill_color       = color(176);
color g_cur_bar_fill_color              = color(255,0,0);
color g_cur_bar_stroke_color            = color(255,64,64);
color g_insertion_region_fill_color     = color(212,152,152);
color g_insertion_region_stroke_color   = g_insertion_region_fill_color;
color g_last_insertion_bar_fill_color   = g_insertion_region_fill_color;
color g_last_insertion_bar_stroke_color = g_insertion_region_stroke_color;

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

  for( i=0; i<g_n; i++) // init array
  {
    g_a[i] = 1 + i;
  }
  shuffle(); // and shuffle it
  g_is_sorted = false;
  g_inserted = false;

  g_i = 1;         // index of cur bar
  g_x = g_i*g_dx;  // x-coord of cur bar

  g_j = g_i;       // index of last bar of insertion region
  g_is_start_insertion = true;

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

      fill(g_insertion_region_fill_color);
      stroke(g_insertion_region_stroke_color);

      for( i=0; i<g_n; i++)
      {
        draw_bar(i);
      }
    }
    else
    {
      background(g_background_color);

      fill(g_insertion_region_fill_color);
      stroke(g_insertion_region_stroke_color);

      for( i=0; i<g_j; i++)
      {
        draw_bar(i);
      }

      fill(g_last_insertion_bar_fill_color);
      stroke(g_last_insertion_bar_stroke_color);

      draw_bar(i++);

      fill(g_background_bar_fill_color);
      noStroke();

      for(    ; i<g_n; i++)
      {
        draw_bar(i);
      }

      fill(g_cur_bar_fill_color);
      stroke(g_cur_bar_stroke_color);

      draw_bar(g_i);
    }

    g_is_draw_time = false;
  }
  else // update state instead of drawing
  {
    if( g_is_sorted)
    {
      if( millis() - g_sorted_time > 1000) // pause after sorted
      {
        g_i = g_j;
        shuffle();
        g_is_inserted = false;
        g_is_sorted = false;
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
        if( g_i==0 || g_a[g_i-1]<g_a[g_i])
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
            g_a[g_i] = g_a[g_i-1];
            g_a[g_i-1] = temp;
            g_i--;
            g_x = g_x - g_dx;
            g_is_start_insertion = false;
          }
        }
      }
    }

    g_is_draw_time = true;
  }
}

void shuffle()
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

void draw_bar( int i)
{
  rect( /*   left */   i*g_dx+g_ddx
      , /* bottom */ g_screenHeight - g_dx*g_a[  i]
      , /*  width */ g_dx-2*g_ddx
      , /* height */ g_dx*g_a[  i]);
}
