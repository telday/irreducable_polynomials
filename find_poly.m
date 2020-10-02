global poly_degree = 3; # The maximum degree polynomial we are looking for
global extension_field = 3; # The extension field we are in

% Checks if p1 is evenly divisible by p2 in Z[2]
function div = evenly_divisible (p1, p2)
  global extension_field;
  [b, remainder] = deconv(polyreduce(p1), polyreduce(p2));
  for i = 1 : length(remainder)
    % reduce coefficients to the galois field we are in (Z[2])
    remainder(i) = mod(remainder(i), extension_field);
  endfor
  % if remainder is all 0's return 1
  if remainder == false(1, length(remainder))
    div = 1;
   else
     div = 0;
   endif
endfunction

% determines if polynomial p has a divisor less than it
% n is the integer representation of the polynomial and
function d = has_divisor(p, n)
  global poly_degree;
  global extension_field;
  d = 0;
  % Dont check 1 for obvious reasons loop through all
  % other possible polynomials
  for k = extension_field : (n - 1)
    divisor = zeros(1, poly_degree + 1);
    % This assigns the polynomials to divisor by getting their bits
    poly_representation = dec2base(k, extension_field);
    % left pad the representation with 0's
    while length(poly_representation) < poly_degree + 1
      poly_representation = ["0" poly_representation];
    endwhile
    for j = 1 : poly_degree + 1
     divisor(j) = str2num(poly_representation(j));
    endfor
  
    divisable = evenly_divisible(p, divisor);
    if divisable == 1
      d = 1;
      break;
    endif
  endfor
endfunction

% Main loop
for i = extension_field : (extension_field ^ (poly_degree + 1)) - 1
  % Start w/zero polynomial and fill in individual bits
  p = zeros(1, poly_degree + 1);
  poly_representation = dec2base(i, extension_field);
  % left pad the representation with 0's
  while length(poly_representation) < poly_degree + 1
    poly_representation = ["0" poly_representation];
  endwhile
  for j = 1 : poly_degree + 1
    p(j) = str2num(poly_representation(j));
  endfor

  if has_divisor(p, i) == 0
    polyout(polyreduce(p), 'x');
  endif
endfor
