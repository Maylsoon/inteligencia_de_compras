import streamlit as st

from SRC.analise import carregar_dados

st.set_page_config(
    page_title='Inteligência de compras',
    page_icon='🛒',
    layout='wide'
)

st.title('🛒 Inteligência de Compras')
st.caption("Análise de demanda, estoque e decisão de compra")

df = carregar_dados()

# =========================
# KPIs
# =========================

produtos = df["produto"].nunique()

comprar_urgente = (
    df["decisao_compra"] == "COMPRAR URGENTE"
).sum()

comprar = (
    df["decisao_compra"] == "COMPRAR"
).sum()

evitar = (
    df["decisao_compra"] == "EVITAR COMPRA"
).sum()

receita_total = df["receita_total"].sum()

lucro_total = df["lucro_total"].sum()

col1, col2, col3, col4, col5, col6 = st.columns(6)

col1.metric("Produtos", produtos)
col2.metric("🚨 Comprar urgente", comprar_urgente)
col3.metric("🛒 Comprar", comprar)
col4.metric("⛔ Evitar compra", evitar)
col5.metric("💰 Receita", f"R$ {receita_total:,.0f}")
col6.metric("💵 Lucro", f"R$ {lucro_total:,.0f}")

st.divider()

# =========================
# FILTROS
# =========================

st.subheader('🎯 Filtros de decisão')

col1, col2 = st.columns(2)

with col1:
    filtro_decisao = st.multiselect(
        'Decisão de compra',
        options=sorted(df["decisao_compra"].unique()),
        default=sorted(df["decisao_compra"].unique())
    )

with col2:
    filtro_prioridade = st.multiselect(
        "Prioridade",
        options=sorted(df["prioridade"].unique()),
        default=sorted(df["prioridade"].unique())
    )

df_filtrado = df[
    df['decisao_compra'].isin(filtro_decisao)
    & df["prioridade"].isin(filtro_prioridade)
]

urgentes = df_filtrado[
    df_filtrado["decisao_compra"] == "COMPRAR URGENTE"
]

if not urgentes.empty:

    st.warning(
        f"⚠️ {len(urgentes)} produto(s) apresentam "
        "necessidade de compra urgente."
    )

else:

    st.success(
        "✅ Nenhum produto apresenta necessidade "
        "de compra urgente."
    )

# =========================
# MATRIZ DE DECISÃO
# =========================

st.subheader("📋 Matriz de decisão")

df_exibicao = df_filtrado[
    [
        "produto",
        "unidades_vendidas",
        "receita_total",
        "lucro_total",
        "margem",
        "estoque_atual",
        "demanda_mensal_media",
        "cobertura_meses",
        "decisao_compra",
        "prioridade"
    ]
].copy()

df_exibicao["receita_total"] = df_exibicao["receita_total"].map(
    lambda x: f"R$ {x:,.2f}"
)

df_exibicao["lucro_total"] = df_exibicao["lucro_total"].map(
    lambda x: f"R$ {x:,.2f}"
)

df_exibicao["margem"] = df_exibicao["margem"].map(
    lambda x: f"{x:.1%}"
)

df_exibicao["demanda_mensal_media"] = df_exibicao[
    "demanda_mensal_media"
].round(2)

df_exibicao["cobertura_meses"] = df_exibicao[
    "cobertura_meses"
].round(2)

st.dataframe(
    df_exibicao,
    use_container_width=True,
    hide_index=True
)


# =========================
# VISUALIZAÇÕES
# =========================

st.divider()

st.subheader("📊 Demanda × Estoque")

st.bar_chart(
    df_filtrado.set_index("produto")[
        [
            "unidades_vendidas",
            "estoque_atual"
        ]
    ]
)

st.subheader("📦 Cobertura de estoque")

st.bar_chart(
    df_filtrado.set_index("produto")[
        "cobertura_meses"
    ]
)