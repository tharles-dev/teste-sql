/* Consulta de Vendedores: Escreva uma query para listar todos os vendedores ativos, 
 mostrando as colunas id, nome, salario. Ordene o resultado pelo nome em ordem ascendente.
*/

SELECT ID_VENDEDOR AS ID, NOME, SALARIO  FROM VENDEDORES WHERE INATIVO = FALSE ORDER BY NOME;


/* Funcionários com Salário Acima da Média: Escreva uma query para listar os funcionários que possuem um salário acima da média salarial de todos os funcionários.
A consulta deve mostrar as colunas id, nome, e salário, ordenadas pelo salário em ordem descendente.
*/

SELECT ID_VENDEDOR AS ID, NOME, SALARIO FROM VENDEDORES 
WHERE SALARIO > (SELECT AVG(SALARIO) FROM VENDEDORES) 
ORDER BY SALARIO DESC 


/* Resumo por cliente: Escreva uma query para listar todos os clientes e o valor total de pedidos já transmitidos. 
A consulta deve retornar as colunas id, razao_social, total, ordenadas pelo total em ordem descendente.
*/

SELECT
  CLI.ID_CLIENTE AS ID,
  CLI.RAZAO_SOCIAL,
  COALESCE(
    (SELECT SUM(PED.VALOR_TOTAL)
     FROM PEDIDO PED
     WHERE PED.ID_CLIENTE = CLI.ID_CLIENTE),
    0
  ) AS TOTAL
FROM CLIENTES CLI
ORDER BY TOTAL DESC;


/* Situação por pedido: Escreva uma query que retorne a situação atual de cada pedido da base. A consulta deve retornar as colunas id, valor, data e situacao. A situacao deve obedecer a seguinte regra:
Se possui data de cancelamento preenchido: CANCELADO
Se possui data de faturamento preenchido: FATURADO
Caso não possua data de cancelamento e nem faturamento: PENDENTE */

SELECT 
  ID_PEDIDO AS ID, 
  VALOR_TOTAL AS VALOR, 
  DATA_EMISSAO AS DATA,
  CASE
    WHEN DATA_CANCELAMENTO IS NOT NULL THEN 'CANCELADO'
    WHEN DATA_FATURAMENTO IS NOT NULL THEN 'FATURADO'
    ELSE 'PENDENTE'
  END AS SITUACAO
FROM PEDIDO
ORDER BY ID;


/** 
Produtos mais vendidos: Escreva uma query que retorne o produto mais vendido ( em quantidade ), 
incluindo o valor total vendido deste produto, quantidade de pedidos em que ele apareceu e para quantos clientes 
diferentes ele foi vendido. A consulta deve retornar as colunas id_produto, quantidade_vendida, total_vendido, clientes, pedidos. 
Caso haja empate em quantidade de vendas, utilizar o total vendido como critério de desempate.
*/

SELECT
  PROD.ID_PRODUTO,
  COALESCE(SUM(ITEM.QUANTIDADE), 0) AS QUANTIDADE_VENDIDA,
  COALESCE(SUM(ITEM.QUANTIDADE * ITEM.PRECO_PRATICADO), 0) AS TOTAL_VENDIDO,
  COUNT(DISTINCT ITEM.ID_PEDIDO) AS PEDIDOS,
  COUNT(DISTINCT PED.ID_CLIENTE) AS CLIENTES
FROM PRODUTOS PROD
LEFT JOIN ITENS_PEDIDO ITEM ON ITEM.ID_PRODUTO = PROD.ID_PRODUTO
LEFT JOIN PEDIDO PED ON PED.ID_PEDIDO = ITEM.ID_PEDIDO
GROUP BY PROD.ID_PRODUTO
ORDER BY QUANTIDADE_VENDIDA DESC, TOTAL_VENDIDO DESC
