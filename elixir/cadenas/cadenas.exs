defmodule Cadenas do
  @moduledoc """
  Módulo para saber cómo tratar con cadenas en elixir

    - author:   Jorge Eduardo Ascencio Espíndola
    - version:  v1.0
  """

  @doc """
  Imprime un mensaje de bienvenida
  
  ## Return
     
     la palabra "Hola"
  """
  def hola() do
    "Hola"
  end

  @doc """
  Verifica si una palabra en palindromo

  ## Parameters

    - word: palabra a verificar.

  ## Return 

     true si es palindromo, false en otro caso
  """
  @spec is_palindromo(String.t()) :: Boolean.t()
  def is_palindromo(word) do
    if(String.length(word) > 2) do
      if(String.first(word) != String.last(word)) do
        false
      else
        is_palindromo(String.slice(word, 1..-2))
      end
    else
      String.first(word) == String.last(word)
    end
  end

  @doc """
  Cuenta el número de repeticiones de un cáracter en una cadena

  ## Parameters

    - ch: cáracter a buscar
    - word: palabra a iterar
    - count: número de repeticiones al momento

  ## Return

     El número de repeticiones en toda la palabra
  """
  @spec repeticiones(String.t(), String.t(), Integer.t()) :: Integer.t()
  def repeticiones(ch, word, count) do
    if(String.length(word) > 0) do
      if(String.first(word) == ch) do
        repeticiones(ch, String.slice(word, 1..-1), count + 1)
      else
        repeticiones(ch, String.slice(word,1..-1), count)
      end
    else
      count
    end
  end

  @doc """
  Invierte una cadena

  ## Parameters

    - word: cadena a invertir

  ## Return
     
     La cadena invertida
  """
  @spec reversa(String.t()) :: String.t()
  def reversa(word) do
    String.reverse(word)
  end
end

IO.puts Cadenas.hola()
word = IO.gets "Escribe una palabra   "
word = String.trim(word)
IO.puts "Es palindromo : " <> to_string(Cadenas.is_palindromo(word))
ch = IO.gets "cáracter a buscar   "
ch = String.slice(String.trim(ch), 0..1)
IO.puts "repeticiones : " <> to_string(Cadenas.repeticiones(ch, word, 0))