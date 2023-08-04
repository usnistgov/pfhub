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

```python papermill={"duration": 0.023877, "end_time": "2023-08-03T20:08:19.028733", "exception": false, "start_time": "2023-08-03T20:08:19.004856", "status": "completed"} tags=["parameters"]
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

```python papermill={"duration": 0.009722, "end_time": "2023-08-03T20:08:19.040807", "exception": false, "start_time": "2023-08-03T20:08:19.031085", "status": "completed"} tags=["injected-parameters"]
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

```python papermill={"duration": 0.007382, "end_time": "2023-08-03T20:08:19.050331", "exception": false, "start_time": "2023-08-03T20:08:19.042949", "status": "completed"} tags=[]
from IPython.display import display_markdown

display_markdown(f'''
# Benchmark { benchmark_id } Results

All results for the [{ benchmark_id } benchmark specification](../../benchmarks/benchmark{ benchmark_id }.ipynb/).
''', raw=True)
```

```python papermill={"duration": 0.006104, "end_time": "2023-08-03T20:08:19.059490", "exception": false, "start_time": "2023-08-03T20:08:19.053386", "status": "completed"} tags=[]
# To generate the comparison notebooks use:
#
# papermill template.ipynb benchmark{version}.ipynb -f bm{version}.yaml
#
```

```python papermill={"duration": 0.00911, "end_time": "2023-08-03T20:08:19.070940", "exception": false, "start_time": "2023-08-03T20:08:19.061830", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.565868, "end_time": "2023-08-03T20:08:19.639185", "exception": false, "start_time": "2023-08-03T20:08:19.073317", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.010487, "end_time": "2023-08-03T20:08:19.652457", "exception": false, "start_time": "2023-08-03T20:08:19.641970", "status": "completed"} tags=[]
from pathlib import Path

cwd = Path().resolve()
benchmark_path = f'{cwd}/../_data/simulation_list.yaml'
```

```python papermill={"duration": 31.913648, "end_time": "2023-08-03T20:08:51.568761", "exception": false, "start_time": "2023-08-03T20:08:19.655113", "status": "completed"} tags=[]
colors = dict()

for x in line_plots:
    fig = line_plot(
        data_name=x['name'],
        benchmark_id=benchmark_id,
        layout=x['layout'],
        columns=x.get('columns', ('x', 'y')),
        benchmark_path=benchmark_path
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

```python papermill={"duration": 7.451691, "end_time": "2023-08-03T20:08:59.126499", "exception": false, "start_time": "2023-08-03T20:08:51.674808", "status": "completed"} tags=[]
for x in contour_plots:
    data = get_result_data([x['name']], [benchmark_id], x['columns'], benchmark_path=benchmark_path)

    levelset_plot(
        data,
        layout=x['layout'],
        mask_func=lambda df: (x['mask_z'][0] < df.z) & (df.z < x['mask_z'][1]),
        columns=x['columns']
    ).show()
```

```python papermill={"duration": 1.7621, "end_time": "2023-08-03T20:09:01.063920", "exception": false, "start_time": "2023-08-03T20:08:59.301820", "status": "completed"} tags=[]
if efficiency:
    efficiency_plot(benchmark_id, benchmark_path=benchmark_path).show()
    display_markdown("<span class='plotly-footnote' >* Wall time divided by the total simulated time.</span>", raw=True)
```

```python papermill={"duration": 0.18292, "end_time": "2023-08-03T20:09:01.441863", "exception": false, "start_time": "2023-08-03T20:09:01.258943", "status": "completed"} tags=[]
display_markdown(f'''
# Table of Results

Table of { benchmark_id } benchmark result uploads.
''', raw=True)
```

```python papermill={"duration": 0.192373, "end_time": "2023-08-03T20:09:01.814355", "exception": false, "start_time": "2023-08-03T20:09:01.621982", "status": "completed"} tags=[]

```

```python papermill={"duration": 0.968275, "end_time": "2023-08-03T20:09:02.973044", "exception": false, "start_time": "2023-08-03T20:09:02.004769", "status": "completed"} tags=[]
## Currently switching off interactive tables as these are not converted to HTML properly.
## This might improve when jupyter-nbcovert is updated to a later version.

init_notebook_mode(all_interactive=False)
get_table_data_style(benchmark_id, pfhub_path='../..', benchmark_path=benchmark_path)
```

```python papermill={"duration": 0.181924, "end_time": "2023-08-03T20:09:03.338736", "exception": false, "start_time": "2023-08-03T20:09:03.156812", "status": "completed"} tags=[]

```
