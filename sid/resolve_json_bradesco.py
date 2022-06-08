import json


''' List all output parameters as comma-separated values in the "Output:" docString. Do not specify "None" if there is no output parameter. ''' # noqa
def execute (json_entrada):
    'Output:codigo_prestador,lista_procedimentos,repeticao_exame,lista_precos'
    j = json.loads(json_entrada)
    codigo_prestador = j["codigo_prestador"]
    lista_procedimentos = j["lista_procedimentos"]
    repeticao_exame = j["repeticao_exame"]
    lista_precos = json.dumps(j["lista_precos"])

    return codigo_prestador,lista_procedimentos,repeticao_exame,lista_precos
