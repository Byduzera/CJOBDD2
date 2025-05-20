--2-Intercambio2

-- Habilita o contexto do banco de dados MASTER
USE Master;
GO

-- Habilita o contexto do banco de dados INTERCAMBIO
USE INTERCAMBIOCJ3025349;
GO

-- Exibe o nome das tabelas que existem no banco de dados em uso
SELECT name				    AS 'Nome da tabela',
	   create_date			AS 'Data da Criação'
FROM sys.tables;
GO

-- Exibe o nome das tabelas que existem no banco de dados em uso
SELECT TABLE_NAME AS 'Nome da tabela'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE' AND 
	  TABLE_CATALOG = 'INTERCAMBIOCJ3025349';
GO

-- Mostra os valores inseridos na tabela PAISES
SELECT CodPais    AS 'Código do País',
       NomePais   AS 'Nome',
       IdiomaPais AS 'Idioma Principal'
FROM PAISES;
GO

-- Mostra os valores inseridos na tabela VIAGENS
SELECT * FROM VIAGENS;
GO

-- Mostra os valores inseridos na tabela ALUNOS, exceto a data de nascimento e o telefone
SELECT CodAluno   AS 'Código',
       NomeAluno  AS 'Nome do Aluno',
       Endereco   AS 'Endereço',
       Genero     AS 'Gênero',
       PaisOrigem AS 'Origem',
       CodViagem  AS 'Código da Viagem'
FROM ALUNOS;
GO

-- Mostra os valores inseridos na tabela AlunosCOPIA, exceto a data de nascimento e o telefone
SELECT CodAluno   AS 'Código',
       NomeAluno  AS 'Nome do Aluno',
       Endereco   AS 'Endereço',
       Genero     AS 'Gênero',
       PaisOrigem AS 'Origem',
       CodViagem  AS 'Código da Viagem'
FROM AlunosCOPIA;
GO

-- Realiza a união, sem exibir os registros duplicados
SELECT CodAluno  AS 'Código do Aluno',
	   NomeAluno AS 'Nome do Aluno',
	   Genero	 AS 'Gênero do Aluno'
FROM ALUNOS
	UNION
SELECT CodAluno	 AS 'Código do Aluno',
	   NomeAluno AS 'Nome do Aluno',
	   Genero    AS 'Gênero do Aluno'
FROM AlunosCOPIA
ORDER BY CodAluno, NomeAluno;
GO

-- Realiza a união, sem exibir os registros duplicados
SELECT CodAluno  AS 'Código do Aluno',
	   NomeAluno AS 'Nome do Aluno',
	   Genero	 AS 'Gênero do Aluno'
FROM ALUNOS
	UNION ALL
SELECT CodAluno	 AS 'Código do Aluno',
	   NomeAluno AS 'Nome do Aluno',
	   Genero    AS 'Gênero do Aluno'
FROM AlunosCOPIA
ORDER BY CodAluno, NomeAluno;
GO

-- Retorna somente os registros que existem nas duas consultas
SELECT CodAluno  AS 'Código do Aluno',
	   NomeAluno AS 'Nome do Aluno',
	   Genero	 AS 'Gênero do Aluno'
FROM ALUNOS
	INTERSECT
SELECT CodAluno	 AS 'Código do Aluno',
	   NomeAluno AS 'Nome do Aluno',
	   Genero    AS 'Gênero do Aluno'
FROM AlunosCOPIA
ORDER BY CodAluno, NomeAluno;
GO

-- Retorna somente os registros que existem na primeira consulta
SELECT CodAluno  AS 'Código do Aluno',
	   NomeAluno AS 'Nome do Aluno',
	   Genero	 AS 'Gênero do Aluno'
FROM ALUNOS
	EXCEPT
SELECT CodAluno	 AS 'Código do Aluno',
	   NomeAluno AS 'Nome do Aluno',
	   Genero    AS 'Gênero do Aluno'
FROM AlunosCOPIA
ORDER BY CodAluno, NomeAluno;
GO

-- Seleciona somente os alunos cujo nome aparace nas duas tabelas. Versão com INTERSECT.
SELECT NomeAluno AS 'Nome do Aluno'
FROM ALUNOS
	INTERSECT
