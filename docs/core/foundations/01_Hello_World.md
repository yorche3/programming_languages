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
| Realizar un programa básico para introducirse en la programación. | Create a basic program to introduce yourself in programming. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto de nombre `helloworld` cuyo contenido sea un solo archivo (`helloworld.ext` / `HelloWorld.ext`) que imprima "Hello, World! from {Nombre del Lenguaje}!" en la consola y finalice. | Create a project named `helloworld` with a single file (`helloworld.ext` or `HelloWorld.ext`) that prints "Hello, World! from {Language Name}!" to the console and ends. |

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
- [ ] **ES:** El archivo fuente sigue la convención de nombre del lenguaje (`helloworld.ext` o `HelloWorld.ext`, donde `.ext` es la extensión propia del lenguaje).  
      **EN:** The source file follows the language's naming convention (`helloworld.ext` or `HelloWorld.ext`, where `.ext` is the language-specific extension).

---

## 💡 Ejemplo / Example

### Pseudocódigo / Pseudocode

```pseudocode
show "Hello, World! from Pseudocode!"
```

### Python

```python
# helloworld.py
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
                ├── helloworld.ext    # Código fuente / Source code (.ext = extensión del lenguaje / language extension)
                └── README.md         # Instrucciones específicas (opcional)
```

---

## ▶️ Siguiente / Next

👉 Sigue con [`02_Hello_User.md`](02_Hello_User.md) — Agregar interacción con el usuario (nombre, entrada/salida).  
👉 Continue with [`02_Hello_User.md`](02_Hello_User.md) — Add user interaction (name, input/output).

---

*[← Volver al ROADMAP](../../ROADMAP.md) | [↑ Inicio](../../index.md)*