# 🗺️ Práctica: Calibración de un Mapa Digital

**Autores:**  
- Hernández Sánchez, Inés  
- Bravo Collado, Luis  

---

## 📘 Nota importante sobre las figuras

> Para evitar exceder los límites de tamaño en la entrega de la práctica, se recomienda **guardar las figuras como archivos JPG** (`File > Save As`) en lugar de usar la función `Edit > Copy Figure`.  
> De esta forma se generan imágenes más ligeras y se evita incrustar datos innecesarios en el documento final.

---

## 🧩 1. Introducción

### 1.1 Identificación de Matrices y Vectores del Ajuste

El objetivo del ajuste por mínimos cuadrados es resolver un sistema de la forma:

```
H * C = B
```

Donde:

- **H** → Matriz de diseño  
- **C** → Vector de coeficientes (parámetros de transformación)  
- **B** → Vector de datos conocidos (coordenadas geográficas)

#### 📐 Matriz H

Matriz de diseño basada en las coordenadas de los píxeles de los puntos de control (Xk, Yk):

```
H = [Xk, Yk, 1]
```

#### ⚙️ Vectores de coeficientes

Cada coordenada (Este, Norte) tiene su propio conjunto de coeficientes:

```
Ce = [m11, m12, d1]'
Cn = [m21, m22, d2]'
```

#### 🌍 Vectores de datos

```
Be = [Ek]'
Bn = [Nk]'
```

#### 💡 Elementos comunes

La matriz **H** es común para ambos ajustes (Este y Norte), ya que depende exclusivamente de las coordenadas de píxeles (Xk, Yk).

---

## 💻 2. Código del Ajuste

### 2.1 Comprobación inicial del número de puntos

La condición:

```matlab
if (N < 3)
```

es necesaria porque se requieren **al menos 3 puntos de control** para determinar los **6 parámetros** de la transformación afín (3 para cada coordenada).  
Con menos de 3 puntos, el sistema es **indeterminado**.

---

### 2.2 Código de la función `ajuste.m`

```matlab
function [M, D] = ajuste(Xk, Yk, Ek, Nk)
% Entrada:
% Xk, Yk : coordenadas de píxeles de los puntos de control
% Ek, Nk : coordenadas geográficas de los puntos de control
%
% Salida:
% M : matriz 2x2 de transformación
% D : vector 2x1 de desplazamiento

% Valores por defecto
D = [0; 0];
M = [1 0; 0 1];

N = length(Xk);
if (N < 3)
    disp('Se necesitan al menos 3 puntos de control.');
    return;
end

% Construcción de la matriz H
H = [Xk, Yk, ones(N,1)];

% Ajuste para coordenadas Este y Norte
coefs_E = H \ Ek;  res_E = Ek - H * coefs_E;
coefs_N = H \ Nk;  res_N = Nk - H * coefs_N;

% Matriz de transformación y vector de desplazamiento
M = [coefs_E(1), coefs_E(2); coefs_N(1), coefs_N(2)];
D = [coefs_E(3); coefs_N(3)];

% Mostrar residuos
fprintf('Residuos Coordenada Este (m): %.1f\t', res_E); fprintf('\n');
fprintf('Residuos Coordenada Norte (m): %.1f\t', res_N); fprintf('\n');
fprintf('Media residuos E: %.4e\n', mean(res_E));
fprintf('Media residuos N: %.4e\n', mean(res_N));
end
```

---

### 2.3 Resultados del Ajuste

**Matriz M:**

```
M =
[  1.9998  -0.0529
   -0.0511  -2.0003 ]
```

**Vector D:**

```
D =
[ 304470
 -0.0000 ]
```

---

### 2.4 Residuos del Ajuste

| Coordenada | Residuos (m) |
|-------------|--------------|
| Este (E)    | -1.0, -4.0, 2.3, 5.2, -4.9, -0.8, -0.7, 3.9 |
| Norte (N)   | 3.9, 0.2, 1.6, 0.7, -5.8, 3.3, -0.6, -3.3 |

**Medias:**

```
mean(res_E) = -4.3656e-11
mean(res_N) = -8.1491e-10
```

📏 **Conclusión:**  
No es posible obtener una media menor: el método de mínimos cuadrados garantiza la **solución óptima** que minimiza la suma de los cuadrados de los residuos.

---

### 2.5 Interpretación de la Matriz M

- M(1,1) ≈ 2 → escala de 2 metros/píxel (eje Este).  
- M(2,2) ≈ -2 → escala negativa (eje Norte).

🧭 **Signo negativo:**  
El eje Y de la imagen crece hacia abajo, mientras que el eje Norte del mapa crece hacia arriba.  
Por tanto, al aumentar Y, la coordenada N disminuye → escala negativa.

---

### 2.6 Coordenadas GPS del Refugio Elola

Obtenidas mediante la aplicación `map` al posicionar el cursor sobre el refugio.

📷 *(Insertar imagen con el cursor sobre el Refugio Elola y sus coordenadas)*

---

## 🔁 3. Transformación Inversa

### 3.1 Deducción de M' y D'

```
M' = inv(M)
D' = -inv(M) * D
```

---

### 3.2 Matriz M' y Vector D'

📊 *(Insertar aquí los valores calculados de M' y D')*

---

### 3.3 Código de la Transformación Inversa y Superposición

📜 *(Insertar el código MATLAB que calcula la transformación inversa y superpone la ruta del GPS sobre el mapa calibrado)*

📷 *(Insertar imagen del mapa calibrado con la ruta GPS superpuesta)*

---

## 🖼️ 4. Creación de Panoramas (30%)

### 4.1 Transformación `img2 → img1`

**Puntos de control:**
```
[X1 Y1 X2 Y2] = [...valores...]
```

**Parámetros obtenidos:**
```
M1 = [...]
D1 = [...]
```

---

### 4.2 Transformación `img2 → img3`

**Puntos de control:**
```
[X1 Y1 X2 Y2] = [...valores...]
```

**Parámetros obtenidos:**
```
M3 = [...]
D3 = [...]
```

---

### 4.3 Código utilizado para formar el panorama

📜 *(Insertar aquí el código MATLAB completo que combina las imágenes y genera el panorama)*

---

### 4.4 Imagen final del panorama

📷 *(Insertar la imagen final del panorama obtenido)*

---

### 🚧 Problemas observados

- Desajustes entre bordes de imágenes  
- Diferencias de brillo o color  
- Artefactos visuales en zonas con pocos puntos de control

---

## 🧠 Conclusiones

- El método de mínimos cuadrados proporciona la **mejor aproximación posible** entre coordenadas de píxeles y coordenadas geográficas.  
- La matriz de transformación refleja la **escala y orientación** del sistema.  
- La calibración permite superponer información GPS real sobre el mapa digital con alta precisión.

---

### 📅 Fecha de entrega
Octubre de 2025
