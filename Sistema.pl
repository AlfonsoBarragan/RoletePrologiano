
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DADOS Y CHEQUEOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% tiradasPosibles(Dado, ListaNumerosDeDados)
%% Son una serie de hechos auxiliares para poder usar el predicado
%% dado(Dice, Elt, Length)

tiradasPosibles(d20, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]).
tiradasPosibles(d100, [0,1,2,3,4,5,6,7,8,9]).

%% dado(Dice, Numero, Size)
%% Es un predicado realizado con el objetivo de poder proporcionar un
%% numero aleatorio dentro de un intervalo. Dice, ayuda a elegir entre las dos
%% posibles listas de dados que tenemos disponibles, Num, sera el numero
%% resultante y Size, acotara el intervalo según nos sea conveniente (esto se
%% hace con objeto de tener solo las minimas listas de dados cargadas)

dado([], [], []).
dado(Dice, Num, Size) :-
        tiradasPosibles(Dice, List),
        random(0, Size, Ind),
        nth0(Ind, List, Num).

%% dadoXtimes(Times, Dice, Size, Repeticiones)
%% Se trata de un predicado que acumula en una lista una serie de tiradas de
%% dados del mismo tipo, lanzados consecutivamente.

dadoXtimes(0, _, _, []).
dadoXtimes(Times, Dice, Size, Rep) :-
  NewTimes is Times - 1,
  dado(Dice, Num, Size),
  dadoXtimes(NewTimes, Dice, Size, Rep2),
  append([Num], Rep2, Rep).


%% chequeoD20(Dificultad, Modificador, Resultado)
%% El siguiente predicado evalua el exito o fallo ante un determinado chequeo
%% de Dificultad X, teniendo un modificador M y escribiendo por pantalla el
%% resultado R

chequeoD20(Dif, Mod, Res) :-
        dado(d20, Tirada, 20),
        TiradaTotal is (Tirada + Mod),
        (TiradaTotal >= Dif,
        write('Superado');
        (TiradaTotal < Dif,
        write('Fallado'))), !.

%% chequeoD100(Dificultad, Resultado)
%% El siguiente predicado evalua el exito o fallo ante un determinado chequeo
%% de Dificultad X y escribiendo por pantalla el resultado R

chequeoD100(Dif, Res) :-
        dado(d100, Decena, 10),
        dado(d100, Unidad, 10),
        ((Decena =:= 0, Unidad =:= 0, TiradaTotal is 100);
        (TiradaTotal is (((Decena * 10) + Unidad)))),
        (TiradaTotal >= Dif,
        write('Superado');
        (TiradaTotal < Dif,
        write('Fallado'))), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PERSONAJES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

latributos(estandar, [carisma, constitucion, destreza, fuerza, sabiduria, inteligencia]).

%% personaje(Datos, Inventa[]).rio)
%% El predicado personaje, es una n-tupla de elementos con el cual identificamos
%% a los personajes y que almacena todo lo referente a ellos

crearPj(Datos, Inventario):- Datos is datosPersonaje(Nombre, Descripcion, Nivel,
  Atributos, [],[],[],[]).


datosPersonaje(Nombre, Descripcion, Nivel, Atributos, [], [], [], []):-
                  write('Escriba el nombre de su personaje ---> '),
                  readln(Nombre),
                  write('Escriba una descripcion de usted --->  '),
                  readln(Descripcion),
                  write('Tu nivel actual es ---> 1'),nl(),
                  Nivel is 1,
                  write('Los atributos que te ha concedido la naturaleza son --> '),
                  generarAtributos(6, Atributos),nl(),
                  write('CARISMA | CONSTITUCION | DESTREZA | FUERZA | SABIDURIA | INTELIGENCIA'),nl(),
                  write(Atributos),nl(),
                  write('De momento acabas de nacer, por lo que no has ejercicido ningun oficio'),nl(),
                  write('Tambien careces de habilidades, porque estas recien salido del horno'),nl(),
                  write('Pero estas sano cual arbol recien plantado'),nl(),
                  write('¿Como vas a tener trabajo si no tienes curriculum, payaso?'),nl().

datosInventario(Peso, CapacidadCargaMax, Dinero, Objetos).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Asignar atributos queda aparcado por el momento, la vida es como es, y te %%
%% jodes y juegas con lo que te toca

/*
asignarAtributos([], [], []).
asignarAtributos([_],[],[X]):-asignarAtributos([_],[X],[]).
*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% generarAtributos(NumeroAtributos, []).AtributosGenerados)
%% []).El predicado generarAtributos(N, Gen)

generarAtributos(0, []).
generarAtributos(N, Gen) :-
  NewN is N - 1,
  tiradaAtributo(At),
  generarAtributos(NewN, GenAux),
  append([At], GenAux, Gen), !.

%% tiradaAtributo(AtributoGenerado)
%% El predicado tiradaAtributo(Gen), es un predicado que devuelve el resultado
%% de la tirada de puntuacion de un atributo. El proceso que efectua es lanzar
%% 4 dados de 6, quitando el menor de esos dados.
%% El corte se aplica por si hay duplicados, que no lo efectue varias veces.

tiradaAtributo(Gen) :-
  dadoXtimes(4, d20, 6, List),
  menor(List, Menor),
  select(Menor, List, List2),
  sumaLista(List2, Gen),
  !.

%% menor(Lista, Minimo)
%% El predicado menor(L, Min), devuelve el menor de los elementos de una
%% determinada Lista L.

menor([Min],Min).
menor([H,K|T],M) :-
  H =< K,
  menor([H|T],M).
menor([H,K|T],M) :-
  H > K,
  menor([K|T],M).

ind(E,[E|_],0):- !.
ind(E,[_|T],I):- ind(E,T,X), I is X + 1.

%% sumaLista(Lista, Resultado) :- sumaLista([Cabeza|Cola], Acumulado, Resultado)
%% El predicado sumaLista(L, Res), es un predicado que funciona con un
%% acumulador, el cual suma todos los elementos de una determinada Lista.

sumaLista(L, Res):-
  sumaLista(L, 0, Res).
sumaLista([], A, A).
sumaLista([L|T], A, Res):-
  NewA is L + A,
  sumaLista(T, NewA, Res).
