// Below is a function to generate the A2 subsystem subgroup of G = G2(q) and the maximal subgroup of type A2.2, then it
// picks random elements in G and computes conjugates of said subgroups and compute the relevant intersections and outputs
// isomorphism types of the intersections.
// Known issue: Magma's Normaliser function is certainly not ideal as it does not deal with larger groups efficiently.
// Potential solution: We use the Normaliser function to construct a subgroup A2.2 containing the subsystem subgroup A2
// with long roots, but another way of doing so is to find the subgroup generated by this A2 and the Weyl group of G, as we know
// that the (representatives of) Weyl group of G is contained in an A2.2, which is not contained in A2.
// However, I couldn't find a nice way to get these representatives...
intsA2      := function(q)
  G         := GroupOfLieType("G2", q);
  rk        := Rank(G);
  rho       := StandardRepresentation(G);
  K<x>      := GF(q);
  G1        := Image(rho);
  A2        := SubsystemSubgroup(G,{2, 12});
  A2gen     := Generators(A2);
  A2mat     := sub<Codomain(rho)|rho(A2gen)>;
  // T         := StandardMaximalTorus(G);
//now get pre-images of W in G1
// first get torus
   // T1  := sub< Codomain(rho) | Generators(T)@rho >;
// get extended Weyl group
   // V   := sub< Codomain(rho) |  [   elt<G | x >@rho : x in [1..Rank(G)] ] >;
// check order: V / (T1 \cap V) \cong WeylGroup(G)
   // W, pi := quo<V | V meet T1>;
   // assert #W eq #WeylGroup(G);
   // preim := [ i@@pi : i in UserGenerators(W)];
// now preim are elements in G1 that map onto WeylGroup = W under the projection V->V/(V\cap T)
   // A2dot2    := sub<Codomain(rho)|rho(A2gen), preim>;
// Get Weyl group of G
  W         := WeylGroup(G);
// Get generators of W
  Wgen      := [elt<G|W.i>@rho : i in [1..rk]];
