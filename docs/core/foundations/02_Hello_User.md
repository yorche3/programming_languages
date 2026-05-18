---
layout: default
title: 02 — Hello User
description: Segunda especificación / Second specification — Interacción con el usuario
nav_order: 2
parent: Fundamentos / Foundations
grand_parent: Core
---

# 🚀 02 — Hello User

> [← Volver a 01_Hello_World](01_Hello_World.md)  
> [↑ Volver a inicio / Back to home](../../index.md)

---

## 🎯 Objetivo / Objective

| Español | English |
|---------|---------|
| Explorar la interacción básica con el usuario: solicitar entrada, almacenarla en una variable y mostrar un mensaje personalizado. | Explore basic user interaction: ask for input, store it in a variable, and display a personalized message. |

---

## 📝 Especificación / Specification

### 📋 Enunciado / Problem Statement

| Español | English |
| Crear un proyecto de nombre `hellouser` cuyo contenido sea un solo archivo (`hellouser.ext` / `HelloUser.ext`) que solicite al usuario su nombre, lo almacene en una variable, y luego muestre "Hello, {nombre}!" en la consola. | Create a project named `hellouser` with a single file (`hellouser.ext` or `HelloUser.ext`) that asks the user for their name, stores it in a variable, and then prints "Hello, {name}!" to the console. |

### Entrada / Input

Una línea de texto ingresada por el usuario (su nombre).  
*A single line of text entered by the user (their name).*

### Salida esperada / Expected Output

```text
What is your name? John
Hello, John!
```

> **ES:** Reemplaza "John" por cualquier nombre que ingrese el usuario.  
> **EN:** Replace "John" with whatever name the user enters.

## ✅ Criterios de aceptación / Acceptance Criteria

- [ ] **ES:** El programa se ejecuta sin errores y muestra el mensaje exacto.  
      **EN:** The program runs without errors and displays the exact message.
- [ ] **ES:** Usa únicamente la biblioteca estándar del lenguaje (sin dependencias externas).  
      **EN:** Uses only the language's standard library (no external dependencies).
- [ ] **ES:** El archivo fuente sigue la convención de nombre del lenguaje (`hellouser.ext` o `HelloUser.ext`, donde `.ext` es la extensión propia del lenguaje).  
      **EN:** The source file follows the language's naming convention (`hellouser.ext` or `HelloUser.ext`, where `.ext` is the language-specific extension).

---

## 💡 Ejemplo / Example

### Pseudocódigo / Pseudocode

```pseudocode
ask "What is your name?" and store answer/input in variable 'name'
show "Hello, " + name + "!"
```

### Python

```python
# hellouser.py
name = input("What is your name? ")
print("Hello, " + name + "!")
```

### Java

```java
// HelloUser.java
import java.util.Scanner;

public class HelloUser {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("What is your name? ");
        String name = scanner.nextLine();
        System.out.println("Hello, " + name + "!");
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
            └── hello_user/
                ├── hellouser.ext    # Código fuente / Source code (.ext = extensión del lenguaje / language extension)
                └── README.md        # Instrucciones específicas (opcional)
```

---

## ▶️ Siguiente / Next

👉 Sigue con el siguiente documento numerado de la serie — Pruebas unitarias / unit tests.  
👉 Continue with the next numbered document in the series — Unit tests.

---

*[← Volver a 01_Hello_World](01_Hello_World.md) | [↑ Inicio](../../index.md)*