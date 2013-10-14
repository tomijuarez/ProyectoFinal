unit Estructu;


interface


const
    { Cantidad máxima de elementos para las filas y pilas }
    MAXPASCALITO = 100;

type
    { Tipo de los elementos contenidos de las filas y pilas }
    TipoPascalito = Integer;

    Pila =
        record
            elementos : array [1..MAXPASCALITO] of TipoPascalito;
            { "cant" es la cantidad de elementos y además indica el tope de la pila }
            cant : Integer;
        end;

    Fila =
        record
            elementos : array [1..MAXPASCALITO] of TipoPascalito;
            { La fila se implementa con un arreglo "circular".
              "cant" es la cantidad de elementos y
              "primero" indica la posición del primer elemento }
            primero : Integer;
            cant : Integer;
        end;


{ ** Procedimientos y funciones del tipo Pila ********************* }


procedure    inicPila       (var p : Pila; cad : String);

function     tope           (p : Pila) : TipoPascalito;

function     pilaVacia      (p : Pila) : Boolean;

procedure    apilar         (var p : Pila; elem : TipoPascalito);

function     desapilar      (var p : Pila) : TipoPascalito;

procedure    readPila       (var p : Pila);

procedure    writePila      (p : Pila);


{ ** Procedimientos y funciones del tipo Fila ********************* }


procedure    inicFila       (var f : Fila; cad : String);

function     primero        (f : Fila) : TipoPascalito;

function     filaVacia      (f : Fila) : Boolean;

procedure    agregar        (var f : Fila; elem : TipoPascalito);

function     extraer        (var f : Fila) : TipoPascalito;

procedure    readFila       (var f : Fila);

procedure    writeFila      (f : Fila);




implementation


const
    SEPARADOR_MOSTRAR = ' ';
    SEPARADOR_CADENA  = ' ';

    ERROR_CARGAR_ENTRADA = 'ERROR: No se pudo procesar la entrada correctamente (puede que uno de los elementos no sea valido o el numero de los mismos sea mayor que la capacidad del contenedor)';
    ERROR_CADENA_INIC    = 'ERROR: No se pudo procesar la cadena de inicialización correctamente (puede que uno de los elementos no sea valido o el numero de los mismos sea mayor que la capacidad del contenedor)';

    ERROR_REBALSE_PILA         = 'ERROR: Se apilaron demasiados elementos en una pila';
    ERROR_TOPE_PILA_VACIA      = 'ERROR: Se accedio al tope de una pila vacia';
    ERROR_DESAPILAR_PILA_VACIA = 'ERROR: Se desapilo un elemento en una pila vacia';

    ERROR_REBALSE_FILA       = 'ERROR: Se agregaron demasiados elementos en una fila';
    ERROR_PRIMERO_FILA_VACIA = 'ERROR: Se accedio al primer elemento de una pila vacia';
    ERROR_EXTRAER_FILA_VACIA = 'ERROR: Se extrajo un elemento en una fila vacia';


type
    ArregloTipoPascalito = array [1..MAXPASCALITO] of TipoPascalito;



{ ** Procedimientos generales compartidos por Pila y Fila ******************* }

{ Auxiliar:
  Termina la ejecución del programa con un mensaje de error }

procedure abortar (msg : String);
begin
    writeln;
    writeln (msg);
    halt (1);
end;

{ Auxiliar:
  Convierte un elemento de la representación en la cadena de entrada
  al valor que se almacenará en las estructuras.
  Se asume que el tipo es numérico (Integer, Float, etc) }

procedure convertirElemento (elem : String; var valor : TipoPascalito;
    var error : boolean);
var
    codigo : Word;
begin
    val (elem, valor, codigo);

    if codigo <> 0 then
        error := true;
end;

{ Auxiliar:
  Extrae los elementos de la "cadena" de entrada de forma que el valor
  de los mismos quede en el arreglo "elementos" }

procedure convertirCadena (cadena : String; var elementos : ArregloTipoPascalito;
    var cant : integer; var error : boolean);
var
    i : integer;
    subelem : String;
begin
    cant := 0;
    error := false;

    subelem := '';
    i := 1;

    while (i <= length(cadena)) and (not error) do
    begin
        if cadena[i] = SEPARADOR_CADENA then
            begin
                if subelem <> '' then
                    if cant < MAXPASCALITO then
                        begin
                            cant := cant + 1;
                            convertirElemento (subelem, elementos[cant], error);
                            subelem := '';
                        end
                    else
                        error := true;
            end
        else
            subelem := subelem + cadena[i]; { concatenación }

        inc (i);
    end;

    if subelem <> '' then
        if cant < MAXPASCALITO then
            begin
                cant := cant + 1;
                convertirElemento (subelem, elementos[cant], error);
            end
        else
            error := true;
end;



{ ** Procedimientos y funciones del tipo Pila ******************************* }

procedure inicPila (var p : Pila; cad : String);
var
    elementos : ArregloTipoPascalito;
    i, cant : integer;
    error : boolean;
