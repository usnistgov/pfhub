---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.14.2-dev
  kernelspec:
    display_name: Python 3 (ipykernel)
    language: python
    name: python3
---

```python papermill={"duration": 0.012529, "end_time": "2023-07-17T20:37:13.301472", "exception": false, "start_time": "2023-07-17T20:37:13.288943", "status": "completed"} tags=["parameters"]
benchmark_id = '3a.1'
line_plots = [
    dict(name='free_energy', layout=dict(log_y=True, x_label=r'<i>t</i>', y_label=r'&#8497;', range_y=[1.8e6, 2.4e6], title="Free Energy v Time")),
    dict(name='solid_fraction', layout=dict(log_y=True, x_label=r'<i>t</i>')),
    dict(name='tip_position', layout=dict(log_y=True, x_label=r'<i>t</i>')),
    dict(name='phase_field_1500', layout=dict(aspect_ratio=1.0))
]
contour_plots = []
efficiency = True
```

```python papermill={"duration": 0.010703, "end_time": "2023-07-17T20:37:13.314678", "exception": false, "start_time": "2023-07-17T20:37:13.303975", "status": "completed"} tags=["injected-parameters"]
# Parameters
benchmark_id = "8a.1"
line_plots = [
    {
        "name": "free_energy_1",
        "layout": {
            "x_label": "Time [a.u.]",
            "y_label": "Free Energy, &#8497;&nbsp;[a.u.]",
            "title": "<i>r</i><sub>0</sub>=0.99<i>r</i><sup>*</sup>",
        },
    },
    {
        "name": "solid_fraction_1",
        "layout": {
            "x_label": "Time [a.u.]",
            "y_label": "Solid Fraction, [a.u.]",
            "title": "<i>r</i><sub>0</sub>=0.99<i>r</i><sup>*</sup>",
        },
    },
    {
        "name": "free_energy_2",
        "layout": {
            "x_label": "Time [a.u.]",
            "y_label": "Free Energy, &#8497;&nbsp;[a.u.]",
            "title": "<i>r</i><sub>0</sub>=<i>r</i><sup>*</sup>",
        },
    },
    {
        "name": "solid_fraction_2",
        "layout": {
            "x_label": "Time [a.u.]",
            "y_label": "Solid Fraction, [a.u.]",
            "title": "<i>r</i><sub>0</sub>=<i>r</i><sup>*</sup>",
        },
    },
    {
        "name": "free_energy_3",
        "layout": {
            "x_label": "Time [a.u.]",
            "y_label": "Free Energy, &#8497;&nbsp;[a.u.]",
            "title": "<i>r</i><sub>0</sub>=1.01<i>r</i><sup>*</sup>",
        },
    },
    {
        "name": "solid_fraction_3",
        "layout": {
            "x_label": "Time [a.u.]",
            "y_label": "Solid Fraction, [a.u.]",
            "title": "<i>r</i><sub>0</sub>=1.01<i>r</i><sup>*</sup>",
        },
    },
]
contour_plots = [
    {
        "name": "phase_field_1",
        "columns": ["x", "y", "z"],
        "mask_z": [0.1, 0.9],
        "layout": {
            "levelset": 0.5,
            "range": [-10, 10],
            "title": "Solid / Liquid Boundary at t=200, <i>r</i><sub>0</sub>=0.99<i>r</i><sup>*</sup>",
        },
    },
    {
        "name": "phase_field_2",
        "columns": ["x", "y", "z"],
        "mask_z": [0.1, 0.9],
        "layout": {
            "levelset": 0.5,
            "range": [-10, 10],
            "title": "Solid / Liquid Boundary at t=200, <i>r</i><sub>0</sub>=<i>r</i><sup>*</sup>",
        },
    },
    {
        "name": "phase_field_3",
        "columns": ["x", "y", "z"],
        "mask_z": [0.1, 0.9],
        "layout": {
            "levelset": 0.5,
            "range": [-10, 10],
            "title": "Solid / Liquid Boundary at t=200, <i>r</i><sub>0</sub>=1.01<i>r</i><sup>*</sup>",
        },
    },
]

```

```python papermill={"duration": 0.009644, "end_time": "2023-07-17T20:37:13.326964", "exception": false, "start_time": "2023-07-17T20:37:13.317320", "status": "completed"} tags=[]
from IPython.display import display_markdown

display_markdown(f'''
# Benchmark { benchmark_id } Results

All results for the [{ benchmark_id } benchmark specification](../../benchmarks/benchmark{ benchmark_id }.ipynb/).
''', raw=True)
```

