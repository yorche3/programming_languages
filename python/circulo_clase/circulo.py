import math

class Punto:
    """Clase auxiliar para el centro del circulo"""
    
    def __init__(self, x, y):
        self.x = x
        self.y = y

class Circulo:
    """ Clase que usaremos para representar un circulo """
    
    def __init__(self, p, r):
        self.centro = p
        self.radio = r

    def area(self):
        return self.radio * self.radio * math.pi

def isInt(message):
    while True:
        try:
            user_input = int(input(message))
        except ValueError:
            print("Debe ser un entero.")
            continue
        else:
            return user_input

def isFloat(message):
    while True:
        try:
            user_input = float(input(message))
        except ValueError:
            print("Debe ser un entero.")
            continue
        else:
            return user_input


if __name__ == '__main__':
    x = isInt('Valor de x:   ')
    y = isInt('Valor de y:   ')
    r = isFloat('Valor del radio:   ')
    p = Punto(x,y)
    c = Circulo(p, r)
    print(c.area())