begin
    p.cant := 0;

    convertirCadena (cad, elementos, cant, error);

    if error then
        abortar (ERROR_CADENA_INIC)
    else
        for i := 1 to cant do
            apilar (p, elementos[i]);
end;


function tope (p : Pila) : TipoPascalito;
begin
    if p.cant > 0 then
        tope := p.elementos[p.cant]
    else
        abortar (ERROR_TOPE_PILA_VACIA);
end;


function pilaVacia (p : Pila) : Boolean;
begin
    pilaVacia := (p.cant = 0);
end;


procedure apilar (var p : Pila; elem : TipoPascalito);
begin
    if p.cant < MAXPASCALITO then
        begin
            p.cant := p.cant + 1;
            p.elementos[p.cant] := elem;
        end
    else
        abortar (ERROR_REBALSE_PILA);
end;


function desapilar (var p : Pila) : TipoPascalito;
begin
    if p.cant > 0 then
        begin
          	desapilar := p.elementos[p.cant];
            p.cant := p.cant - 1;
        end
    else
        abortar (ERROR_DESAPILAR_PILA_VACIA);
end;


procedure readPila (var p : Pila);
var
    entrada : String;
    elementos : ArregloTipoPascalito;
    i, cant : integer;
    error : boolean;
begin
    writeln ('Ingresar elementos a la pila:    <Base> <  ...  > <Tope>');
    readln (entrada);

    p.cant := 0;

    convertirCadena (entrada, elementos, cant, error);

    if error then
        abortar (ERROR_CARGAR_ENTRADA)
    else
        for i := 1 to cant do
            apilar (p, elementos[i]);
end;


procedure writePila (p : Pila);
var
    i : Integer;
begin
    write ('<Base> <  ');

    if p.cant > 0 then
        begin
            for i:= 1 to p.cant do
            begin
                write (p.elementos[i]);
                write (SEPARADOR_MOSTRAR);
            end;
        end
    else
        write ('Vacia ');

    writeln ('  > <Tope>');
end;



{ ** Procedimientos y funciones del tipo Fila ******************************* }

{ Auxiliar:
  Devuelve la posición del último elemento de la fila dada }

function ultimaPosicion (f : Fila) : Integer;
begin
    ultimaPosicion := (f.primero + f.cant - 1) mod MAXPASCALITO;
end;


procedure inicFila (var f : Fila; cad : String);
var
    elementos : ArregloTipoPascalito;
    i, cant : integer;
    error : boolean;
begin
    f.cant := 0;
    f.primero := 1;

    convertirCadena (cad, elementos, cant, error);

    if error then
        abortar (ERROR_CADENA_INIC)
    else
        for i := 1 to cant do
            agregar (f, elementos[i]);
end;


function primero (f : Fila) : TipoPascalito;
begin
    if f.cant > 0 then
        primero := f.elementos[f.primero]
    else
        abortar (ERROR_PRIMERO_FILA_VACIA);
end;


function filaVacia (f : Fila) : Boolean;
begin
    filaVacia := (f.cant = 0);
end;


procedure agregar (var f : Fila; elem : TipoPascalito);
begin
    if f.cant < MAXPASCALITO then
        begin
            f.elementos[ultimaPosicion (f) + 1] := elem;
            f.cant := f.cant + 1;
        end
    else
        abortar (ERROR_REBALSE_FILA);
end;


function extraer (var f : Fila) : TipoPascalito;
begin
    if f.cant > 0 then
        begin
            extraer := f.elementos[f.primero];
            f.cant := f.cant - 1;
            f.primero := (f.primero mod MAXPASCALITO) + 1
        end
    else
        abortar (ERROR_EXTRAER_FILA_VACIA);
end;


procedure readFila (var f : Fila);
var
    entrada : String;
    elementos : ArregloTipoPascalito;
    i, cant : integer;
    error : boolean;
begin
    writeln ('Ingresar elementos a la fila:    <Primero> <  ...  > <Ultimo>');
    readln (entrada);

    f.cant := 0;
    f.primero := 1;

    convertirCadena (entrada, elementos, cant, error);

    if error then
        abortar (ERROR_CARGAR_ENTRADA)
    else
        for i := 1 to cant do
            agregar (f, elementos[i]);
end;


procedure writeFila (f : Fila);
var
    i : Integer;
begin
    write ('<Primero> <  ');

    if f.cant > 0 then
        begin
            if f.primero <= ultimaPosicion (f) then
                begin
                    for i:= f.primero to ultimaPosicion (f) do
                    begin
                        write (f.elementos[i]);
                        write (SEPARADOR_MOSTRAR);
                    end;
                end
            else
                begin
                    for i:= f.primero to MAXPASCALITO do
                    begin
                        write (f.elementos[i]);
                        write (SEPARADOR_MOSTRAR);
                    end;
                    for i:= 1 to ultimaPosicion (f) do
                    begin
                        write (f.elementos[i]);
                        write (SEPARADOR_MOSTRAR);
                    end;
                end;
        end
    else
        write ('Vacia ');

    writeln ('  > <Ultimo>');
end;


end.
