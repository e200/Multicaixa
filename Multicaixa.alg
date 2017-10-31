Algoritmo "Multicaixa"

Var

utActual : inteiro
saldoActual : vetor[0..2] de real
util : vetor[0..2, 0..2] de caracter

logs : vetor[0..20, 0..3] de caracter
lPos : inteiro

limiteDiario : vetor[0..2] de real

funcao faturaUsada(nFactura : caracter) : logico

     var
     
     i : inteiro
     foiUsada : logico
     
     inicio
     
     para i de 0 ate lPos faca
          se (logs[i, 2] = nFactura) entao
               foiUsada <- verdadeiro
          fimse
     fimpara
     
     retorne foiUsada

fimfuncao

procedimento extrato()

     var i, j, k : inteiro

     inicio
     
     limpatela
     
     escreval("EXTRATO")
     
     escreval("")
     
     escreva("Actividade     ")
     escreva("Destino        ")
     escreva("Nº factura     ")
     escreval("Valor          ")
     
     para i de 0 ate (lPos - 1) faca
          para j de 0 ate 3 faca
              se (j <> 3) entao
                   para k de 0 ate (15 - compr(logs[i, j])) faca
                        se (k = 0) entao
                             escreva(logs[i, j])
                        senao
                             escreva(" ")
                        fimse
                   fimpara
              senao
                   escreval(logs[i, j], "kz")
              fimse
          fimpara
     fimpara
     
     voltarMenu()

fimprocedimento

procedimento logger(modulo, item, nFatura, valor : caracter)

     inicio

     logs[lPos, 0] <- modulo
     logs[lPos, 1] <- item
     logs[lPos, 2] <- nFatura
     logs[lPos, 3] <- valor

     lPos <- lPos + 1

fimprocedimento

procedimento fazerPagamento(item : caracter)

     var

     v : real
     nFactura : caracter
     itsSomethingWrongAbove : logico

     inicio
             
     limpatela

     escreval("PAGAMENTOS ", item)

     espaco()

     escreval("Número da factura:")
     leia(nFactura)
          
     se ((compr(nFactura) < 4) ou faturaUsada(nFactura)) entao
          limpatela
          
          escreval("O número da fatura fornecido não é válido")
          
          voltarMenu()

          itsSomethingWrongAbove <- verdadeiro
     fimse

     se (nao(itsSomethingWrongAbove)) entao
     
          escreval("Valor da factura:")
          leia(v)
               
          se (v <= 0) entao
               limpatela
               
               escreval("O valor da fatura fornecido não é válido")

               voltarMenu()
          senao
               se (login()) entao
                    se (saldoInsuficiente(v)) entao
                         limpatela

                         escreval("Saldo insuficiente")

                         voltarMenu()
                    senao
                         se (excedeuSaldoMinimo(v)) entao
                              limpatela

                              escreval("Por ordem do seu banco, não poderá efectuar este pagamento")

                              voltarMenu()
                         senao
                              limpatela

                              sub(v)

                              logger("Pagamento", item, nFactura, numpcarac(v))

                              escreval("Pagamento efectuado com sucesso")

                              voltarMenu()
                         fimse
                    fimse
               senao
                    dadosContaIncorrectos()
               fimse
          fimse
     fimse

fimprocedimento

procedimento saldo()

     var opc : inteiro

     inicio
     
     se (login()) entao
          limpatela

          escreval("SALDO")
          
          espaco()

          escreval("1. Extrato")
          escreval("2. Saldo actual")
          escreval("3. Sair")

          leia(opc)
     
          escolha (opc)
               caso 1
                    extrato()
               caso 2
                    limpatela
              
                    escreval("Saldo actual: ", saldoActual[utActual], "kz")
              
                    voltarMenu()
           fimescolha
     senao
             dadosContaIncorrectos() 
     fimse

fimprocedimento

procedimento pagamento()

     var
     
     opc : inteiro

     inicio
     
     limpatela
     
     escreval("PAGAMENTOS")
     
     espaco()
     
     escreval("1. UNITEL")
     escreval("2. MOVICEL")
     escreval("3. ZAP")
     escreval("4. DSTV")
     escreval("5. Sair")
     
     leia(opc)
     
     escolha (opc)
         caso 1
              fazerPagamento("UNITEL")
         caso 2
              fazerPagamento("MOVICEL")
         caso 3
              fazerPagamento("ZAP")
         caso 4
              fazerPagamento("DSTV")
     fimescolha

fimprocedimento

