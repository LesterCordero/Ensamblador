#include <stdio.h>
#include <string.h>

extern int apellidosFirst (char *);

int main()
{
   char linea[1000];
   unsigned int num = 500;
   int n;
   
   while (1) {
      printf("Digite nombres y dos apellidos: ");
      fgets(linea, num, stdin);
      linea[strlen(linea)-1] = '\0'; //Remueve \n al final de linea
      printf("Leido : %s\n", linea);
      n = apellidosFirst (linea);
      printf("Reordenado (longitud %d): %s\n\n", n, linea);
   }
}
