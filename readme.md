# 🛒 Inteligência de Compras

## 📌 Sobre o projeto

Projeto de análise de dados desenvolvido a partir de uma loja de vestuário utilizada como laboratório de dados.

O objetivo é transformar dados históricos de vendas em informações capazes de apoiar decisões de compra, reposição e gestão de estoque.

---

## 🎯 Problema de negócio

A partir dos dados de vendas, o projeto busca responder:

- Quais produtos apresentam maior demanda?
- Quais produtos possuem maior rentabilidade?
- Quais produtos estão próximos de ruptura?
- Quais produtos apresentam excesso de estoque?
- Quais produtos devem ser priorizados em uma nova compra?

---

## 🧠 Solução

Foi construída uma camada analítica no MySQL combinando:

- demanda histórica;
- receita;
- lucro;
- margem;
- estoque disponível;
- giro;
- demanda mensal média;
- cobertura de estoque.

A partir dessas métricas, foram criadas regras de negócio para classificar os produtos em:

- 🚨 COMPRAR URGENTE
- 🛒 COMPRAR
- 👀 MONITORAR
- ⛔ EVITAR COMPRA
- 🔎 ANALISAR

---

## 🛠️ Tecnologias

- Python
- Pandas
- NumPy
- MySQL
- SQL
- Streamlit
- Git/GitHub

---

## 📊 Indicadores

### Demanda
- Unidades vendidas
- Demanda mensal média

### Financeiro
- Receita total
- Lucro total
- Margem

### Estoque
- Estoque atual
- Giro
- Cobertura de estoque

### Decisão
- Decisão de compra
- Prioridade

---

## 📈 Dashboard

O dashboard desenvolvido em Streamlit apresenta:

- KPIs gerais;
- filtros por decisão e prioridade;
- matriz de decisão de compras;
- análise de demanda versus estoque;
- cobertura de estoque;
- alertas para produtos que exigem compra urgente.

---

## 🗂️ Estrutura do projeto

```text
inteligencia_compras/
│
├── SQL/
│   └── analises.sql
│
├── SRC/
│   └── analise.py
│
├── app.py
├── readme.md
└── .gitignore