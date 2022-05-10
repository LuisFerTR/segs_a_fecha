% Programa: segs_fecha
% Función: Convierte una cantidad de segundos (timestamp)
%          a formato DD/MM/AA HH:MM:SS (Hora de Greenwich)

main :-
    write('Timestamp: '), read(Timestamp),
    segs_a_fecha(Timestamp, Segundos, Minuto, Hora, 
                 Dia, Mes, Agnio),
    format('~d/~d/~d ~d:~d:~d', 
            [Dia, Mes, Agnio, Hora, Minuto, Segundos]), 
    nl.


segs_a_fecha(Timestamp, Segundos, Minuto, Hora, Dia, Mes, Agnio) :- 
    divmod(Timestamp, 86400, DiasHastaAhora, HorasHastaAhora),
    calcular_agnios(DiasHastaAhora, 1970, Agnio, DiasSobrantes),
    calcular_mes(DiasSobrantes, Agnio, 1, Mes, Dia),
    calcular_hora(HorasHastaAhora, Hora, Minuto, Segundos).


calcular_hora(HorasHastaAhora, Hora, Minuto, Segundos) :-
    divmod(HorasHastaAhora, 3600, Hora, MinutosRestantes),
    divmod(MinutosRestantes, 60, Minuto, Segundos). 


calcular_mes(DiasRestantes1, Agnio, Origen, Mes, Dia) :-
    esBisiesto(Agnio) -> mes_en_bisiesto(DiasRestantes1, Agnio, Origen, Mes, Dia) ;
    mes_en_normal(DiasRestantes1, Agnio, Origen, Mes, Dia).


mes_en_bisiesto(DiasRestantes1, Agnio, Origen, Mes, Dia) :-
    (Origen = 2 -> (DiasRestantes1 - 29 < 0 ->
    Mes is Origen,
    Dia is DiasRestantes1  ; 
    DiasRestantes2 is DiasRestantes1 - 29,
    Origen1 is Origen+1, 
    mes_en_bisiesto(DiasRestantes2, Agnio, Origen1, Mes, Dia)) ;
    
    diasMes(Origen, CantDias),

    (DiasRestantes1 - CantDias =< 0 -> 
    Mes is Origen,
    Dia is DiasRestantes1  ;

    DiasRestantes2 is DiasRestantes1 - CantDias,
    Origen1 is Origen+1, 
    mes_en_bisiesto(DiasRestantes2, Agnio, Origen1, Mes, Dia))).


mes_en_normal(DiasRestantes1, Agnio, Origen, Mes, Dia) :-
    diasMes(Origen, CantDias),

    (DiasRestantes1 - CantDias =< 0 -> 
    Mes is Origen,
    Dia is DiasRestantes1  ;
    
    DiasRestantes2 is DiasRestantes1 - CantDias,
    Origen1 is Origen+1, 

    mes_en_normal(DiasRestantes2, Agnio, Origen1, Mes, Dia)). 


calcular_agnios(DiasRestantes, Origen, Agnio, DiasSobrantes) :- 
    % Determinar si hay suficientes dias para sumar un año.
    (DiasRestantes < 365) ->  Agnio is Origen,
    % Sumar dia actual
    DiasSobrantes is DiasRestantes + 1 ;
    
    % Si el año es bisiesto restar 366 días a la cantidad de días,
    % caso contrario restar 365 días.
    (esBisiesto(Origen) -> DiasRestantes1 is DiasRestantes - 366 ; 
    DiasRestantes1 is DiasRestantes - 365), 
    
    % Agregar un año.
    Origen1 is Origen + 1,
    calcular_agnios(DiasRestantes1, Origen1, Agnio, DiasSobrantes).


esBisiesto(Agnio) :-
    R4 is Agnio mod 4,
	R100 is Agnio mod 100,
	R400 is Agnio mod 400,
    ((R4 = 0, R100\= 0); R400 = 0).


diasMes(Mes, CantDias) :-
    (Mes = 1 ; Mes = 3 ; Mes = 5; Mes = 7; Mes = 8; 
    Mes = 10; Mes = 12) -> CantDias is 31 ; (
    (Mes = 4 ; Mes = 6 ; Mes = 9; Mes = 11) -> CantDias is 30 ; 
    CantDias is 28).
