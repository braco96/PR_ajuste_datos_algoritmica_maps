Práctica: Calibración de un Mapa Digital

Autores:

Hernández Sánchez, Inés

Bravo Collado, Luis

Nota Importe sobre las Figuras:
Para evitar exceder los límites de tamaño en la entrega de la práctica, se recomienda guardar las figuras como archivos JPG (File > Save As) en lugar de usar la función Edit/Copy Figure. De esta forma, se genera una imagen de menor tamaño y se previene la incrustación de datos innecesarios en el documento final.

1. Introducción

1.1 Identificación de Matrices y Vectores del Ajuste

Para el ajuste por mínimos cuadrados, se busca resolver un sistema de la forma H * C = B.

Matriz H: Es la matriz de diseño. Para una transformación afín, se construye a partir de las coordenadas de los píxeles de los puntos de control (Xk, Yk). Tendrá tres columnas: la primera con los valores Xk, la segunda con los valores Yk, y la tercera con una columna de unos para el término independiente.

H = [Xk, Yk, 1]


Vector de Coeficientes (C): Contiene los parámetros de la transformación que queremos calcular. Se calcula un vector de coeficientes para cada coordenada (Este y Norte).

Ce = [m11, m12, d1]'  // Coeficientes para la coordenada Este
Cn = [m21, m22, d2]'  // Coeficientes para la coordenada Norte


Vector de Datos (B): Contiene los valores conocidos a los que queremos ajustar nuestro modelo, es decir, las coordenadas geográficas (Este y Norte) de los puntos de control.

Be = [Ek]'  // Vector con las coordenadas Este
Bn = [Nk]'  // Vector con las coordenadas Norte


¿Algunos de los elementos de ambos problemas son comunes?

Sí. La matriz H es común para el ajuste de ambas coordenadas (Este y Norte), ya que se basa en las mismas coordenadas de píxeles (Xk, Yk) de los puntos de control seleccionados en el mapa.

2. Código del Ajuste

2.1 Razón de la Comprobación Inicial del Número de Puntos (N)

La comprobación if (N<3) es fundamental porque se necesita un mínimo de 3 puntos de control para determinar de forma única los 6 parámetros de la transformación afín (3 para la coordenada Este y 3 para la Norte). Con menos de 3 puntos, el sistema de ecuaciones es indeterminado y no tiene una solución única.

2.2 Código de la Función ajuste.m

function [M, D] = ajuste(Xk, Yk, Ek, Nk)
% Entrada:
% Xk: vector N x 1 con las X's de los pixeles de los N ptos de control
% Yk: vector N x 1 con las Y's de los píxeles de los N ptos de control
% Ek: vector N x 1 con las coordenadas E's de los N ptos de control
% Nk: vector N x 1 con las coordenadas N's de los N ptos de control
%
% Salida: parámetros de la transformación de píxeles --> coordenadas
% M : matriz 2 x 2
% D : vector 2 x 1

% Valores por defecto en caso de no tener suficientes puntos
D = [0; 0];
M = [1 0; 0 1];

N = length(Xk); % Numero de puntos de control
if (N < 3)
    disp('Se necesitan al menos 3 puntos de control.');
    return;
end

% Construcción de la matriz H
H = [Xk, Yk, ones(N, 1)];

% Ajuste para la coordenada Este (E)
coefs_E = H \ Ek;
res_E = Ek - H * coefs_E;

% Ajuste para la coordenada Norte (N)
coefs_N = H \ Nk;
res_N = Nk - H * coefs_N;

% Composición de la matriz de transformación M y el vector de desplazamiento D
M = [coefs_E(1), coefs_E(2); coefs_N(1), coefs_N(2)];
D = [coefs_E(3); coefs_N(3)];

% Opcional: Mostrar residuos en consola para verificación
fprintf('Residuos Coordenada Este (m):');
fprintf(' %.1f\t', res_E);
fprintf('\n');
fprintf('Residuos Coordenada Norte (m):');
fprintf(' %.1f\t', res_N);
fprintf('\n\n');
fprintf('Media de residuos E: %.4e\n', mean(res_E));
fprintf('Media de residuos N: %.4e\n', mean(res_N));

return;


2.3 Matriz M y Vector D Obtenidos

M =
   1.9998   -0.0529
  -0.0511   -2.0003

D =
   304470
   -0.0000


2.4 Residuos del Ajuste

Residuos en coordenada Este (m):

-1.0   -4.0    2.3    5.2   -4.9   -0.8   -0.7    3.9


Residuos en coordenada Norte (m):

 3.9    0.2    1.6    0.7   -5.8    3.3   -0.6   -3.3


Media de los residuos:

mean(res_E) = -4.3656e-11 (prácticamente cero)

mean(res_N) = -8.1491e-10 (prácticamente cero)

¿Sería posible encontrar otra solución con la que saliera un valor menor en esas medias?

No. El método de ajuste por mínimos cuadrados garantiza encontrar la única solución que minimiza la suma de los cuadrados de los residuos. Como consecuencia, la media de los residuos de este ajuste óptimo es siempre cero (o un valor muy cercano a cero debido a la precisión numérica del ordenador).

2.5 Interpretación de la Matriz M

Los elementos de la diagonal M(1,1) ≈ 2 y M(2,2) ≈ -2 corresponden al factor de escala de la transformación, es decir, a la relación entre píxeles y metros (en este caso, aproximadamente 2 metros por píxel).

La razón del signo opuesto se debe a la diferencia en los sistemas de coordenadas:

El eje Y de una imagen crece hacia abajo.

El eje Norte de un mapa crece hacia arriba.
Por tanto, al aumentar la coordenada Y del píxel, la coordenada N geográfica debe disminuir, lo que se refleja en un factor de escala negativo.

2.6 Coordenadas GPS del Refugio Elola

Para obtener las coordenadas del refugio, se utiliza la aplicación map y se posiciona el cursor sobre su ubicación.

[Imagen de la aplicación con el cursor sobre el refugio Elola, mostrando sus coordenadas]

3. Transformación Inversa

3.1 Deducción de M' y D'

La deducción matemática para obtener la matriz M' y el vector D' de la transformación inversa (coordenadas geográficas -> píxeles) a partir de M y D se adjunta en los documentos de la práctica. La solución es:

M' = inv(M)

D' = -inv(M) * D

3.2 Matriz M' y Vector D' de la Transformación Inversa

[Insertar aquí la matriz M' y el vector D' calculados a partir de M y D]

3.3 Código de la Implementación y Ruta Superpuesta

[Insertar aquí el código de MATLAB que calcula la transformación inversa y superpone la ruta del GPS en el mapa]

[Imagen del mapa calibrado con la ruta del GPS superpuesta]

4. Creación de Panoramas (30%)

4.1 Transformación img2 -> img1

Puntos de control [X1 Y1 X2 Y2]:
[Volcado de los puntos de control para la primera transformación]

Parámetros M1 y D1:
[Volcado de la matriz M1 y el vector D1 obtenidos]

4.2 Transformación img2 -> img3

Puntos de control [X1 Y1 X2 Y2]:
[Volcado de los puntos de control para la segunda transformación]

Parámetros M3 y D3:
[Volcado de la matriz M3 y el vector D3 obtenidos]

4.3 Código Utilizado para Formar el Panorama

[Insertar aquí el código completo de MATLAB usado para combinar las imágenes y generar el panorama]

4.4 Imagen Final del Panorama (pano)

[Imagen final del panorama obtenido]

Problemas observados:

[Indicar aquí los problemas o artefactos visuales encontrados en la imagen final, como desajustes, diferencias de brillo, bordes visibles, etc.]