SELECT NomeAluno AS 'Nome do Aluno'
FROM AlunosCOPIA
ORDER BY NomeAluno;
GO

-- Seleciona somente os alunos cujo nome aparace nas duas tabelas. Versão com uma soubconsulta IN.
SELECT NomeAluno AS 'Nome do Aluno'
FROM ALUNOS
WHERE NomeAluno IN
	(SELECT NomeAluno FROM AlunosCOPIA)
ORDER BY NomeAluno;
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Subconsultas 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Exibe informações sobre os alunos e as viagens que eles realizaram
SELECT VIAGENS.CodViagem AS 'Codigo',
	   ALUNOS.NomeAluno  AS 'Nome do Aluno',
	   ALUNOS.Telefone,
	   ALUNOS.Genero     AS 'Gênero',
	   (SELECT NomePais FROM PAISES WHERE CodPais = 
ALUNOS.PaisOrigem)		AS 'Origem',
	   (SELECT NomePais FROM PAISES WHERE CodPais = 
VIAGENS.PaisDestino)    AS 'Destino',
	   VIAGENS.DataSaida   AS 'Data de Saída',
	   VIAGENS.DataRetorno AS 'Data de Retorno',
	   VIAGENS.Valor	   AS 'Preço de Viagens R$'
FROM ALUNOS INNER JOIN VIAGENS
	ON ALUNOS.CodViagem = VIAGENS.CodViagem;
GO

-- Exibe os dados dos paises utilizados como destino nas viagens dos alunos, cujo códigp seja 'USA'.
SELECT CodPais     AS 'Código',
	   NomePais	   AS 'País de Destino',
	   IdiomaPais AS 'Idiomas'
FROM PAISES
WHERE CodPais = (
	SELECT DISTINCT PaisDestino
	FROM VIAGENS
	WHERE PaisDestino = 'USA'
);
GO

-- Exibe os dados dos paises utilizados como destino nas viagens dos alunos cadastrados
SELECT CodPais     AS 'Código',
	   NomePais	   AS 'País de Destino',
	   IdiomaPais AS 'Idiomas'
FROM PAISES
WHERE CodPais IN (
	SELECT PaisDestino FROM VIAGENS
);
GO

-- Exibe o código, nome e quantidade de viagens cadastrados para  o pais de destino.
-- Exibe somente as informaçoes para os paises onde a quantidade de viagens seja maior ou igual a quantidade de viagens ralizadas para o México.
SELECT P.CodPais   AS 'Código',
	   P.NomePais  AS 'Pais de Destino',
	   COUNT(CodPais) AS 'Total de Viagens'
FROM PAISES P INNER JOIN VIAGENS V
	ON P.CodPais = V.PaisDestino
GROUP BY P.CodPais, P.NomePais
HAVING COUNT(P.CodPais) >= (
	SELECT COUNT(PaisDestino) FROM VIAGENS
	WHERE PaisDestino = 'MEX'
);
GO

-- Exibe os dados dos paises utilizados como destino nas viagens doa alunos, desde que esses paises sejam Estados Unidos, México ou Brasil.
SELECT CodPais		AS 'Código',
	   NomePais		AS 'País de Destino',
	   IdiomaPais	AS 'Idioma'
FROM PAISES
WHERE CodPais = ANY (
	SELECT PaisDestino FROM VIAGENS
	WHERE PaisDestino IN ('USA', 'MEX', 'BRA')
);
GO

-- Exibe os dados das viagens que não foram cadastradas na tabela ALUNOS
SELECT CodViagem   AS 'Codigo da Viagem',
	   DataSaida   AS 'Data de Saída',
	   DataRetorno AS 'Data de Retorno',
	   PaisDestino AS 'Destino'
FROM VIAGENS
WHERE CodViagem > ALL (
	SELECT CodViagem FROM ALUNOS
);
GO