```python papermill={"duration": 0.007862, "end_time": "2023-07-17T20:37:13.337514", "exception": false, "start_time": "2023-07-17T20:37:13.329652", "status": "completed"} tags=[]
# To generate the comparison notebooks use:
# 
# papermill template.ipynb benchmark{version}.ipynb -f bm{version}.yaml
#
```

```python papermill={"duration": 0.014009, "end_time": "2023-07-17T20:37:13.354237", "exception": false, "start_time": "2023-07-17T20:37:13.340228", "status": "completed"} tags=[]
from IPython.display import HTML

HTML('''<script>
code_show=true; 
function code_toggle() {
 if (code_show){
 $('div.input').hide();
 $('div.prompt').hide();
 } else {
 $('div.input').show();
$('div.prompt').show();
 }
 code_show = !code_show
} 
$( document ).ready(code_toggle);
</script>
<form action="javascript:code_toggle()"><input type="submit" value="Code Toggle"></form>''')
```

```python papermill={"duration": 1.132072, "end_time": "2023-07-17T20:37:14.493235", "exception": false, "start_time": "2023-07-17T20:37:13.361163", "status": "completed"} tags=[]
#from IPython.display import HTML, display
#from time import sleep

#display(HTML("""
#<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
#"""))

#sleep(0.1)

from IPython.display import HTML, display, display_markdown
from time import sleep

#import logging
#logging.basicConfig(format='%(asctime)s - %(message)s', level=logging.DEBUG)

display(HTML("""
<script src="https://cdnjs.cloudflare.com/ajax/libs/require.js/2.1.10/require.min.js"></script>
"""))

sleep(0.1)


from pfhub.main import line_plot, levelset_plot, get_table_data_style, plot_order_of_accuracy, get_result_data, efficiency_plot
#import itables.interactive
from itables import init_notebook_mode

init_notebook_mode(all_interactive=False)
```

```python papermill={"duration": 35.174896, "end_time": "2023-07-17T20:37:49.670984", "exception": false, "start_time": "2023-07-17T20:37:14.496088", "status": "completed"} tags=[]
colors = dict()

for x in line_plots:
    fig = line_plot(
        data_name=x['name'],
        benchmark_id=benchmark_id,
        layout=x['layout'],
        columns=x.get('columns', ('x', 'y'))
    )
    if 'extra_lines' in x:
        for kwargs in x['extra_lines']:
            fig.add_scatter(**kwargs)  
    for datum in fig['data']:
        name = datum['name']
        color = datum['line']['color']
        datum['line']['color'] = colors.get(name, color)
        colors[name] = datum['line']['color']
    fig.show()
```

```python papermill={"duration": 8.281004, "end_time": "2023-07-17T20:37:58.068709", "exception": false, "start_time": "2023-07-17T20:37:49.787705", "status": "completed"} tags=[]
for x in contour_plots:
    data = get_result_data([x['name']], [benchmark_id], x['columns'])

    levelset_plot(
        data,
        layout=x['layout'],
        mask_func=lambda df: (x['mask_z'][0] < df.z) & (df.z < x['mask_z'][1]),
        columns=x['columns']
    ).show()
```

```python papermill={"duration": 2.053771, "end_time": "2023-07-17T20:38:00.311357", "exception": false, "start_time": "2023-07-17T20:37:58.257586", "status": "completed"} tags=[]
if efficiency:
    efficiency_plot(benchmark_id).show()
    display_markdown("<span class='plotly-footnote' >* Wall time divided by the total simulated time.</span>", raw=True)

```

```python papermill={"duration": 0.213553, "end_time": "2023-07-17T20:38:00.797049", "exception": false, "start_time": "2023-07-17T20:38:00.583496", "status": "completed"} tags=[]
display_markdown(f'''
# Table of Results

Table of { benchmark_id } benchmark result uploads.
''', raw=True)
```

```python papermill={"duration": 0.212319, "end_time": "2023-07-17T20:38:01.212268", "exception": false, "start_time": "2023-07-17T20:38:00.999949", "status": "completed"} tags=[]

```

```python papermill={"duration": 1.223144, "end_time": "2023-07-17T20:38:02.637041", "exception": false, "start_time": "2023-07-17T20:38:01.413897", "status": "completed"} tags=[]
## Currently switching off interactive tables as these are not converted to HTML properly.
## This might improve when jupyter-nbcovert is updated to a later version.

init_notebook_mode(all_interactive=False)
get_table_data_style(benchmark_id, pfhub_path='../..')
```

```python papermill={"duration": 0.188529, "end_time": "2023-07-17T20:38:03.020460", "exception": false, "start_time": "2023-07-17T20:38:02.831931", "status": "completed"} tags=[]

```
