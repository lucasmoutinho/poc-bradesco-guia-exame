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

        # Avalia preço de bundle
        bundle_contracts = Contract.where(provider: @guide.provider, contract_type: "Bundle").first()
        ffs_contracts = Contract.where(provider: @guide.provider, contract_type: "FFS").first()
        lista_precos = []
        unless bundle_contracts.nil?
            bundle_prices = Price.where(id: bundle_contracts.prices)
            for pri in bundle_prices do
                bundle_codes = pri.code.split(",")
                if (bundle_codes - procedures_codes).empty?
                    bundle_price = pri.value.to_i
                    other_procedures = (procedures_codes - bundle_codes)
                    ffs_prices = Price.where(id: ffs_contracts.prices)
                    for pr in other_procedures do
                        price = 0
                        for ffs in ffs_prices do
                            if ffs.code.include? pr
                                price = ffs.value.to_i
                            end 
                        end
                        bundle_price = bundle_price + price
                    end
                else
                    bundle_price = -1
                end
                if bundle_price != -1
                    lista_precos.push(["bundle", bundle_price])
                end
            end
        end


        # Avalia preço de Captation
        captation_contracts = Contract.where(provider: @guide.provider, contract_type: "Captation").first()
        unless captation_contracts.nil?
            captation_prices = Price.where(id: captation_contracts.prices)
            ffs_prices = Price.where(id: ffs_contracts.prices)
            quantidade_captation = 2

            captation_price = -1
            for pr in procedures_codes do
                for cap in captation_prices do
                    if cap.code.include? pr
                        captation_price = 0
                    end 
                end
            end

            if captation_price != -1
                ordered_pr_codes = []
                codes_1 = []
                codes_2 = []
                codes_3 = []
                for pr in procedures_codes do
                    if pr.chr == '1'
                        codes_1.push(pr)
                    end
                    if pr.chr == '4'
                        codes_2.push(pr)
                    end
                    if pr.chr == '3'
                        codes_3.push(pr)
                    end
                end
                for pr in codes_3 do
                    ordered_pr_codes.push(pr)
                end
                for pr in codes_2 do
                    ordered_pr_codes.push(pr)
                end
                for pr in codes_1 do
                    ordered_pr_codes.push(pr)
                end

                for pr in ordered_pr_codes do
                    price = 0
                    if quantidade_captation > 0
                        for cap in captation_prices do
                            if cap.code.include? pr
                                puts "CODIGO: " + pr
                                price = cap.value.to_i
                            end 
                        end
                        if price == 0
                            for ffs in ffs_prices do
                                if ffs.code.include? pr
                                    price = ffs.value.to_i
                                end 
                            end
                        else
                            quantidade_captation = quantidade_captation - 1
                        end
                    else
                        for ffs in ffs_prices do
                            if ffs.code.include? pr
                                price = ffs.value.to_i
                            end 
                        end
                    end
                    captation_price = captation_price + price
                end
                lista_precos.push(["captation", captation_price])
            end
        end

        # Avalia preço de FFS
        ffs_price = 0
        for pr in procedures_codes do
            price = 0
            for ffs in ffs_prices do
                if ffs.code.include? pr
                    price = ffs.value.to_i
                end 
            end
            ffs_price = ffs_price + price
        end
        lista_precos.push(["ffs", ffs_price])

        @lista_precos = lista_precos
    end

    def update_guide_local
        puts "GUIAAAAAAA"
        puts @lista_precos
        puts "FIM"
        @guide.update(value:'R$ 100,00', detail: 'Teste: ' + @lista_precos.to_s)
    end

    def update_guide_api
        value, detail = self.call_sas_api
        @guide.update(value:value, detail:detail)
    end

    def call_sas_api
        # parâmetros de entrada SAS
        baseUrl = "https://server.demo.sas.com"
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
            urlSID = baseUrl + "/microanalyticScore/modules/modeloremuneracaoguiaexame/steps/execute"
            headersSID = {
                "Content-Type": "application/json;charset=utf-8",
                "Accept": "application/json",
                "Authorization": "Bearer " + tk
            }
            json_entrada = {
                "codigo_prestador": @guide.provider.code,
                "lista_procedimentos": @procedures_codes,
                "repeticao_exame": @repeticao_exame,
                "lista_precos": @lista_precos
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
                if output["name"] == "lista_valores_por_mr"
                    detail = "Opções: " + output["value"]
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