-- fUNÇOES PARA OPERAÇÕES MATEMATICAS
SELECT '3,1415'			AS 'PI',
	    PI()			AS 'PI',
		ABS(-3.1415)	AS 'ABS',
		CEILING(3.1415) AS 'CEILING',
		FLOOR(3.1415)   AS 'FLOOR',
		EXP(1.0)		AS 'EXP',
		POWER(2, 3.0)	AS 'POWER',
		RAND(5)			AS 'RAND',
		ROUND(PI(), 2)  AS 'ROUND',
		SQRT(100)		AS 'SQRT',
		SIGN(-1)		AS 'SIGN',
		SQUARE(3)		AS 'SQUARE';
GO

-- Exibe informações sobre o valor das viagens dos alunos
SELECT V.CodViagem		AS 'Código da Viagem',
	   A.NomeAluno		AS 'Nome do Aluno',
	   V.Valor			AS 'Preço da Viagem',
	   V.Valor * 0.05   AS 'Desconto de 5%',
	   V.Valor * 0.95   AS 'Total a Pagar', 
	   ROUND(V.Valor * 0.95, 1) AS 'Total a Pagar (ROUND)'
FROM VIAGENS V INNER JOIN ALUNOS A 
	ON V.CodViagem = A.CodViagem;
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------- FUNÇÕES------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Exemplo de funções com precisão superior e inferior 
SELECT SYSDATETIME()		AS 'SYSDATETIME',
	   SYSDATETIMEOFFSET()	AS 'SYSDATETIMEOFFSET',
	   SYSUTCDATETIME()		AS 'SYSUTCDATETIME',
	   CURRENT_TIMESTAMP	AS 'CURRENT_TIMESTAMP',
	   GETDATE()			AS 'GETDATE',
	   GETUTCDATE()			AS 'GETUTCDATE';
GO

-- Exemplo de funções que obtêm a parte de uma data
SELECT CodAluno			AS 'Código',
	   DataNasc			AS 'Data de Nascimento',
	   DAY(DataNasc)	AS 'Dia do Nascimento',
	   MONTH(DataNasc)	AS 'Mês do Nascimento',
	   YEAR(DataNasc)	AS 'Ano do Nascimento',
	   DATEPART(WEEK, DataNasc)	AS 'Semana do Nascimento', 
	   DATEPART(WEEKDAY, DataNasc) AS 'Dia da Semana do Nascimento'
FROM ALUNOS;
GO

-- Declaração de variáveis em T-SQL
DECLARE @dia	AS INT,
		@mes	AS CHAR(20),
		@ano	AS INT,
		@data1	AS DATE,
		@data2	AS DATETIME;

-- Atribuido valores
SET @dia = DAY(GETDATE());
SET	@mes = MONTH(GETDATE());
SET	@ano = YEAR(GETDATE());

--Cria uma nova data
SET @data1 = DATEFROMPARTS(@ano, @mes, @dia);
SET @data2 = DATETIMEFROMPARTS(@ano, @mes, @dia, 0, 0, 0, 0);

SELECT @dia		AS 'Dia',
	   @mes		AS 'Mês',
	   @ano		AS 'Ano', 
	   @data1	AS 'Data 1',
	   @data2   AS 'Data 2';
GO

------------------------------------------------------------------------------------------

--Declara duas datas
DECLARE @data1	AS DATE,
		@data2  AS DATE;

-- Altera o formato de entrada das datas
SET DATEFORMAT DMY;

-- Atribui alguns valores
SET @data1 = '01/01/2024';
SET @data2 = GETDATE();

--Utilliza DATEDIFF para calcular a diferença entre as datas
SELECT @data1 AS 'Data Inicial',
	   @data2 AS 'Data de Hoje',
	   DATEDIFF(DAY, @data1, @data2) AS 'Qtd. Dias',
	   DATEDIFF(MONTH, @data1, @data2) AS 'Qtd. Meses',
	   DATEDIFF(HOUR, @data1, @data2) AS 'Qtd. Horas';
GO

----------------------------------------------------------------------------------------------
-- Modificação de data e valores da hora
SELECT GETDATE() AS 'Data Atual',
	   DATEADD(MONTH, 5, GETDATE()) AS 'Próximos 5 meses',
	   EOMONTH(GETDATE(), 5) AS 'Final do mês (daqui 5 meses)',
	   SWITCHOFFSET(GETDATE(), '+10:00') AS 'Alteração de fuso-horário (+10 horas)';
