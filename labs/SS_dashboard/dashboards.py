import plotly.io as pio
#import pygwalker as pyg
import pandas as pd
import streamlit as st
import streamlit.components.v1 as components
import plotly.express as px
from streamlit_plotly_events import plotly_events
from utils.viz import st_helpers as sth
from pygwalker.api.streamlit import init_streamlit_comm, get_streamlit_html

pio.templates.default = 'plotly_white'
st.set_page_config(page_title="SuperMarket Dashboard", 
                   page_icon=":bar_chart:",
                   layout="wide",
                   initial_sidebar_state="collapsed",
                   menu_items={
                        'Get Help': 'https://www.extremelycoolapp.com/help',
                        'Report a bug': "https://www.extremelycoolapp.com/bug",
                        'About': "# This is a header. This is an *extremely* cool app!"
                    }
                   )

# Initialize pygwalker communication
init_streamlit_comm()

with open('style.css') as f:
    st.markdown(f'<style>{f.read()}</style>', unsafe_allow_html=True)


# When using `use_kernel_calc=True`, you should cache your pygwalker html, if you don't want your memory to explode
@st.cache_resource
def get_pyg_html(df: pd.DataFrame) -> str:
    # When you need to publish your application, you need set `debug=False`,prevent other users to write your config file.
    # If you want to use feature of saving chart config, set `debug=True`
    html = get_streamlit_html(df, spec="./gw0.json", use_kernel_calc=True, debug=False, dark='light')
    return html

@st.cache_data
def load_data() -> pd.DataFrame:
    data = pd.read_csv("supermarket_sales.csv", sep=";", decimal=",")
    data["Date"] = pd.to_datetime(data["Date"])
    data = data.sort_values("Date")
    data["Month"] = data["Date"].apply(lambda x: str(x.year) + "-" + str(x.month))
    return data

   
df = load_data()

st.sidebar.header("Select Filters")
month = st.sidebar.selectbox("Mês", df["Month"].unique(), key='month_param')
df_filtered = df[df["Month"] == month]

kpi1, kpi2, kpi3 = st.columns(3)
col1, col2 = st.columns(2)
col3, col4, col5 = st.columns(3)
col6, col7 = st.columns(2)

#example
#kpi1.metric("Temperature", "70 °F", "1.2 °F")
sth.setup_object(render_type='metric',
                 st_render_obj=kpi1,
                 params={
                     #https://streamlit-emoji-shortcodes-streamlit-app-gwckff.streamlit.app/
                     "label":":earth_americas: Temperature",
                     "label_visibility":"visible", #abel_visibility ("visible", "hidden", or "collapsed")
                     "value":"70 °F",
                     "delta": "-2 °F",
                     "delta_color":"normal", # "normal", "inverse", or "off"
                     "help":"This is a help text about this metric"},
                 data=None, fig_class=None)

kpi2.metric(":earth_americas: Wind", "9 mph", "-8%")
kpi3.metric(":earth_americas: Humidity", "86%", "4%")

sth.setup_object(data=df_filtered, fig_class=px.bar, 
             params={"x":"Date","y":"Total", "title":"Faturamento por periodo[2]","color":"City",
                     "description":"Payments by Date"}, 
             st_render_obj=col1, render_type="container_plotly")

sth.setup_object(data=df_filtered, fig_class=px.bar, 
             params={"x":"Date","y":"Product line", 
                         "title":"Faturamento por tipo de produto[2]",
                         "color":"City", "orientation":"h",
                         "description":"Payments by Productline"}, 
             st_render_obj=col2, render_type="container_plotly")

sth.setup_object(data=df_filtered.groupby("City")[["Total"]].sum().reset_index(), 
             fig_class=px.bar, 
             params={"x":"City","y":"Total", 
                         "title":"Faturamento por filial[2]",
                         "description":"Payments by city"}, 
             st_render_obj=col3, render_type="container_plotly")

sth.setup_object(data=df_filtered, fig_class=px.pie, 
             params={"names":"Payment","values":"Total", "hole":0.5,
                         "title":"Faturamento por tipo de pagamento[2]",
                         "description":"Sum of payments by type"},
             st_render_obj=col4 ,render_type="container_plotly")

sth.setup_object(data=df_filtered.groupby("City")[["Rating"]].mean().reset_index(), 
             fig_class=px.bar, 
             params={"x":"City","y":"Rating",
                         "title":"Avaliação[2]",
                    "description":"Average of rating by city"},
             st_render_obj=col5,render_type="container_plotly")



fig_chart_6 = sth.build_plotly_figure(data=df_filtered, plotly_fig_class=px.pie, 
             fig_params={"names":"Payment","values":"Total", "hole":0.5,
                         "title":"Faturamento por tipo de pagamento[3]"})

fig_chart_7 = sth.build_plotly_figure(data=df_filtered, 
             plotly_fig_class=px.bar, 
             fig_params={"x":"Date","y":"Product line", 
                         "title":"Faturamento por tipo de produto[3]",
                         "color":"City", "orientation":"h"})

with col6:
        average_rating_clicked = plotly_events(
            fig_chart_7,
            click_event=True,
            key=f"average_rating_clicked",
        )
with col7:
        payment_by_type = plotly_events(
            fig_chart_6,
            click_event=True,
            key=f"payment_by_type",
        )
#st.dataframe(df_filtered)

# https://docs.kanaries.net/pygwalker/use-pygwalker-with-streamlit
#pyg_html = pyg.to_html(df_filtered)
# Embed the HTML into the Streamlit app
#components.html(pyg_html, height=1000, scrolling=True)
#components.html(get_pyg_html(df_filtered), height=1000, scrolling=True)

#https://discuss.streamlit.io/t/button-to-autoset-values-to-current-page-using-values-from-previous-page/47169/8
st.write(st.session_state)