// Generate A2.2 = <A2, W>
  A2dot2    := sub<Codomain(rho)|rho(A2gen), Wgen>;
  s0        := 2*(q^8 - q^6 - q^5 + q^3);
  assert #A2dot2 eq s0;
  s         := s0^2;
  if IsPrime(q) then
    elts      := [(elt<G|<3,1>>*elt<G|<4,1>>)@rho] cat [(elt<G|<7,1>>*elt<G|<1,i>>)@rho : i in [1..1/2*(q - 1)]];
  else
    elts      := [(elt<G|<3,1>>*elt<G|<4,1>>)@rho] cat [(elt<G|<7,1>>*elt<G|<1,x^i>>)@rho : i in [0..1/2*(q - 3)]];
  end if;
  A2s       := [A2mat^rho(elt<G|<1,i>>) : i in [0, 1]] cat [A2mat^g : g in elts];
  A2dot2s   := [A2dot2^rho(elt<G|<1,i>>) : i in [0, 1]] cat [A2dot2^g : g in elts];
  ints      := [[A2mat meet A2s[i], A2dot2 meet A2dot2s[i]] : i in [1..1/2*(q + 1)+2]];
  dcsizes   := [s/#ints[i][2] : i in [1..1/2*(q + 1)+2]];
  sum       := 0;
  for i in [1..1/2*(q + 1)+2] do sum := sum + dcsizes[i];
  end for;
  assert sum eq (q^14 - q^12 - q^8 + q^6);
  types     := [[GroupName(ints[i][1]), GroupName(ints[i][2])] : i in [1..1/2*(q + 1) + 2]];
  RF        := recformat< overgroup : GrpLie, A2, A2dot2, maxA2, maxA2dot2, intersections, types, dcsizes >;
  r         := rec< RF | overgroup := G, A2 := GroupName(A2mat), A2dot2 := GroupName(A2dot2),
                //maxA2 := [GroupName(i`subgroup):i in MaximalSubgroups(A2mat)],
                //maxA2dot2 := [GroupName(i`subgroup):i in MaximalSubgroups(A2dot2)],
                intersections := ints, types := types, dcsizes := dcsizes>;
  return r;
end function;


////////////////////////////////////////////////////////////////////////////////

intsA1A1    := function(p)
  G         := GroupOfLieType("G2", p);
  rk        := Rank(G);
  rho       := StandardRepresentation(G);
  K<x>      := GF(p);
  G1        := Image(rho);
  A1A1      := SubsystemSubgroup(G,{1, 12});
  T         := StandardMaximalTorus(G);
  Tgen      := Generators(T)@rho;
  rts       := [elt<G|<1,1>>,
                elt<G|<6,1>>,
                elt<G|<7,1>>,
                elt<G|<12,1>>,
                elt<G|<1,x>>,
                elt<G|<6,x>>,
                elt<G|<7,x>>,
                elt<G|<12,x>>];
  A1A1mat   := sub<Codomain(rho)|rho(rts), Tgen>;
  s0        := #A1A1;
  assert #A1A1 eq #A1A1mat;
  g         := (elt<G|<2,1>>*elt<G|<3,1>>*elt<G|<8,1>>)@rho;
  A1A1mat meet A1A1mat^g;
  GroupName($1);
  W         := WeylGroup(G);
  Wgen      := [elt<G|W.i>@rho : i in [1..rk]];
  s         := s0^2;
  elts      := [1@rho, elt<G|<2,1>>@rho, elt<G|<3,1>>@rho,
                (elt<G|<2,1>>*elt<G|<4,1>>*elt<G|<8,1>>)@rho, (elt<G|<3,1>>*elt<G|<9,1>>)@rho,
                elt<G|W.2>@rho];
  if p mod 2 eq 1 then
    elts    := elts cat [(elt<G|<7,1>>*elt<G|<2,i>>)@rho : i in [1..1/2*(p - 1)]];
  end if;
  A1A1s     := [A1A1mat^g : g in elts];
  ints      := [A1A1mat meet i : i in A1A1s];
  types     := [GroupName(i) : i in ints];
  types;
  dcsizes   := [s/#i : i in ints];
  sum       := 0;
  for i in dcsizes do sum := sum + i;
  end for;
  // assert sum eq (p^14 - p^12 - p^8 + p^6);
  types     := [GroupName(i) : i in ints];
  RF        := recformat< overgroup : GrpLie, A2, A2dot2, maxA2, maxA2dot2, intersections, types, dcsizes >;
  r         := rec< RF | overgroup := G, A2 := GroupName(A2mat), A2dot2 := GroupName(A2dot2),
                maxA2 := [GroupName(i`subgroup):i in MaximalSubgroups(A2mat)],
                maxA2dot2 := [GroupName(i`subgroup):i in MaximalSubgroups(A2dot2)],
                intersections := ints, types := types, dcsizes := dcsizes>;
  return r;
end function;

////////////////////////////////////////////////////////////////////////////////
// Earlier draft code
// Construct G2 over GF(p)
  p     := 13;
  K<x>  := GF(p);
  G     := GroupOfLieType("G2", GF(p));
  rk    := Rank(G);
// Get standard representation
  rho   := StandardRepresentation(G);
  G1    := Image(rho);
// Get A2 SubsystemSubgroup
  A2    := SubsystemSubgroup(G,{2, 12});
  A2gen := Generators(A2);
  A2mat := sub<Codomain(rho)|rho(A2gen)>;

// Get maximal torus of A2
  T2    := StandardMaximalTorus(A2);
  T2gen := Generators(T2);
// Get maximal torus of G
  T     := StandardMaximalTorus(G);
  Tgen  := Generators(T);
  T1    := sub< Codomain(rho) | Tgen@rho >;
  t1    := elt<G|Tgen[1]>;
  t2    := elt<G|Tgen[2]>;
// Get Weyl group of G
  W     := WeylGroup(G);
  Wgen  := [elt<G|W.i>@rho : i in [1..rk]];
  Wmat  := sub<Codomain(rho)|Wgen>;
  w1    := elt<G|LongestElement(W)>;
// Generate A2.2 = <A2, W>
  A2dot2:= sub<Codomain(rho)|rho(A2gen), Wgen>;
  a     := elt<G|<1,1>>;
  g1    := a@rho;
  b     := elt<G|<3,1>>*elt<G|<4,1>>;
  g2    := b@rho;
  if IsPrime(p) then
    c   := [elt<G|<7,1>>*elt<G|<1,i>>: i in [1..p-1]];
  else
    c   := [elt<G|<7,1>>*elt<G|<1,x^i>>: i in [0..p-2]];
  end if;
  c     := [elt<G|<9,1>>*elt<G|<3,i>>: i in [1..p-1]];
  c     := [elt<G|<10,1>>*elt<G|<4,i>>: i in [1..p-1]];
  //[GroupName(A2dot2^(i@rho) meet A2dot2): i in c];
  c1    := elt<G|<7,1>>*elt<G|<1,1>>;
  c2    := elt<G|<7,1>>*elt<G|<1,2>>;
  gc1   := c[1]@rho;
  gc2   := c[2]@rho;
  tmp   := [i:i in Wmat|i^g2 in A2dot2 and i^g2 notin A2mat and i notin T1];
  assert sub<Codomain(rho)|rho(A2gen), tmp> eq A2dot2;

  tmp   := [];
  for i in T do
    if c2^-1*elt<G|i>*c2 notin A2 and rho(c2^-1*elt<G|i>*c2) in A2dot2 then
      Append(~tmp, i);
    end if;
  end for;


  U     := sub<Codomain(rho)|rho(elt<G|<4,1>>*elt<G|<3,1>>)>;
  tmp   := [i:i in Wmat|g2^i in U and i notin T1];

  U     :=sub<Codomain(rho)|rho(elt<G|<7,1>>*elt<G|<1,1>>)>;
  tmp   := [i:i in Wmat|gc1^i in U and i notin T1];

  tmp[1]^g2 in A2dot2;
  [GroupName(i): i in [Wmat^g1 meet A2mat, Wmat^g1 meet A2dot2, A2mat^g1 meet A2mat, A2dot2^g1 meet A2dot2]];
  g     := (elt<G|<3,1>>*elt<G|<9,1/2*(p - 1)>>)@rho;
  elt<G|<3,1>>*elt<G|<9,1/2*(p - 1)>>;
  T1.1^g in A2mat; T1.2^g in A2mat;
  T1.1^g in A2dot2; T1.2^g in A2dot2;
  k     := 6;
  (T1.1^k)^g in A2mat; (T1.2^k)^g in A2mat;
  (T1.1^k)^g in A2dot2; (T1.2^k)^g in A2dot2;
// Get nilpotent elements x_r(t)

rts       := [elt<G|<1,1>>,
              elt<G|<2,1>>,
              elt<G|<3,1>>,
              elt<G|<4,1>>,
              elt<G|<5,1>>,
              elt<G|<6,1>>,
              elt<G|<7,x>>,
              elt<G|<8,x>>,
              elt<G|<9,x>>,
              elt<G|<10,x>>,
              elt<G|<11,x>>,
              elt<G|<12,x>>];
U1:= sub<Codomain(rho)|rho(elt<G|<1,1>>),rho(elt<G|<1,x>>)>;
U2:= sub<Codomain(rho)|rho(elt<G|<2,1>>),rho(elt<G|<2,x>>)>;
U3:= sub<Codomain(rho)|rho(elt<G|<3,1>>),rho(elt<G|<3,x>>)>;
U4:= sub<Codomain(rho)|rho(elt<G|<4,1>>),rho(elt<G|<4,x>>)>;
U5:= sub<Codomain(rho)|rho(elt<G|<5,1>>),rho(elt<G|<5,x>>)>;
U6:= sub<Codomain(rho)|rho(elt<G|<6,1>>),rho(elt<G|<6,x>>)>;
U7:= sub<Codomain(rho)|rho(elt<G|<7,1>>),rho(elt<G|<7,x>>)>;
U8:= sub<Codomain(rho)|rho(elt<G|<8,1>>),rho(elt<G|<8,x>>)>;
U9:= sub<Codomain(rho)|rho(elt<G|<9,1>>),rho(elt<G|<9,x>>)>;
U10:= sub<Codomain(rho)|rho(elt<G|<10,1>>),rho(elt<G|<10,x>>)>;
U11:= sub<Codomain(rho)|rho(elt<G|<11,1>>),rho(elt<G|<11,x>>)>;
U12:= sub<Codomain(rho)|rho(elt<G|<12,1>>),rho(elt<G|<12,x>>)>;


  A1A1mat := sub<Codomain(rho)|rho(rts)>;
  A1      := SubsystemSubgroup(G,{12});
  rts     := [elt<G|<12,1>>,
                elt<G|<12,x>>];
  A1mat   := sub<Codomain(rho)|rho(rts)>;

   s0     := 2*(p^8 - p^6 - p^5 + p^3);
   s      := s0^2;
   A2s    := [A2mat^rho(elt<G|<1,i>>) : i in [0, 1]] cat [A2mat^rho(elt<G|<3,1>>*elt<G|<4, 1>>)];
   A2s    := A2s cat [A2mat^rho(elt<G|<3,i>>*elt<G|<9,i>>) : i in [1..1/2*(p - 1)]];
   A2dot2s:= [A2dot2^rho(elt<G|<1,i>>) : i in [0, 1]] cat [A2dot2^rho(elt<G|<3,1>>*elt<G|<4, 1>>)];
   A2dot2s:= A2dot2s cat [A2dot2^rho(elt<G|<3,1>>*elt<G|<9,i>>) : i in [1..1/2*(p - 1)]];
   ints   := [[A2mat meet A2s[i], A2dot2 meet A2dot2s[i]] : i in [1..1/2*(p + 1)+2]];
   dcsizes:= [s/#ints[i][2] : i in [1..1/2*(p + 1)+2]];
   types  := [[GroupName(A2mat meet A2s[i]), GroupName(A2dot2 meet A2dot2s[i])] : i in [1..1/2*(p + 1)+2]]; types; dcsizes

 // Outcomes of ints:
 //   [ C5:D5.A5, C5:D5.A5 ],
 //   [ PSL(3,5), PSL(3,5).C2 ], just the groups themselves
 //   [ SL(2,5), SL(2,5):C2 ],
 //   [ SL(2,5), Q8.A5 ],
 //   [ He5, C5^2:C10 ],


 // Construct root subgroup
   RtSubgrp := function(type, p, rts)
     FGLie  := GroupOfLieType(type, p);
     rho    := StandardRepresentation(FGLie);
     K<x>   := GF(p);
     temp   := [elt<FGLie|<i,1>> : i in rts];
     U      := sub<Codomain(rho)|rho(temp cat [elt<FGLie|<i,x>> : i in rts])>;
     return U;
   end function;

 // Construct subgroup generated by root subgroups and the standard maximal torus
   UT        := function(type, p, rts)
      FGLie  := GroupOfLieType(type, p);
      rho    := StandardRepresentation(FGLie);
      K<x>   := GF(p);
      temp   := [elt<FGLie|<i,1>> : i in rts];
      temp   := temp cat [elt<FGLie|<i,x>> : i in rts];
      T      := StandardMaximalTorus(FGLie);
      Tgen   := Generators(T);
      UT     := sub<Codomain(rho)|rho(temp cat Tgen)>;
      return UT;
    end function;


  g:=rho(elt<G|<1,1>>);H1:=ms[4]^g;
  g:=rho(elt<G|<1,2>>);H2:=ms[4]^g;
  g:=rho(elt<G|<1,3>>);H3:=ms[4]^g;
  g:=rho(elt<G|<1,4>>);H4:=ms[4]^g;
  g:=rho(elt<G|<1,5>>);H5:=ms[4]^g; // In this case, g is the identity element, and so H5 = H. Used this as a sanity check...
  GroupName(ms[4] meet H1);
  GroupName(ms[4] meet H2);
  GroupName(ms[4] meet H3);
  GroupName(ms[4] meet H4);
  GroupName(ms[4] meet H5);
  GroupName(ms[4] meet A2mat);


  ms:=[];
  for i in [1..7] do ms[i] := MaximalSubgroups(G1)[i]`subgroup;
  end for;

  msorder:=[];
  for i in [1..7] do msorder[i] := Order(ms[i]);
  end for;

  // Not relevant but just curious: what about intersections of maximal subgroups that are not conjugate?
  ints:=[];
  for i in [1..7] do
    for j in [i+1..7] do Append(~ints,ms[i] meet ms[j]);
    end for;
  end for;

  isomtyps:=[];
  for i in [1..21] do Append(~isomtyps,GroupName(ints[i]));
  end for;
  // isomtypes;
  //[ C1, C1, S3, C1, C2, S3, C2, S3, D6, S3, S3, D4, D4, D4, D6, SL(2,5):C2^2, D5*F5, He5:(C2*C4), D5*F5, C4.A5, F5^2 ]

//
K<x>  := GF(p);
rts   := [
elt<G|<2,1>>,
elt<G|<5,1>>,
elt<G|<6,1>>,
elt<G|<2,x>>,
elt<G|<5,x>>,
elt<G|<6,x>>
];
T     := StandardMaximalTorus(G);
Tgen  := Generators(T)@rho;
sub<Codomain(rho)|rho(rts)>;
rts   := [
elt<G|<5,1>>,
elt<G|<6,1>>,
elt<G|<8,1>>,
elt<G|<12,1>>,
elt<G|<5,x>>,
elt<G|<6,x>>,
elt<G|<8,x>>,
elt<G|<12,x>>
];
U:=sub<Codomain(rho)|rho(rts)>;

//
P<q>:=PolynomialRing(Rationals());
P!ChevalleyOrderPolynomial("G",2);