GO

--Exibe a configuração atual idioma e do primeiro dia da semana
SELECT @@LANGUAGE  AS  'Idioma Utilizado', 
	   @@DATEFIRST AS  'Primeiro dia da semana';
GO

-- Demonstra a utilizaçao do comando SELECT... CASE
SELECT @@LANGUAGE AS 'Idioma Utilizando', 
		CASE
			WHEN @@DATEFIRST = 1 THEN 'Segunda-feira'
			WHEN @@DATEFIRST = 2 THEN 'Terça-feira'
			WHEN @@DATEFIRST = 3 THEN 'Quarta-feira'
			WHEN @@DATEFIRST = 4 THEN 'Quinta-feira'
			WHEN @@DATEFIRST = 5 THEN 'Sexta-feira'
			WHEN @@DATEFIRST = 6 THEN 'Sabado'
			WHEN @@DATEFIRST = 7 THEN 'Domingo'
		END AS 'Primeiro dia da semana';
GO

--Exibe informações sobre todos os idiomas disponiveis no servidor
SELECT * FROM sys.syslanguages;
GO

--Retorna informações sobre alguns idiomas
SELECT langid		AS 'ID do idioma',
	   dateformat	AS 'Formato de data', 
	   datefirst	AS 'Primeiro dia da semana',
	   name			AS 'Nome do idioma',
	   alias		AS 'Nome alternativo do idioma',
	   months		As 'Nome dos meses',
	   shortmonths AS 'Abreviatura dos meses',
	   days			AS 'Nomes dos dias'
FROM sys.syslanguages
WHERE alias IN ('English', 'Brazilian', 'German', 'Japanese', 'Russian');
GO

--Retorna informações sobre alguns idiomas
EXEC SP_HELPLANGUAGE [Brazilian];
GO

EXEC SP_HELPLANGUAGE [Japanese];
GO

EXEC SP_HELPLANGUAGE [English];
GO

-- Declara uma variavel para armazenar a data atual
DECLARE @data DATETIME;

--Atribui o valor da data atual 
SET @data = GETDATE();

-- Exibe informações sobre a data atual
SELECT @data			      AS 'Data Atual',
	   DATEPART(DAY, @data)	  AS 'Dia do Mês',
	   DATENAME(DW, @data)    AS 'Dia da Semana',
	   DATEPART(MONTH, @data) AS 'Mês',
	   DATENAME(MONTH, @data) AS 'Nome do Mês',
	   DATEPART(YEAR, @data)  AS 'Ano';
GO

--Outra maneira de exibir informaçoes sobre a data atual
SELECT @data			    AS 'Data Atual',
	   DATEPART(DW, @data)	AS 'Dia da Semana',
	   DATENAME(WK, @data)  AS 'Semana do Ano',
	   DATEPART(M, @data)   AS 'Nome do Mês',
	   DATENAME(D, @data)   AS 'Dia do Mês',
	   DATEPART(DY, @data)  AS 'Dia do Ano';
GO

-- Altera o idioma para o Português do Brasil
SET LANGUEGE Brazilian;
GO

-- Declara uma variavel para armazenar a data atual
DECLARE @data DATETIME;

--Atribui o valor da data atual 
SET @data = GETDATE();

--Exibe o idioma, dia da semana e nome do mês
SELECT @@LANGUAGE			AS 'Idioma',
	   DATEPART(DW, @data)	AS 'Dia da Semana',
	   DATEPART(M, @data)   AS 'Nome do Mês';
GO

-- Altera o formato de data e hora -> DMY
SET DATEFORMAT DMY;
GO

-- Utiliza ISDATE e um IF-ELSE para validar uma data
IF ISDATE('20/01/2015 00:10:50.000') = 1
	PRINT 'Data válida!';
ELSE
	PRINT 'Data Inválida!';
GO

--Retorna para os valores de idioma e data padrão
SET LANGUAGE us_english;
SET DATEFORMAT MDY;
GO

