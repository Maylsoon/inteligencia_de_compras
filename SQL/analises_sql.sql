USE inteligencia_compras;

SELECT *,
ROUND(lucro_bruto / receita, 2) AS margem
FROM vendas 
LIMIT 5;

DESCRIBE vendas;

SELECT COUNT(*) AS total_registros
FROM vendas;

SELECT
    produto,
    SUM(quantidade) AS unidades_vendidas,
    SUM(receita) AS receita_total,
    SUM(lucro_bruto) AS lucro_total
FROM vendas
GROUP BY produto
ORDER BY unidades_vendidas DESC;

SELECT
	produto,
    MONTH(data) AS mes,
    SUM(quantidade) AS unidades_vendidas,
    SUM(receita) AS receita_total,
    SUM(lucro_bruto) AS lucro_total
	FROM vendas
GROUP BY
	produto,
    MONTH(data)
ORDER BY
	produto,
    mes
LIMIT 5;
    
SELECT
    produto,
    SUM(quantidade) AS unidades_vendidas
FROM vendas
GROUP BY produto
ORDER BY unidades_vendidas DESC;

SELECT
    produto,
	MONTH(data) AS mes,
    SUM(quantidade) AS unidades_vendidas
FROM vendas
GROUP BY
    produto,
	MONTH(data)
ORDER BY
	unidades_vendidas DESC
LIMIT 5;

CREATE TABLE inteligencia_compras AS

SELECT
    produto,

    SUM(quantidade) AS unidades_vendidas,

    SUM(receita) AS receita_total,

    SUM(lucro_bruto) AS lucro_total,

	MAX(estoque_disponivel) AS estoque_atual

FROM vendas

GROUP BY produto;

ALTER TABLE inteligencia_compras
ADD COLUMN demanda_mensal_media DECIMAL(10,2),
ADD COLUMN cobertura_meses DECIMAL(10,2);

UPDATE inteligencia_compras
SET
    giro = CASE
        WHEN estoque_atual > 0
        THEN unidades_vendidas / estoque_atual
        ELSE NULL
    END,

    demanda_mensal_media = unidades_vendidas / 3,

    cobertura_meses = CASE
        WHEN unidades_vendidas > 0
        THEN estoque_atual / (unidades_vendidas / 3)
        ELSE NULL
    END;
    
    SET SQL_SAFE_UPDATES = 0;
    
    SELECT
    MIN(data) AS primeira_venda,
    MAX(data) AS ultima_venda,
    TIMESTAMPDIFF(
        MONTH,
        MIN(data),
        MAX(data)
    ) + 1 AS meses_historico
FROM vendas;

UPDATE inteligencia_compras
SET demanda_mensal_media = unidades_vendidas / 6;

ALTER TABLE inteligencia_compras
MODIFY COLUMN demanda_mensal_media DECIMAL(10,2);

UPDATE inteligencia_compras
SET demanda_mensal_media = unidades_vendidas / 6;

SELECT
    produto,
    unidades_vendidas,
    demanda_mensal_media
FROM inteligencia_compras
ORDER BY
	demanda_mensal_media DESC
LIMIT 5;

UPDATE inteligencia_compras
SET cobertura_meses =
    CASE
        WHEN demanda_mensal_media > 0
        THEN estoque_atual / demanda_mensal_media
        ELSE NULL
    END;
    
    SELECT
    produto,
    estoque_atual,
    demanda_mensal_media,
    cobertura_meses
FROM inteligencia_compras
ORDER BY demanda_mensal_media ASC
limit 5;

ALTER TABLE inteligencia_compras
ADD COLUMN decisao_compra VARCHAR(30);

UPDATE inteligencia_compras
SET margem =
    CASE
        WHEN receita_total > 0
        THEN lucro_total / receita_total
        ELSE 0
    END;
    
UPDATE inteligencia_compras
SET decisao_compra =
    CASE
        WHEN cobertura_meses < 0.5
             AND margem >= 0.30
            THEN 'COMPRAR URGENTE'

        WHEN cobertura_meses < 1
             AND margem >= 0.30
            THEN 'COMPRAR'

        WHEN cobertura_meses BETWEEN 1 AND 3
            THEN 'MONITORAR'

        WHEN cobertura_meses > 3
            THEN 'EVITAR COMPRA'

        ELSE 'ANALISAR'
    END;
    
    
    SELECT
    produto,
    unidades_vendidas,
    margem,
    estoque_atual,
    demanda_mensal_media,
    cobertura_meses,
    decisao_compra
FROM inteligencia_compras
ORDER BY cobertura_meses
LIMIT 5;

ALTER TABLE inteligencia_compras
ADD COLUMN prioridade VARCHAR(20);

UPDATE inteligencia_compras
SET prioridade =
    CASE
        WHEN decisao_compra = 'COMPRAR URGENTE'
            THEN 'ALTA'

        WHEN decisao_compra = 'COMPRAR'
            THEN 'MÉDIA'

        WHEN decisao_compra = 'MONITORAR'
            THEN 'NORMAL'

        WHEN decisao_compra = 'EVITAR COMPRA'
            THEN 'BAIXA'

        ELSE 'ANALISAR'
    END;
    
    SELECT
    produto,
    unidades_vendidas,
    estoque_atual,
    cobertura_meses,
    margem,
    decisao_compra,
    prioridade
FROM inteligencia_compras
ORDER BY
    CASE prioridade
        WHEN 'ALTA' THEN 1
        WHEN 'MÉDIA' THEN 2
        WHEN 'NORMAL' THEN 3
        WHEN 'BAIXA' THEN 4
        ELSE 5
    END
    LIMIT 25;
    
    
    USE inteligencia_compras;

DROP VIEW IF EXISTS vw_inteligencia_compras;

CREATE VIEW vw_inteligencia_compras AS
SELECT
    produto,
    unidades_vendidas,
    receita_total,
    lucro_total,
    margem,
    estoque_atual,
    giro,
    demanda_mensal_media,
    cobertura_meses,
    decisao_compra,
    prioridade
FROM inteligencia_compras;

SELECT *
FROM vw_inteligencia_compras
ORDER BY
    CASE prioridade
        WHEN 'ALTA' THEN 1
        WHEN 'MÉDIA' THEN 2
        WHEN 'NORMAL' THEN 3
        WHEN 'BAIXA' THEN 4
        ELSE 5
    END;
    
    SELECT * FROM inteligencia_compras LIMIT 5;
    
SELECT
    produto,
    unidades_vendidas,
    estoque_atual,
    cobertura_meses,
    margem,
    decisao_compra,
    prioridade
FROM inteligencia_compras
ORDER BY
    CASE prioridade
        WHEN 'ALTA' THEN 1
        WHEN 'MÉDIA' THEN 2
        WHEN 'NORMAL' THEN 3
        WHEN 'BAIXA' THEN 4
        ELSE 5
    END
limit 10;