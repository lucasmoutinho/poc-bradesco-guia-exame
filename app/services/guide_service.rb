require 'httparty'
require 'json'
require 'time'

class GuideService
    def initialize(guide)
        @guide = guide
        pro = Procedure.where(id: @guide.procedures)
        procedures_codes = []
        for pr in pro do
            procedures_codes.push(pr.code)
        end
        @procedures_codes = procedures_codes
        repeticao = Guide.where(patient: @guide.patient, provider: @guide.provider).length()
        @repeticao_exame = repeticao
    end

    def update_guide_local
        puts "GUIAAAAAAA"
        puts @procedures_codes
        puts "FIM"
        @guide.update(value:'R$ 100,00', detail: 'Teste')
    end

    def update_guide_api
        value, detail = self.call_sas_api
        @guide.update(value:value, detail:detail)
    end

    def call_sas_api
        # parâmetros de entrada SAS
        baseUrl = "http://10.96.16.122/"
        username = "sasdemo"
        password = "Orion123"

        # Cria uma primeira chamada ao SID para gerar um token de acesso
        urlToken3 = baseUrl + "/SASLogon/oauth/token"
        headers3 = {
            "Content-Type": "application/x-www-form-urlencoded",
        }
        data3 = {
            "grant_type": "password",
            "username": username,
            "password": password
        }
        authToken = {username: "sas.cli", password: ""}

        token_response = HTTParty.post(urlToken3, :headers => headers3, :body => data3, :verify => false, :basic_auth => authToken)
        puts "RESPOSTA TOKEN -------------"
        puts token_response

        # Faz a requisição ao SAS com o Token recebido
        if token_response.include?("access_token")
            tk = token_response["access_token"]
            urlSID = baseUrl + "/microanalyticScore/modules/poc_sas_valor_guia/steps/execute"
            headersSID = {
                "Content-Type": "application/json;charset=utf-8",
                "Accept": "application/json",
                "Authorization": "Bearer " + tk
            }
            json_entrada = {
                "codigo_prestador": @guide.provider.code,
                "lista_procedimentos": @procedures_codes,
                "repeticao_exame": @repeticao_exame
            }
            bodySID = {
                "inputs":
                    [
                        {
                            "name": "json_entrada_",
                            "value": JSON.generate(json_entrada)
                        }
                    ]
            }

            resposta = HTTParty.post(urlSID, :body => JSON.generate(bodySID), :headers => headersSID, :verify => false)
            puts "RESPOSTA FLUXO ---------------"
            puts resposta
            puts JSON.parse(resposta)["outputs"]

            # Trabalha nas respostas recebidas
            value = ''
            detail = ''
            for output in JSON.parse(resposta)["outputs"] do
                if output["name"] == "valor_guia"
                    value = output["value"]
                end
                if output["name"] == "detalhe_extrato"
                    detail = output["value"]
                end
            end

            if value.nil?
                detail = 'Limite de procedimentos excedido para a guia de exame'
            end
        else
            puts "DEU RUIM -----------------"
            # Trabalha nas respostas recebidas
            value = ''
            detail = 'Erro na comunicação com a API'
        end

        return value, detail
    end

    def simulate_json
        ae_rand= "AE" + Time.now.utc.to_formatted_s(:number) + rand(17..999999).to_s 
        sc_rand= "SC" + Time.now.utc.to_formatted_s(:number) + rand(17..999999).to_s
        bodyAlert = {
            "alertingEvents": [{
                "alertingEventId":""+ae_rand+"",
                "actionableEntityId": ""+ae_rand+"",
                "actionableEntityType": "autorizacao_senha",
                "alertOriginCd": "SID",
                "alertTypeCd": "AUTORIZACAO",
                "domainId": "mesa_prev_sky",
                "score": 1000,
                "recQueueId": "prev_pf_operation_queue"
            }],
            "scenarioFiredEvents": [{
                "alertingEventId": ""+ae_rand+"",
                "scenarioFiredEventId": ""+sc_rand+"",
                "scenarioId": "nomeRegra", #validar
                "scenarioName": "resposta", #validar
                "scenarioDeion": "resposta", #validar
                "scenarioOriginCd": "SID",
                "displayFlg": "true",
                "displayTypeCd": "text",
                "score": 1000
            }],
            "enrichment": [{
                "guia": @solicitation.procedure.guide,
                "anexo_exame": self.converter_boolean_int(@solicitation.attachment_exam_guide),
                "anexo_laudo": self.converter_boolean_int(@solicitation.attachment_medical_report),
                "situacao_financeira_cartao": @solicitation.beneficiary.finantial_status,
                "situacao_cadastro_cartao": @solicitation.beneficiary.register_status,
                "situacao_cadastro_referenciado": @solicitation.referenced.register_status,
                "nome_beneficiario": @solicitation.beneficiary.name,
                "cartao_beneficiario": @solicitation.beneficiary.card.to_s,
                "codigo_procedimento": @solicitation.procedure.code.to_s,
                "descricao_procedimento": @solicitation.procedure.description,
                "codigo_referenciado": @solicitation.referenced.code.to_s,
                "cnpj_referenciado": @solicitation.referenced.cnpj_code.to_s,
                "nome_referenciado": @solicitation.referenced.name,
                "tabela_procedimento": @solicitation.procedure.table_type,
                "liberacao_automatica": @solicitation.automatic_release,
                "analise_adm": @solicitation.adm_analysis,
                "analise_medica": @solicitation.medic_analysis,
                "resultado_solicitacao": @solicitation.result
            }]
        }
        puts bodyAlert
    end

    def converter_boolean_int(b)
        number = 0
        if b
            number = 1
        end
        return number
    end

    def converter_int_boolean(i)
        bool = false
        if i == 1.0
            bool = true
        end
        return bool
    end
end
