classdef Point3D
   properties
      CoordinateX
      CoordinateY
      CoordinateZ
   end
   methods
      function r = Point3D(x,y,z)
          if nargin == 0              
              r.CoordinateX = 0;
              r.CoordinateY = 0;
              r.CoordinateZ = 0;              
          else
              r.CoordinateX = x;
              r.CoordinateY = y;
              r.CoordinateZ = z;
          end
      end
      function [x y z] = get_coordinates(p)
          x = p.CoordinateX;
          y = p.CoordinateY;
          z = p.CoordinateZ;
      end
      function [] = disp(p)
          r = [];
          for i = 1:length(p)
              output= sprintf('(%.4f, %.4f, %.4f)', ...
                  p(i).CoordinateX, p(i).CoordinateY, p(i).CoordinateZ);
              r = [r; output];
          end
          disp(r)
      end
      function r = contains(A, el)
          r = false;
          for i = 1:length(A)
             elA = A(i);
             [x1 y1 z1] = get_coordinates(elA);
             [x2 y2 z2] = get_coordinates(el);
             if((x1 == x2) && (y1 == y2) && (z1 == z2))
                r = true;
                break;
             end
          end
      end
      function r = distance(p)
          r = sqrt(p.CoordinateX^2 + p.CoordinateY^2 + p.CoordinateZ^2);
      end
   end
end