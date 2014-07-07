% Author: Filip Šedivý
% Date: 25.6.2014

% Jazyk je tvoøen slovy nad abecedou "a", kde poèet a je dìlitelný dvìmi nebo pìti.

prechod_fce(q00,a,q11).
prechod_fce(q11,a,q02).
prechod_fce(q02,a,q13).
prechod_fce(q13,a,q04).
prechod_fce(q04,a,q10).
prechod_fce(q10,a,q01).
prechod_fce(q01,a,q12).
prechod_fce(q12,a,q03).
prechod_fce(q03,a,q14).
prechod_fce(q14,a,q00).

prijimaci_stav(q00).
prijimaci_stav(q02).
prijimaci_stav(q04).
prijimaci_stav(q10).
prijimaci_stav(q01).
prijimaci_stav(q03).

automat(Slovo) :- pocatecni_stav(Stav), automat(Stav,Slovo).
automat(Stav,[]) :- prijimaci_stav(Stav).
automat(Stav,[Znak|Zbytek_slova]) :- prechod_fce(Stav,Znak,Novy_stav),
                                     automat(Novy_stav,Zbytek_slova).