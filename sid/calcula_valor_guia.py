import json

class Guia:
    def __init__(self, modelo_remuneracao, lista_procedimentos, repeticao_exame) -> None:
        self._modelo_remuneracao = modelo_remuneracao
        self._lista_procedimentos = json.loads(lista_procedimentos)
        self._repeticao_exame = repeticao_exame

        # lista de procedimentos de cata categoria
        self._procedimentos_perfil1 = ['10101012', '10101039', '10102019']
        self._procedimentos_perfil2 = ['40103170', '40103196', '40103234']
        self._procedimentos_pprede = ['10101039', '40103196', '30101239']
        self._procedimentos_capitation = ['10101039', '40103196', '30101239', '10102019', '40103234', '30101280']

    def calcula_total(self):
        valor_total = 0
        detalhe_extrato = ''
        limite_capitation = 3
        capitation_encontrado = False
        print(self._lista_procedimentos)
        for procedimento in self._lista_procedimentos:
            print(procedimento)
            if(self._modelo_remuneracao == 'FFS'):
                if procedimento in self._procedimentos_perfil1:
                    valor_total = valor_total + 10
                    detalhe_extrato = detalhe_extrato + procedimento + ': valor padrão (R$ 10,00)\n'
                elif procedimento in self._procedimentos_perfil2:
                    valor_total = valor_total + 20
                    detalhe_extrato = detalhe_extrato + procedimento + ': valor padrão (R$ 20,00)\n'
                else:
                    valor_total = valor_total + 30
                    detalhe_extrato = detalhe_extrato + procedimento + ': valor padrão (R$ 30,00)\n'
            elif(self._modelo_remuneracao == 'FFS_PP_REDE'):
                if procedimento in self._procedimentos_pprede:
                    valor_total = valor_total + 5
                    detalhe_extrato = detalhe_extrato + procedimento + ': valor PPREDE (R$ 5,00)\n'
                elif procedimento in self._procedimentos_perfil1:
                    valor_total = valor_total + 10
                    detalhe_extrato = detalhe_extrato + procedimento + ': valor padrão (R$ 10,00) - fora do pacote PPREDE\n'
                elif procedimento in self._procedimentos_perfil2:
                    valor_total = valor_total + 20
                    detalhe_extrato = detalhe_extrato + procedimento + ': valor padrão (R$ 20,00) - fora do pacote PPREDE\n'
                else:
                    valor_total = valor_total + 30
                    detalhe_extrato = detalhe_extrato + procedimento + ': valor padrão (R$ 30,00) - fora do pacote PPREDE\n'
            elif(self._modelo_remuneracao == 'CAPITATION'):
                if(procedimento in self._procedimentos_capitation and limite_capitation > 0):
                    limite_capitation = limite_capitation - 1
                    capitation_encontrado = True
                elif procedimento in self._procedimentos_perfil1:
                    valor_total = valor_total + 10
                    if(limite_capitation > 0):
                        detalhe_extrato = detalhe_extrato + procedimento + ': valor padrão (R$ 10,00)\n'
                    else:
                        detalhe_extrato = detalhe_extrato + procedimento + ': valor padrão (R$ 10,00) - Limite do Pacote excedido\n'
                elif procedimento in self._procedimentos_perfil2:
                    valor_total = valor_total + 20
                    if(limite_capitation > 0):
                        detalhe_extrato = detalhe_extrato + procedimento + ': valor padrão (R$ 20,00)\n'
                    else:
                        detalhe_extrato = detalhe_extrato + procedimento + ': valor padrão (R$ 20,00) - Limite do Pacote excedido\n'
                else:
                    valor_total = valor_total + 30
                    if(limite_capitation > 0):
                        detalhe_extrato = detalhe_extrato + procedimento + ': valor padrão (R$ 30,00)\n'
                    else:
                        detalhe_extrato = detalhe_extrato + procedimento + ': valor padrão (R$ 30,00) - Limite do Pacote excedido\n'
        
        if(self._modelo_remuneracao == 'CAPITATION' and capitation_encontrado):
            valor_total = valor_total + 25
            detalhe_extrato = detalhe_extrato + 'Valor Mensal Capitation: R$ 25,00'
        
        if(self._repeticao_exame >= 3):
            valor_total = valor_total * 1.2
            detalhe_extrato = detalhe_extrato + 'Agravo de 20% no valor total devido a ' + str(self._repeticao_exame) + ' repetições da guia de exame'
        else:
            valor_total = valor_total * 1.0
        
        valor_guia = 'R$ ' + '%.2f' % valor_total
        valor_guia = valor_guia.replace(".", ",")
        return valor_guia, detalhe_extrato




''' List all output parameters as comma-separated values in the "Output:" docString. Do not specify "None" if there is no output parameter. ''' # noqa
def execute (modelo_remuneracao, lista_procedimentos, repeticao_exame): # noqa
    'Output: valor_guia, detalhe_extrato'
    g = Guia(modelo_remuneracao=modelo_remuneracao, lista_procedimentos=lista_procedimentos, repeticao_exame=repeticao_exame)
    valor_guia, detalhe_extrato = g.calcula_total()
    return valor_guia, detalhe_extrato

print(execute("CAPITATION", json.dumps(["30101280", "30101239", "30101123", "40103234", "40103196", "40103170", "10102019", "10101039", "10101012"]), 4.0))