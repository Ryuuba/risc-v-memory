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

- `gp`, *global pointer*, este apuntador permite acceder a las variables globales.
- `sp`, *stack pointer*, este apuntador apunta al tope de la pila, donde se almacenan las variables de las funciones.
- `fp`, *frame pointer*, este apuntador se utiliza para acceder a las variables de una función. 

Además de las instrucciones que permiten acceder a los datos de la memoria principal, se tiene la pseudoinstrucción `la` (*load address*) que permite obtener direcciones de memoria.

| Lectura | Significado | Ejemplo           | Explicación     |
| ------- | ----------- | ----------------- | --------------- |
| `la`    | *load address* | `la t0, LABEL` | Carga en t0 la dirección de memoria asociada a `LABEL` |

## Almacenamiento en la sección de datos

En el lenguaje RISC-V se encuentra la directiva `.data`, la cual indica que los datos que viene después deben almacenarse en la sección de datos globales (aquellos que pueden ser accedidos por diferentes funciones que pueden pertenecer a diferentes programas).

Cuando se declaran variables globales en C++, éstas deben alojarse en la sección de datos de la siguiente manera.

| C++            | RISC-V         |
| -------------- | -------------- |
|                | `.data`        |
| `int a = 10;`  | `a: .word 10`  |
| `int b;`       | `b: .space 4`  |
| `int c = -12;` | `c: .word -12` |

En la tabla de arriba se muestra cómo emplea la directiva `.word` para compilar la inicialización de una variable. Esta directiva permite reservar una palabra en la sección de datos globales cuando su valor es conocido. Después del uso de la directiva `.word` es necesario indicar el valor que la palabra debe tomar, tal como se muestra en la tabla de arriba con la directiva `a: .word 10`.

La directiva `.space` se utiliza para reservar en la sección de datos `n` bytes cuando el valor de la variable global es desconocido. La expresión `int b;` se compila como `b: .space 4` porque se requieren cuatro bytes para almacenar un entero de C/C++. Con la directiva `.space` se pueden reservar tantos bytes como se requieran.

## Escritura en la sección de datos mediante la pseudoinstrucción `la`

En la siguiente tabla se muestra cómo se compila la expresión `b = -5;` a RISC-V. 

| C++            | RISC-V              |
| -------------- | ------------------- |
| `b = -5;`      | `addi t0, zero, 5`  |
|                | `la t1, b`          |
|                | `sw t0, 0(t1)`      |

La primera instrucción en ensamblador carga la constante 5 en el registro temporal `t0`. Después, se emplea la pseudoinstrucción `la` para obtener la dirección de la etiqueta `b` y almacenarla en el registro `t1`. Una vez obtenida dicha dirección, es posible usar la instrucción `sw` para almacenar el valor de `t0` usando a `t1` como apuntador. En este caso, la compensación usada en la instrucción `sw` es cero porque `t1` efectivamente tiene la dirección de la etiqueta `b`.

En el archivo `global_la.s` se encuentra el código ensamblador que corresponde a la compilación del código contenido en el archivo `global.cc` mediante el uso de la pseudoinstrucción `la`.

## Escritura en la sección de datos mediante el apuntador `gp`

Emplear la pseudoinstrucción `la` para obtener la dirección de una localidad de sección de datos es ineficiente. En su lugar, resulta más conveniente emplear el apuntador global `gp` más alguna compensación para acceder a las localidades de la sección de datos globales.

| C++            | RISC-V              |
| -------------- | ------------------- |
| `b = -5;`      | `addi t0, zero, 5`  |
|                | `sw t0, 4(gp)`      |

En la tabla anterior se muestra el código resultante de compilar la expresión de alto nivel `b = -5;` a RISC-V, utilizando el apuntador `gp`, el cual almacena la dirección donde la sección de datos globales comienza. Dado que la variable `a` ocupa una palabra, entonces basta con sumar una compensación de cuatro al valor del apuntador global para así acceder a la localidad de memoria de `b`.

La siguiente tabla muestra el resultado de compilar la expresión de alto nivel `c = a + b;`. En primera instancia, los valores `a` y `b` se cargan en los registros `t0` y `t1`, respectivamente. Esta operación de carga debe hacerse porque la compilación se realiza por instrucción, sin tener en cuenta los valores pasados. 


| C++            | RISC-V              |
| -------------- | ------------------- |
| `c = a + b;`   | `lw   t0, a`        |
|                | `lw   t1, b`        |
|                | `add  t2, t0, t1`   |
|                | `sw   t2, 8(gp)`    |

En el archivo `global_gp.s` se encuentra el código ensamblador que corresponde a la compilación del código contenido en el archivo `global.cc` mediante el uso del apuntador global `gp`. 

## Compilación de arreglos.

Reservar memoria para almacenar los elementos de un arreglo en la sección de datos se realiza empleando las directivas `.word` o `.space`. Se usa `.word` cuando el arreglo está inicializado en alto nivel, mientras que `.space` se utiliza solo cuando se conoce el número de elementos del arreglo.

| C++            | RISC-V              |
| -------------- | ------------------- |
|                | `.data`             |
| `int array[SIZE] = {-5, 4, -3, 2, -1, 0};`  | `array: .word 0, 4, -3, 2, -1, -5` |

En la tabla anterior se muestra que los arreglos se compilan de la misma forma que las variables globales inicializadas en alto nivel, solo que después de la directiva `.word` se deben colocar todos los elementos del arreglo.

Si el arreglo no estuviera inicializado, entonces se usa la directiva `.space` y se reservan tanto bytes como sean necesarios para almacenar los elementos del arreglo, según su tipo; por ejemplo, la expresión `short array[4];` se compila como `array: .space 8` porque se necesitan ocho bytes para alojar cuatro enteros cortos.

Para compilar la expresión de C++ `a[i]`, se requiere utilizar la siguiente fórmula:

$$a_i = base(a) + i\cdot size,$$

donde $a_i$ es el elemento $i$ del arreglo $a$, $base(a)$ (leído como base de *a*) es la dirección del primer elemento del arreglo y $size$ es el tamaño en bytes del tipo de dato de los elementos del arreglo.