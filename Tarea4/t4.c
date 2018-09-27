#include <stdio.h>

extern int subseq(char* hile1, char* hile2); // Determina si hile2 es subsecuencia de hile1
extern int subhile(char* hile1, char* hile2); // Determina si hile2 es subhilera de hile1

// Convierte 1 en "SI" y 0 en "NO" para la salida de printf
char* resultado(int resultado){
	if(resultado == 1){
		return "si";
	}else{
		return "no";
	}
}

// Función sencilla para que el código se vea mas limpio en general
void evalue(char* hile1, char* hile2){
	printf("La hilera \"%s\" %s es subsecuencia de \"%s\" \n", hile2, resultado(subseq(hile1, hile2)), hile1);
	printf("La hilera \"%s\" %s es subhilera de \"%s\" \n\n", hile2, resultado(subhile(hile1, hile2)), hile1);
}

// Función inicial
int main() 
{
	char hile1[] = "amuraamurcielagospqr";
	char hile2[] = "murcielago";
	char hile3[] = "aeiou";
	char hile4[] = "amuraamurcielagospqr";
	char hile5[] = "uieao";
	char hile6[] = "mxaxn0z0anas";
	char hile7[] = "arboldemanzanas";
	char hile8[] = "manzanas";

	evalue(hile1, hile2);
	evalue(hile1, hile5);
	evalue(hile3, hile5);
	
	// Ejemplos propios
	evalue(hile6, hile8);
	evalue(hile7, hile8);
	return 0;
}

