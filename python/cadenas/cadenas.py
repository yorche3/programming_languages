def hola():
    '''
    -regresa una cadena con un saludo
    '''
    return 'Hola'

def palindromo(word):
    '''
    verifica si la palabra @param(word) es palindromo
    -regresa true si lo es, false en otro caso
    '''
    i = 0
    f = len(word)-1
    while i < f:
        if word[i] != word[f]:
            return False
        i+=1
        f-=1
    return True

def repeticiones(ch, word):
    '''
    @param ch carater a buscar
    @param word cadena sobre la que se buscará
    cuenta el número de repeticiones de ch en la cadena word
    -regresa el número de repeticiones
    '''
    c=0
    for w in word:
        if w == ch:
            c+=1
    return c

def invertir(word):
    l = len(word)
    j = l-1
    inv_str = ''
    for k in range(0, l):
        inv_str += str(word[j])
        j-=1
    return inv_str

print(hola())
word = input('Escribe una palabra   ')
print('Es palindromo ', str(palindromo(word)))
ch = input('Caracter a buscar  ')[0]
print('numero de repeticiones : ', repeticiones(ch, word))
print('palabra invertida  ', invertir(word))