--Demonstra a utilização de algumas funçoes que manipulam o código ASCII e o código unicode
SELECT ASCII('A')		AS 'ASCIII: A',
	   UNICODE('A')		AS 'UNICODE: A',
	   CHAR(65)			AS 'CHAR: 65',
	   NCHAR(65)		AS 'ASCII: 65',
	   ASCII(N'我')		AS 'ASCII: 我',
	   UNICODE(N'我')	AS 'UNICODE: 我',
	   CHAR(31169)		AS 'CHAR: 31169',
	   NCHAR(31169)		AS 'NCHAR: 31169',
	   CHARINDEX('S', 'Microsoft SQL')   AS 'CHARINDEX: S',
	   CHARINDEX('SQL', 'Microsoft SQL') AS 'CHARINDEX: SQL';
GO

-- Demonstra a utilização do SPACE, QUOTENAME, STR E LEN
SELECT 'Paulo' + 'Giovani'		 AS 'SPACE 1',
	   'Paulo' + ' ' + 'Giovani' AS 'SPACE 2',
	   'Paulo' + SPACE(10) + 'Gioavani' AS 'SPACE 3',
	   QUOTENAME('Paulo Giovani', '{')  AS 'QUOTENAME 1',
	   QUOTENAME('Paulo Giovani', '"')  AS 'QUOTENAME 2',
	   QUOTENAME('Paulo Giovani', '[')  AS 'QUOTENAME 3',
	   STR(100)   AS 'STR 1',
	   STR(100.0) AS 'STR 2',
	   STR(10045, 6, 2)     AS 'STR 3',
	   LEN('Paulo giovani') AS 'LEN 1';
GO

-- Demonstra a utilização de PATINDEX
SELECT PATINDEX('soft', 'Miceosoft SQL') AS 'PATINDEX 1',
	   PATINDEX('%soft%', 'Microsoft SQL') AS 'PATINDEX  2';
GO

-- Demonstra a utilização de SOUDEX e DIFFERENCE 
SELECT SOUNDEX('Paulo') AS 'SOUNDEX: Paulo',
	   SOUNDEX('Paul') AS 'SOUNDEX: Paul',
	   SOUNDEX('Cris') AS 'SOUNDEX: Cris',
	   DIFFERENCE('Paulo', 'Paul') AS 'DIFF 1',
	   DIFFERENCE('Paulo', 'Paul') AS 'DIFF 2';
GO

-- Exibe a data ataul, formatada em vários idiomas
DECLARE @d	DATETIME = GETDATE();

SELECT FORMAT(@d, 'D', 'en-US') AS ' Inglês Americano',
	   FORMAT(@d, 'D', 'en-gb') AS ' Inglês Britânico',
	   FORMAT(@d, 'D', 'de-de') AS ' Alemão',
	   FORMAT(@d, 'D', 'zh-cn') AS  'Chinês Simplificado',
	   FORMAT(@d, 'D', 'pt-br') AS  'Portugues Brasileiro';
GO

--Exibe o nome do aluno e a data de nascimento
SELECT NomeAluno AS 'Nome do Aluno',
	   DataNasc  AS 'Data de Nascimento',
	   FORMAT(DataNasc, 'D', 'pt-br') AS 'Data de Nascimento' 
	   FROM ALUNOS;
GO

---------------------------------------------------------------------------------------------------------
--Continuação da aula -> 19/05/2025
---------------------------------------------------------------------------------------------------------
-- Funções para manipulação de Strings

--Demostra a utilização de CONCAT, STUFF, REVERSE e REPLICATE
SELECT CONCAT('Marcos', 'Vinicius') AS 'CONCAT',
	   CONCAT('Rua ', 'João XXIII, ', '15', ' - São Paulo') AS 'Endereço',
	   STUFF('Paulo Giovani', 2, 1, 'TEXTO') AS 'STUFF',
	   REVERSE('Paulo Giovani') AS ' REVERSE', 
	   REPLICATE(' * ', 10)     AS 'REPLICATE 1', 'Paulo' + REPLICATE('.', 5) + ': ' + '5555-6666' AS 'REPLICATE 2';
GO

-- Altera o idioma para o portugues do Brasil
SET LANGUAGE Brazilian;
GO

