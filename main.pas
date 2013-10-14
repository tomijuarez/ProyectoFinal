program Practico;
 
uses Estructu;

{
	@procedure changeElements
	@param From [Pila] -Se le quita todos los elementos-
	@param Receiver [Pila] -Adquiere todos los elementos del parámetro From-
	@note Este procedimiento recibe una pila From y pasa todos sus elementos a otra pila Receiver.  
}

procedure changeElements( var From, Receiver: Pila );
	begin
		while not ( PilaVacia ( From ) ) do
			apilar ( Receiver, desapilar ( From ) );
	end;

{
	@procedure searchAndReplace
	@param Haystack [Pila] -Se miran todos sus elementos, de ser necesario se edita-
	@param Receiver [Pila] -Se mira el tope de esta pila, no se edita-
	@param Receiver [Pila] -Contiene los elementos a reemplzar, de ser necesario, se edita-
	@note Este procedimiento recibe una pila Haystack y se observa si alguno de sus elementos coincide con el tope de la pila Needle,
				de coincidir, se reemplaza ese elemento de Haystack por cada uno de los elementos de la pila ReplaceStack,
				hasta que ésta esté vacía o hasta que no haya elementos para reemplazar en Haystack.  
}

procedure searchAndReplace ( var Haystack:Pila; Needle:Pila; var ReplaceStack:Pila );

	var Auxiliary
				:Pila
		;

	begin

		inicPila ( Auxiliary, '' );

		while not PilaVacia ( Haystack ) AND not PilaVacia ( ReplaceStack ) do
			begin
				if ( tope ( Haystack ) = tope ( Needle ) ) then
					begin 
						desapilar ( Haystack );
						apilar ( Haystack, desapilar ( ReplaceStack ) );
					end
				else
					apilar ( Auxiliary, desapilar ( Haystack ) );
			end;
			if not PilaVacia ( Auxiliary ) then
				changeElements ( Auxiliary, Haystack );
	end;


var Source
	, Model
	,	Replace
			:Pila
	;


begin

	writeln ( 'Introduzca una pila origen.' );
	readPila ( Source );
	
	writeln ( 'Introduzca una pila modelo.' );
	readPila ( Model );

	writeln ( 'Introduzca una pila reemplazo.' );
	readPila ( Replace );

	{*Si alguna de las 3 pilas cargadas por teclado estan vacías, entonces el programa termina*}
	if not ( PilaVacia ( Source ) OR PilaVacia ( Model ) OR PilaVacia ( Replace ) ) then
		begin
			searchAndReplace ( Source, Model, Replace );
			writePila ( Source );
		end;
end.