procedimento levantamento()

     var v : real

     inicio

     limpatela
     
     escreval("LEVANTAMENTO")
     
     se (login()) entao
          se (limiteDiario[utActual] = 40000) entao
               limpatela
               
               escreval("Atingiu o limite de levantamento por dia")
               
               voltarMenu()
          senao
               espaco()
               
               escreval("Quantia a levantar:")

               leia(v)
                    
               se ((limiteDiario[utActual] + v) > 40000) entao
               
                    limpatela
               
                    escreval("Só lhe é permitido levantar no máximo", 40000 - limiteDiario[utActual], "kz")
                    
                    voltarMenu()
               senao
                    espaco()

                    se (saldoInsuficiente(v)) entao
                         limpatela

                         escreval("Saldo insuficiente")

                         voltarMenu()
                    senao
                         se (excedeuSaldoMinimo(v)) entao
                              limpatela

                              escreval("Por ordem do seu banco, não poderá levantar esta quantia")

                              voltarMenu()
                         senao
                              limpatela

                              sub(v)

                              logger("Levantamento", "", "", numpcarac(v))

                              escreval("Levantamento efectuado com sucesso")

                              espaco()

                              escreval("Por favor, retire os valores na pequena abertura do caixa")

                              voltarMenu()
                         fimse
                    fimse
               fimse
          fimse
     senao
          dadosContaIncorrectos()
     fimse

fimprocedimento

funcao login() : logico

     var

     i : inteiro
     existe : logico
     nConta, senha : caracter

     inicio
     
     escreval("")
     
     escreval("Nº conta:")
     leia(nConta)

     escreval("Senha:")
     leia(senha)

     para i de 0 ate 2 faca
          se ((util[i, 1] = nConta) e (util[i, 2] = senha)) entao
               utActual <- i
               existe <- verdadeiro
               interrompa
          fimse
     fimpara

     retorne existe

fimfuncao

procedimento deposito()

     var

     v : real
     i : inteiro
     ut : caracter
     existe : logico
     
     inicio
     
         limpatela
         
         escreval("DEPOSITO")
         
         espaco()
               
         escreval("Nº conta:")
               
         leia(ut)
               
         para i de 0 ate 2 faca
              se (util[i, 1] = ut) entao
                   existe <- verdadeiro
                   utActual <- i
                         
                   espaco()
                   
                   escreval("Proprietário: ", util[i, 0])
                         
                   espaco()
                         
                   escreval("Quantia a depositar:")

                    leia(v)

                    se (v < 100) entao

                         limpatela

                         escreval("Só são permitidos depósitos superiores a 99kz")
                    
                         voltarMenu()
                    senao
                         saldoActual[utActual] <- saldoActual[utActual] + v

                         logger("Deposito", "", "", numpcarac(v))

                         espaco()

                         escreval("Depósito efectuado com sucesso")

                         voltarMenu()
                    fimse
                   
                   interrompa
              senao
                   se ((i = 2) e (nao(existe))) entao
                        limpatela
                        
                        escreval("Não foi encontrada nenhuma conta registrada com este número")
                        
                        voltarMenu()
                   fimse
              fimse
         fimpara

fimprocedimento

funcao saldoInsuficiente(v : real) : logico

     inicio
     
     retorne (saldoActual[utActual] < v)
     
fimfuncao

funcao excedeuSaldoMinimo(v : real) : logico

     inicio
     
     retorne ((saldoActual[utActual] - v) < 1000)

fimfuncao

procedimento sub(v : real)

     inicio

     limiteDiario[utActual] <- limiteDiario[utActual] + v
     saldoActual[utActual] <- saldoActual[utActual] - v
     
fimprocedimento

procedimento dadosContaIncorrectos()

     inicio
     
     limpatela

     escreval("Os dados da conta fornecidos não estão correctos")

     voltarMenu()

fimprocedimento

procedimento iniUtil()

     inicio

     util[0,0] <- "Eduardo Van-Dúnem"
     util[0,1] <- "0"
     util[0,2] <- "0000"
     saldoActual[0] <- 0

     util[1,0] <- "Eleandro Duzentos"
     util[1,1] <- "1"
     util[1,2] <- "1111"
     saldoActual[1] <- 10000

     util[2,0] <- "D3A, Inc"
     util[2,1] <- "01"
     util[2,2] <- "0101"
     saldoActual[2] <- 100000

fimprocedimento

procedimento voltarMenu()

     var back : caracter

     inicio

     espaco()

     escreva("Prima Enter para voltar ao Menu principal")

     leia(back)

fimprocedimento

procedimento espaco()

     inicio

     escreval("")

fimprocedimento

procedimento molduraMenor()

     var opt : inteiro

     inicio

     enquanto (opt <> 5) faca
     
          limpatela

          escreval("MULTICAIXA")

          espaco()

          escreval("1. Depósito")
          escreval("2. Levantamento")
          escreval("3. Pagamento")
          escreval("4. Saldo")
          escreval("5. Sair")
     
          leia(opt)
     
          escolha(opt)
               caso 1
                    deposito()
               caso 2
                    levantamento()
               caso 3
                    pagamento()
               caso 4
                    saldo()
          fimescolha
     
     fimenquanto

fimprocedimento

Inicio

     iniUtil()
     molduraMenor()

Fimalgoritmo