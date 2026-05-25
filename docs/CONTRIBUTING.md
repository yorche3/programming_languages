# Contributing

## Conventional Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/).

```text
tipo(alcance): asunto en imperativo, menos de 50 caracteres

Cuerpo del mensaje donde explicas el qué y el por qué del cambio,
no el cómo, ya que eso se ve en el código. Cada línea debe tener
un máximo de 72 caracteres para verse bien en cualquier terminal.

Footer opcional para referenciar incidencias o cambios importantes (BREAKING CHANGE).
```

### Tipos permitidos

| Tipo       | Significado                                      |
|------------|--------------------------------------------------|
| `feat`     | Nueva funcionalidad                              |
| `fix`      | Corrección de un error                           |
| `docs`     | Cambios en la documentación                      |
| `style`    | Formato, espacios, puntos y comas, etc.          |
| `refactor` | Reescribir o mejorar código existente sin cambiar comportamiento |
| `perf`     | Mejora de rendimiento                            |
| `test`     | Añadir o corregir pruebas                        |
| `chore`    | Mantenimiento, dependencias, configuración       |

### Ejemplos

```bash
git commit -m "docs: updated documentation to pages format" -m "Updated doc files to clarify monorepo content"
git commit -m "refactor(parser): simplify token validation logic"
git commit -m "fix(sastada): handle empty file paths gracefully"
```
