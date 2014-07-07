% Author:
% Date: 25.6.2014

pocatecni_stav(q0).

prechod_fce(q0,a,q1).
prechod_fce(q2,b,q3).
prechod_fce(q3,_,q3).
prechod_fce(q1,q2).

prijimaci_stav(q3).

automat(Slovo) :- pocatecni_stav(Stav),automat(Stav,Slovo).
automat(Stav,[]) :- prijimaci_stav(Stav).
automat(Stav,[Znak|Zbytek_slova]) :- prechod_fce(Stav,Znak,Novy_stav),
                                     automat(Novy_stav,Zbytek_slova).
automat(Stav,Slovo) :- prechod_fce(Stav,Novy_stav), % lambda pøechod
                       automat(Novy_stav,Slovo).