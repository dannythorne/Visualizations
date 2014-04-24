#version 3.6;
global_settings {
  assumed_gamma 1.0
  ambient_light color rgb <1,1,1>
}
camera {
  orthographic
  location <0,279,558>
  look_at  <0,0,0>
  right 370*x
  up 370*(image_height/image_width)*y
}
light_source {
  0*x
  color rgb <1,1,1>
  translate <-200, 5580, 200>
}
light_source {
  0*x
  color rgb <1,1,1>
  translate <200, 558, 20>
}
light_source {
  0*x
  color rgb <1,1,1>
  translate <-100, 5580,-70>
}
light_source {
  0*x
  color rgb <1,1,1>
  translate <139.5, 0,139.5>
}
#declare thing = union
{
#include "povlife.inc"
}
plane { <0,1,0>, -141 pigment { rgb <1,.3,1>} finish { reflection .5}}
cylinder { <0,-9999,0>,<0,9999,0>,.1 pigment { rgb <1,0,1>}}
object { thing rotate 90*x translate 139.5*y rotate clock*360*y scale 1}
