-- ########################################################################################################################
-- AGORA BASTA COLOCAR AS OPs, SEGUINDO ESSE PADRÃO: 'PV081101001' OU PARA VÁRIAS 'PV081101001,DS767401001'
-- Declarando a variável para armazenar os valores
DECLARE @OPs NVARCHAR(MAX);
SET @OPs = '44222401001,43222401001,701/2401003,562/2401002,771/2401003,542/2401002,681/2401002,552/2401003,363/2401003,T4202401001,T4182401001,T3972401001';
-- ########################################################################################################################
-- Variáveis auxiliares para o loop
DECLARE @Pos INT, @Value NVARCHAR(50);
-- Verifica se a tabela temporária já existe e remove
IF OBJECT_ID('tempdb..#TempOps') IS NOT NULL
    DROP TABLE #TempOps;
-- Criando uma tabela temporária para armazenar os valores
CREATE TABLE #TempOps (C2_KEY NVARCHAR(50));
-- Adicionando uma vírgula extra ao final da string para facilitar o processamento
SET @OPs = @OPs + ',';
-- Iniciando o loop para dividir a string
WHILE CHARINDEX(',', @OPs) > 0
BEGIN
    -- Encontrar a posição da próxima vírgula
    SET @Pos = CHARINDEX(',', @OPs);
    -- Extrair o valor antes da vírgula
    SET @Value = LTRIM(RTRIM(LEFT(@OPs, @Pos - 1)));
    -- Inserir o valor na tabela temporária
    INSERT INTO #TempOps (C2_KEY)
    VALUES (@Value);
    -- Remover o valor já processado da string
    SET @OPs = STUFF(@OPs, 1, @Pos, '');
END;
-- Selecionando os registros com base na tabela temporária
SELECT D_E_L_E_T_, C2_DATRF, C2_NUM, C2_ITEM, * FROM SC2010 WHERE D_E_L_E_T_ <> '*' AND C2_NUM + C2_ITEM + C2_SEQUEN
    IN (SELECT C2_KEY FROM #TempOps);
-- Atualizando os registros com base na tabela temporária
--/*
UPDATE SC2010 SET C2_DATRF = '' WHERE D_E_L_E_T_ <> '*' AND C2_NUM + C2_ITEM + C2_SEQUEN IN (SELECT C2_KEY FROM #TempOps);
--*/
-- Selecionando os registros com base na tabela temporária
SELECT D_E_L_E_T_, C2_DATRF, C2_NUM, C2_ITEM, * FROM SC2010 WHERE D_E_L_E_T_ <> '*' AND C2_NUM + C2_ITEM + C2_SEQUEN
    IN (SELECT C2_KEY FROM #TempOps);
-- Limpando a tabela temporária
--DROP TABLE #TempOps;







-- #### A partir do SQL Server 2016 podemos usar esse código

/*
-- Declarando a variável para armazenar os valores
DECLARE @OPs NVARCHAR(MAX);
SET @OPs = 'PV081101001,DS767401001';

-- Criando uma tabela temporária para armazenar os valores
CREATE TABLE #TempOps (C2_KEY NVARCHAR(50));

-- Inserindo os valores na tabela temporária
INSERT INTO #TempOps (C2_KEY)
SELECT value
FROM STRING_SPLIT(@OPs, ',');

-- Selecionando os registros com base na tabela temporária
SELECT D_E_L_E_T_, C2_DATRF, C2_NUM, C2_ITEM, * 
FROM SC2010 
WHERE D_E_L_E_T_ <> '*' 
  AND C2_NUM + C2_ITEM + C2_SEQUEN IN (SELECT C2_KEY FROM #TempOps);

-- Atualizando os registros com base na tabela temporária
UPDATE SC2010 
SET C2_DATRF = '' 
WHERE D_E_L_E_T_ <> '*' 
  AND C2_NUM + C2_ITEM + C2_SEQUEN IN (SELECT C2_KEY FROM #TempOps);

-- Limpando a tabela temporária
DROP TABLE #TempOps;

*/