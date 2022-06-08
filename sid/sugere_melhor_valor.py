import json

class melhorValor:
    def __init__(self, lista_valores_por_mr) -> None:
        self._lista_valores = json.loads(lista_valores_por_mr)
    
    def maximiza_desconto(self):
        if self._lista_valores:
            menor_valor = self._lista_valores[0][1]
            modelo_escolhido = self._lista_valores[0][0]
        else:
            menor_valor = 0
            modelo_escolhido = "Nenhum modelo disponível"
        for tupla_valor in self._lista_valores:
            if tupla_valor[1] < menor_valor:
                menor_valor = tupla_valor[1]
                modelo_escolhido = tupla_valor[0]
        valor_tratado = 'R$ ' + '%.2f' % menor_valor
        valor_tratado = valor_tratado.replace(".", ",")
        valor_guia = valor_tratado + " - " + modelo_escolhido
        return valor_guia


''' List all output parameters as comma-separated values in the "Output:" docString. Do not specify "None" if there is no output parameter. ''' # noqa
def execute (lista_valores_por_mr):
    'Output:valor_guia'
    m = melhorValor(lista_valores_por_mr=lista_valores_por_mr)
    valor_guia = m.maximiza_desconto()
    return valor_guia
