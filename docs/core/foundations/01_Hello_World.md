---
layout: default
title: 01 — Hello World
description: Primera especificación / First specification — Hello World en cualquier lenguaje
nav_order: 1
parent: Fundamentos / Foundations
grand_parent: Core
---

# 🚀 01 — Hello World

> [← Volver al ROADMAP / Back to ROADMAP](../../ROADMAP.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Escribir un programa básico que imprime "Hello, World!" en la consola para familiarizarse con la sintaxis fundamental del lenguaje, la configuración del entorno de desarrollo y la ejecución del código. | Write a basic program that prints "Hello, World!" to the console to get familiar with the language's fundamental syntax, development environment setup, and code execution. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto de nombre `hello_world` cuyo contenido sea un solo archivo (`hello_world.ext` / `HelloWorld.ext`) que imprima "Hello, World! from {Nombre del Lenguaje}!" en la consola y finalice. | Create a project named `hello_world` with a single file (`hello_world.ext` or `HelloWorld.ext`) that prints "Hello, World! from {Language Name}!" to the console and ends. |

### Entrada / Input

Ninguna (no requiere entrada del usuario).  
*None (no user input required).*

### Salida esperada / Expected Output

```text
Hello, World! from Python!
```

> **ES:** Reemplaza "Python" por el nombre del lenguaje que estés implementando.  
> **EN:** Replace "Python" with the name of the language you are implementing.

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** El programa se ejecuta sin errores y muestra el mensaje exacto.  
      **EN:** The program runs without errors and displays the exact message.
- [ ] **ES:** Usa únicamente la biblioteca estándar del lenguaje (sin dependencias externas).  
      **EN:** Uses only the language's standard library (no external dependencies).
- [ ] **ES:** El archivo fuente sigue la convención de nombre del lenguaje (`hello_world.ext` o `HelloWorld.ext`, donde `.ext` es la extensión propia del lenguaje).  
      **EN:** The source file follows the language's naming convention (`hello_world.ext` or `HelloWorld.ext`, where `.ext` is the language-specific extension).

---

## 💡 Ejemplo / Example

### Pseudocódigo / Pseudocode

```pseudocode
show "Hello, World! from Pseudocode!"
```

### Python

```python
# hello_world.py
print("Hello, World! from Python!")
```

### Java

```java
// HelloWorld.java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World! from Java!");
    }
}
```

---

## 📂 Ubicación esperada / Expected Location

```text
programming_languages/
└── {language}/
    └── core/
        └── foundations/
            └── hello_world/

                ├── hello_world.ext   # Código fuente / Source code (.ext = extensión del lenguaje / language extension)
                └── README.md         # Instrucciones específicas (opcional)
```

---

## ▶️ Siguiente / Next

👉 Sigue con [`02_Hello_User.md`](02_Hello_User.md) — Agregar interacción con el usuario (nombre, entrada/salida).  
👉 Continue with [`02_Hello_User.md`](02_Hello_User.md) — Add user interaction (name, input/output).

---

*[← Volver al ROADMAP](../../ROADMAP.md) | [↑ Inicio](../../index.md)*