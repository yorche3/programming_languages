package unit_testing

import "testing"

func TestAddition(t *testing.T){
  sum := addition(1,2)
  if sum != 3 {
    t.Error("Valor esperado: 3, valor regresado: ", sum)
  }
}

func TestMultiply(t *testing.T){
  mult := multiply(1,2)
  if mult != 2 {
    t.Errorf("Valor esperado: 2, valor regresado: ", mult)
  }
}