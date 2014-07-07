% Author: Filip Šedivý
% Date: 25.6.2014

% Pøíklad 1 : Jazyk je tvoøen slovy nad abecedou "abc", jež zaèínají na "ab", "bac", "ca"

%pocatecni_stav(qA).
%pocatecni_stav(qB).
%pocatecni_stav(qC).

%prechod_fce(qA,a,qa).
%prechod_fce(qa,b,qab).
%prechod_fce(qab,_,qkonec).
%prechod_fce(qB,b,qb).
%prechod_fce(qb,a,qba).
%prechod_fce(qba,c,qbac).
%prechod_fce(qbac,_,qkonec).
%prechod_fce(qC,c,qc).
%prechod_fce(qc,a,qca).
%prechod_fce(qca,_,qkonec).
%prechod_fce(qkonec,_,qkonec).

%prijimaci_stav(qkonec).

% Pøíklad 2

%pocatecni_stav(qA).
%pocatecni_stav(qC).

%prechod_fce(qA,a,qA).
%prechod_fce(qA,a,qD).
%prechod_fce(qA,b,qB).
%prechod_fce(qB,b,qB).
%prechod_fce(qB,b,qC).
%prechod_fce(qC,a,qA).
%prechod_fce(qC,b,qC).
%prechod_fce(qC,b,qD).

%prijimaci_stav(qA).
%prijimaci_stav(qD).

% Pøíklad 3 : Jazyk nad abecedou "ab", kde slova mají na konci jedno b (pøedcházející áèkem), ale na b nezaèíná, nebo mají poèet áèek dìlitelný 3.

pocatecni_stav(q0).

prechod_fce(q0,a,q1).
prechod_fce(q1,a,q2).
prechod_fce(q2,a,q0).
prechod_fce(q1,b,q1).
prechod_fce(q1,b,q0).
prechod_fce(q2,b,q2).
prechod_fce(q2,b,q0).

prijimaci_stav(q0).

automat(Slovo) :- pocatecni_stav(Stav),automat(Stav,Slovo).
automat(Stav,[]) :- prijimaci_stav(Stav).
automat(Stav,[Znak|Zbytek_slova]) :- prechod_fce(Stav,Znak,Novy_stav),
                                     automat(Novy_stav,Zbytek_slova).
