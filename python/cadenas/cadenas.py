'''
 * @author   Jorge Eduardo Ascencio Espindola
 * @version  v1.0
'''

def hola():
    '''
    @return una cadena con un saludo
    '''
    return 'Hola'

def palindromo(word):
    '''
     * Verifica si la palabra @param(word) es palindromo
     *
     * @return true si lo es, false en otro caso
    '''
    i = 0
    f = len(word)-1 # tamaño de la cadena
    while i < f:
        if word[i] != word[f]:
            return False
        i+=1
        f-=1
    return True

def repeticiones(ch, word):
    '''
     * @param ch carater a buscar
     * @param word cadena sobre la que se buscará
     *
     * Cuenta el número de repeticiones de ch en la cadena word
     *
     * @return número de repeticiones
    '''
    c=0
    for w in word: # cadena como arreglo de caracteres
        if w == ch:
            c+=1 # 'autoincremento'
    return c

def invertir(word):
    '''
     * @param word cadena a invertir
     *
     * Invierte la cadena word
     * 
     * @return la cadena invertida
    '''
    l = len(word)
    j = l-1
    inv_str = ''
    for k in range(0, l):
        inv_str += str(word[j]) # concatena cadenas
        j-=1
    return inv_str

print(hola())
word = input('Escribe una palabra   ') # obtiene entrada desde consola
print('Es palindromo ', str(palindromo(word))) # imprime y concatena cadenas
ch = input('Caracter a buscar  ')[0]
print('numero de repeticiones : ', repeticiones(ch, word))
print('palabra invertida  ', invertir(word))
