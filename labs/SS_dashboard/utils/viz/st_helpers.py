import pandas as pd
import plotly.graph_objs as go
import streamlit as st

def setup_object(data, fig_class, params:dict, st_render_obj, 
                 render_type:str = 'plotly_chart', plotly_events=None,
                 key=None):
    if render_type == 'plotly_chart':
        st_render_obj.plotly_chart(
            fig_class(
                data,
                **params
            ),
            theme="streamlit",
            use_container_width=True
        )
    elif render_type == 'metric':
        st_render_obj.metric(
            **params
            )
    
    elif render_type == 'container_plotly':
        container = st_render_obj.container(border=True)
        container.markdown("#### {plot_title}".format(plot_title=params['title']))
        container.caption("{plot_description}".format(plot_description=params['description']))
        params.pop('description')
        params.pop('title')
        container.divider()
        container.plotly_chart(
                    fig_class(
                        data,
                        **params
                    ),
                    theme="streamlit",
                    use_container_width=True
                )

    elif render_type == 'container_plotly_events':
        params.pop('description')
        fig = fig_class(
                data,
                **params
                )
        st_render_obj.plotly_chart(
            fig,
            theme="streamlit",
            use_container_width=True
        )
        plotly_events(fig,
                click_event=True,
                select_event = True,
                hover_event = True,
                key=key)
    

# https://github.com/andfanilo/social-media-tutorials/blob/master/20220914-crossfiltering/streamlit_app.py
# https://www.youtube.com/watch?v=htXgwEXwmNs
def build_plotly_figure(data: pd.DataFrame, plotly_fig_class:go.Figure, fig_params:dict) -> go.Figure:
    return plotly_fig_class(
            data,
            **fig_params
        )

def build_container() -> st.delta_generator.DeltaGenerator:
    pass