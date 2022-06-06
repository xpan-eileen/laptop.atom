// Below is a function to generate the A2 subsystem subgroup of G = G2(q) and the maximal subgroup of type A2.2, then it
// picks random elements in G and computes conjugates of said subgroups and compute the relevant intersections and outputs
// isomorphism types of the intersections.
// Known issue: Magma's Normaliser function is certainly not ideal as it does not deal with larger groups efficiently.
// Potential solution: We use the Normaliser function to construct a subgroup A2.2 containing the subsystem subgroup A2
// with long roots, but another way of doing so is to find the subgroup generated by this A2 and the Weyl group of G, as we know
// that the (representatives of) Weyl group of G is contained in an A2.2, which is not contained in A2.
// However, I couldn't find a nice way to get these representatives...
intsA2      := function(type, p)
  G         := GroupOfLieType(type, p);
  rk        := Rank(G);
  rho       := StandardRepresentation(G);
  K<x>      := GF(p);
  G1        := Image(rho);
  A2        := SubsystemSubgroup(G,{2, 12});
  A2gen     := Generators(SubsystemSubgroup(G,{2, 12}));
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
  assert #W eq #WeylGroup(G);
// Get generators of W
  Wgen      := [elt<G|W.i>@rho : i in [1..rk]];
// Generate A2.2 = <A2, W>
  A2dot2    := sub<Codomain(rho)|rho(A2gen), Wgen>;
  s0        := 2*(p^8 - p^6 - p^5 + p^3);
  assert #A2dot2 eq s0;
  s         := s0^2;
  elts      := [(elt<G|<3,1>>*elt<G|<4,1>>)@rho] cat [(elt<G|<3,1>>*elt<G|<9,i>>)@rho : i in [1..1/2*(p - 1)]];
  A2s       := [A2mat^rho(elt<G|<1,i>>) : i in [0, 1]] cat [A2mat^g : g in elts];
  A2dot2s   := [A2dot2^rho(elt<G|<1,i>>) : i in [0, 1]] cat [A2dot2^g : g in elts];
  ints      := [[A2mat meet A2s[i], A2dot2 meet A2dot2s[i]] : i in [1..1/2*(p + 1)+2]];
  dcsizes   := [s/#ints[i][2] : i in [1..1/2*(p + 1)+2]];
  sum       := 0;
  for i in [1..1/2*(p + 1)+2] do sum := sum + dcsizes[i];
  end for;
  assert sum eq (p^14 - p^12 - p^8 + p^6);
  types     := [[GroupName(A2mat meet A2s[i]), GroupName(A2dot2 meet A2dot2s[i])] : i in [1..1/2*(p + 1) + 2]];
  RF        := recformat< overgroup : GrpLie, A2, A2dot2, maxA2, maxA2dot2, intersections, types, dcsizes >;
  r         := rec< RF | overgroup := G, A2 := GroupName(A2mat), A2dot2 := GroupName(A2dot2),
                maxA2 := [GroupName(i`subgroup):i in MaximalSubgroups(A2mat)],
                maxA2dot2 := [GroupName(i`subgroup):i in MaximalSubgroups(A2dot2)],
                intersections := ints, types := types, dcsizes := dcsizes>;
  return r;
end function;


////////////////////////////////////////////////////////////////////////////////
// Earlier draft code
// Construct G2 over GF(p)+
  p   := 7;
  G   := GroupOfLieType("G2", GF(p));
// Get standard representation
  rho := StandardRepresentation(G);
  G1  := Image(rho);
// Get A2 SubsystemSubgroup
  A2  := SubsystemSubgroup(G,{2, 12});
// Order(A2);
  A2gen := Generators(A2);
// Get maximal torus of A2
  T2    := StandardMaximalTorus(A2);
  T2gen := Generators(T2);
// Get maximal torus of G
  T     := StandardMaximalTorus(G);
// Get Weyl group of G
  T1    := sub< Codomain(rho) | Generators(T)@rho >;
// get extended Weyl group
    V   := sub< Codomain(rho) |  [   elt<G | x >@rho : x in [1..Rank(G)] ] >;
// check order: V / (T1 \cap V) \cong WeylGroup(G)
  W, pi := quo<V | V meet T1>;
  assert #W eq #WeylGroup(G);
  preim := [ i@@pi : i in UserGenerators(W)];
// Get nilpotent elements x_r(t)
  K<x>  := GF(p);
  rts   :=
  [elt<G|<5,1>>,
  elt<G|<6,1>>,
  elt<G|<2,1>>,
  elt<G|<8,1>>,
  elt<G|<5,x>>,
  elt<G|<6,x>>,
  elt<G|<2,x>>,
  elt<G|<8,x>>];

 // Generate <U_{-3\alpha - 2\beta}, U_{-3\alpha - \beta}, U_{\pm \beta}, T2>
   A2mat  := sub<Codomain(rho)|rho(A2gen)>;
   H      := sub<A2mat|rho(rts),rho(T2gen)>;
 // Generate a class representative of maximal subgroups of type A2.2. The Normaliser function could fail badly when G is large.
 // Ideally, generate <A2, W>, but how??
   A2dot2 := sub<Codomain(rho)|rho(A2gen), preim>;
 //  Order(N);
 //  GroupName(N);
 //  GroupName(H);
 //  Get conjugates of A2 and A2.2
 //  A2s    := [A2mat^rho(elt<G|<1,i>>) : i in [1..5]] cat [A2mat^rho(elt<G|<7,i>>*Random(G)) : i in [1..5]];
 //  A2dot2s:= [A2dot2^rho(elt<G|<1,i>>) : i in [1..5]] cat [A2dot2^rho(elt<G|<7,i>>*Random(G)) : i in [1..5]];
 // ints    := [[GroupName(A2mat meet A2s[i]), GroupName(A2dot2 meet A2dot2s[i])] : i in [1..10]]; ints;
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
 //   [ C5:D5.A5, C5:D5.A5 ],
 //   [ C5:D5.A5, C5:D5.A5 ],
 //   [ C5:D5.A5, C5:D5.A5 ],
 //   [ PSL(3,5), PSL(3,5).C2 ], just the groups themselves
 //   [ SL(2,5), SL(2,5):C2 ],
 //   [ SL(2,5), SL(2,5):C2 ],
 //   [ SL(2,5), SL(2,5):C2 ],
 //   [ SL(2,5), SL(2,5):C2 ],
 //   [ SL(2,5), SL(2,5):C2 ]

 //   [ SL(2,5), Q8.A5 ],
 //   [ SL(2,5), SL(2,5):C2 ],
 //   [ He5, C5^2:C10 ],
 //   [ He5, C5^2:C10 ],
 //   [ SL(2,5), SL(2,5):C2 ]

 //   [ He5, C5^2:C10 ],
 //   [ He5, C5^2:C10 ],
 //   [ He5, C5^2:C10 ],
 //   [ C5:D5.A5, C5:D5.A5 ],
 //   [ He5, C5^2:C10 ]

 //   [ He5, C5^2:C10 ],
 //   [ SL(2,5), SL(2,5):C2 ],
 //   [ SL(2,5), SL(2,5):C2 ],
 //   [ He5, C5^2:C10 ],
 //   [ SL(2,5), Q8.A5 ]

 //   [ SL(2,5), Q8.A5 ],
 //   [ SL(2,5), Q8.A5 ],
 //   [ SL(2,5), Q8.A5 ],
 //   [ SL(2,5), Q8.A5 ],
 //   [ SL(2,5), Q8.A5 ]

 //   [ C5:D5.A5, C5:D5.A5 ],
 //   [ SL(2,5), SL(2,5):C2 ],
 //   [ SL(2,5), Q8.A5 ],
 //   [ SL(2,5), SL(2,5):C2 ],
 //   [ C5:D5.A5, C5:D5.A5 ]


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
  GroupName(ms[4] meet A2mat); // Clearly there is some randomness in generating A2, as every time running these functions different results are obtained.
  // Possible outcomes:
  // C5^2:C10              SL(2,5):C2             C5:D5.A5      C5^2:C10
  // SL(2,5):C2            C5^2:C10               C5:D5.A5      C5^2:C10
  // SL(2,5):C2            C5^2:C10               C5:D5.A5      C5^2:C10
  // C5^2:C10              SL(2,5):C2             C5:D5.A5      C5^2:C10
  // PSL(3,5).C2           PSL(3,5).C2            PSL(3,5).C2   PSL(3,5).C2
  // SL(2,5), C4.A5, He5   C4.A5, SL(2, 5), He5   SL(2, 5)      He5, C4.A5




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
P<q>:=PolynomialRing(Rationals());
P!ChevalleyOrderPolynomial("G",2);
