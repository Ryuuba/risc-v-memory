# Lectura y escritura en la memoria principal

En este repositorio se alojan ejemplos sobre el uso de las instrucciones de lectura y escritura definidas en el conjunto de instrucciones RV-32I. Para esta arquitectura, el valor de la palabra en bytes es igual a cuatro, por lo tanto, la dirección que se accede debe ser múltiplo de cuatro. La media palabra mide 2 bytes, en consecuencia, la dirección de la media palabra debe ser par. Cualquier byte de la memoria también puede accederse. Asimismo, se explican las directivas de ensamblador que se utilizan para colocar el programa en la sección de texto y las variables globales en la sección de datos.

## Instrucciones de acceso a memoria

En las siguientes tablas se presentan las instrucciones que permiten leer y escribir datos de la memoria principal, respectivamente. 

| Lectura | Significado | Ejemplo        | Explicación     |
| ------- | ----------- | -------------- | --------------- |
| `lw`    | *load word* | `lw t0, 0(gp)` | Guarda en t0 la palabra M[gp + 0] |
| `lh`    | *load half word* | `lh t0, 0(gp)` | Guarda en t0 la media palabra M[gp + 0] |
| `lb`    | *load byte* | `lb t0, 0(gp)` | Guarda en t0 el byte M[gp + 0] |


| Escritura | Significado | Ejemplo        | Explicación     |
| ------- | ----------- | -------------- | --------------- |
| `sw`    | *store word* | `lw t0, 0(gp)` | Guarda en M[gp + 0] el valor de t0|
| `sh`    | *store half word* | `lh t0, 0(gp)` | Guarda M[gp + 0] los bits t0[15:0]|
| `sb`    | *store byte* | `lb t0, 0(gp)` | Guarda en M[gp + 0] los bits t0[7:0] |

Las instrucciones de acceso a la memoria requieren como primer operando un registro. Este registro guarda el valor que se traerá de la memoria en el caso de las instrucciones de lectura. En el caso de las instrucciones de escritura, este registro contiene el valor que va a escribirse en la memoria.

El segundo operando que estas instrucciones requieren es una compensación (*offset*), la cual corresponde a una constante inmediata que puede ser positiva o negativa y que se suma a la dirección almacenada por el registro apuntador. Esta compensación permite acceder a datos o instrucciones que son contiguos a la dirección almacenada en el apuntador.

Los registros apuntadores almacenan **direcciones** de la memoria principal y sirven como referencia para acceder a otros datos del programa. En general, cualquier registro de la arquitectura RV32-I puede utilizarse como apuntador; no obstante, los más comúnes son los siguientes tres:

- `gp`, *global pointer*, este apuntador permite acceder «rápidamente» a las variables globales.
- `sp`, *stack pointer*, este apuntador apunta al tope de la pila, donde se almacenan las variables de las funciones.
- `fp`, *frame pointer*, este apuntador se utiliza para acceder a las variables de una función. 

Además de las instrucciones que permiten acceder a los datos de la memoria principal, se tiene la pseudoinstrucción `la` (*load address*) que permite obtener direcciones de memoria.

| Lectura | Significado | Ejemplo        | Explicación     |
| ------- | ----------- | -------------- | --------------- |
| `la`    | *load address* | `la t0, LABEL` | Carga en t0 la dirección de memoria asociada a `LABEL` |

## Acceso a la sección de datos

En el lenguaje RISC-V se encuentra la directiva `.data`, la cual indica que los datos que viene después deben almacenarse en la sección de datos globales (aquellos que pueden ser accedidos por diferentes funciones que pueden pertencer a diferentes programas).

Cuando se declaran variables globales en C++, éstas deben alojarse en la sección de datos de la siguiente manera.

| C++            | RISC-V         |
| -------------- | -------------- |
|                | `.data`        |
| `int a = 10;`  | `a: .word 10`  |
| `int b;`       | `b: .space 4`  |
| `int c = -12;` | `c: .word -12` |

En la tabla de arriba también se emplean las directivas 