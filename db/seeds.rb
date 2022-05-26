# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Provider.create(code:'243.412.345-79', name:'Dr. Joãozinho', description: 'Especialista em Cardiologia')
Provider.create(code:'60.033.172/0001-93', name:'Hospital Santa Lúcia', description: 'Especialista em análises clínicas')
Provider.create(code:'08.804.534/0001-82', name:'Hospital Brasília', description: 'Especialista em cirurgia oncológica')

Patient.create(cpf:'044.123.791-67', name:'Lucas Moutinho')
Patient.create(cpf:'929.295.365-60', name:'Maria Letícia')

Procedure.create(code:'10101012', name:'CONSULTA EM CONSULTORIO (NO HORARIO NORMAL OU PRE ESTABELECIDO)', profile:'PERFIL 1 - BÁSICO')
Procedure.create(code:'10101039', name:'CONSULTA EM PRONTO SOCORRO', profile:'PERFIL 1 - BÁSICO')
Procedure.create(code:'10102019', name:'VISITA HOSPITALAR (PACIENTE INTERNADO)', profile:'PERFIL 1 - BÁSICO')
Procedure.create(code:'40103170', name:'EEG DE ROTINA', profile:'PERFIL 2 - INTERMEDIÁRIO')
Procedure.create(code:'40103196', name:'EEGQ QUANTITATIVO', profile:'PERFIL 2 - INTERMEDIÁRIO')
Procedure.create(code:'40103234', name:'ELETRENCEFALOGRAMA EM VIGILIA E SONO ESPONTANEO OU INDUZIDO', profile:'PERFIL 2 - INTERMEDIÁRIO')
Procedure.create(code:'30101123', name:'CIRURGIA MICROGRAFICA DE MOHS', profile:'PERFIL 3 - AVANÇADO')
Procedure.create(code:'30101239', name:'CURATIVO ESPECIAL SOB ANESTESIA - POR UNIDADE TOPOGRAFICA UT', profile:'PERFIL 3 - AVANÇADO')
Procedure.create(code:'30101280', name:'DESDOBRAMENTO CIRURGICO - POR UNIDADE TOPOGRAFICA UT', profile:'PERFIL 3 - AVANÇADO')
