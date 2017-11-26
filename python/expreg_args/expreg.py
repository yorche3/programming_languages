'''
_author   Jorge Eduardo Ascencio Espíndola
_version  v0.1
'''
import re, sys

def match(word):
    '''
    * Verifica que la cadena word cumpla con la expresión regular
    *
    * @param word   cadena a verificar
    *
    * @return True si cumple, False en otro caso
    '''
    expreg = re.compile('^[A-Z]([a-z]|ñ){1,5}$') # compila la expresión regular
    if expreg.match(word): # verifica que haya un match (regresa un objeto si cumple, None si no cumple)
        return True
    return False

if len(sys.argv) != 2:
    print('Recibe un solo argumento\nDebe ser de la forma [A-Z]([a-z]|ñ){1,5}')
else:
    if match(sys.argv[1]):
        print("Felicidades la cadena es valida!")
    else:
        print('La cadena no es correcta')
print('Cerrando programa ...')