--Exibe a data de nascimento dos alunos
SELECT NomeAluno AS 'Nome do Aluno',
	   DATEPART(DAY, DataNasc)  AS 'Dia',
	   DATENAME(DW, DataNasc)   AS 'Dia da Semana',
	   DATENAME(M, DataNasc)    AS 'Nome do Mês', 
	   DATEPART (YEAR, DataNasc) AS 'Ano',
	   CONCAT(DATENAME(DW, DataNasc), ', ',
			  DATEPART (DAY, DataNasc), ', ',
			  DATENAME(M, DataNasc), ' de ',
			  DATEPART(YEAR, DataNasc), ',') AS 'Data de Nascimento'
FROM ALUNOS;
GO

-- Altere o idioma para o Inglês
SET LANGUAGE us_english;
GO

--Demostra o uso de SUBSTRING, LEFT, RIGHT, LOWER, UPPER, LTRIM e RTRIM
SELECT NomeAluno		AS 'Nome do aluno',
	   SUBSTRING(NomeAluno, 1, 1) AS 'Inicial',
	   LOWER(NomeAluno) AS 'Nome em minúsculas',
	   UPPER(NomeAluno) AS 'Nome em maiúsculas',
	   LEN(NomeAluno)   AS 'Qtd caracteres',
	   LEFT(NomeAluno, 3)  AS 'LEFT',
	   RIGHT(NomeAluno, 3) AS 'RIGHT',
	   RIGHT(RTRIM(NomeAluno), 3) AS 'RTRIM',
	   '    ' + NomeAluno         AS 'LTRIN 1',
	   LTRIM('    ' + NomeAluno)  AS 'LTRIM 2'
FROM ALUNOS;
GO

 -- Funções para conversões de dados --

 -- Exeplos básico de utilização de CAST e CONVERT
 DECLARE @valor AS DECIMAL(5, 2) = 156.90;

 SELECT CAST(@valor AS CHAR(20))	   AS 'CAST',
		CONVERT(DECIMAL(10,5), @valor) AS 'CONVERT';
GO

-- Exemplos de conversão de um inteiro com CAST e CONVERT
DECLARE @valor AS INT = 100;

SELECT CAST(@valor AS CHAR(20))			AS 'CAST 1',
	   CAST(@valor AS DECIMAL(10, 5))   AS 'CAST 2',
	   CONVERT(CHAR(20), @valor)		AS 'CONVERT 1',
	   CONVERT(DECIMAL(10, 5), @valor)  AS 'CONVERT 2';
GO

-- Conversão de uma data utilizando CAST e CONVERT
DECLARE @data AS DATE = '01/25/2024';

SELECT CAST(@data AS CHAR(20)) AS 'CAST (Padrão)',
	   CONVERT(CHAR(20), @data) AS 'CONVERT(padrão)',
	   CONVERT(CHAR(20), @data, 101) AS 'EUA (mm/dd/aaaa)',
	   CONVERT(CHAR(20), @data, 103) AS 'Brasil (dd/mm/aaaa)',
	   CONVERT(CHAR(20), @data, 111) AS 'Japão (aaaa/mm/dd)';
GO

-- Demostra a utilização do PARSE para converter data e dinheiro
SELECT PARSE('Quinta-feira, 25 de janeiro de 2024' AS DATE USING 'pt-BR') AS 'Data Brasileira',
	   PARSE('Thursday, 25 January 2024' AS DATE USING 'en-US') AS 'Data Americana',
	   PARSE('01/25/2024' AS DATETIME2) AS 'Data Padrão',
	   PARSE('R$ 345,98' AS MONEY USING 'pt-BR') AS 'Dinheiro Americano',
	   PARSE('¥ 345,98' AS MONEY USING 'jp-JP') AS 'Dinheiro Japonês';
GO

-- Exemplo de validação utilizando TRY_CAST, TRY_CONVERT e TRY_PARSE
DECLARE @data AS CHAR(10) = '25/01/2014';

SELECT TRY_CAST(@data AS DATE) AS 'TRY CAST',
	   TRY_CONVERT(DATE, @data, 103) AS 'Brasil (dd/mm/aaaa)',
	   TRY_CONVERT(DATE, @data, 101) AS 'EUA (mm/dd/aaaa)',
	   TRY_PARSE(@data AS DATE) AS 'TRY PARSE';
GO