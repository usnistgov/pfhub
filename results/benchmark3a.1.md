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

```python papermill={"duration": 0.013611, "end_time": "2023-08-04T15:36:24.104375", "exception": false, "start_time": "2023-08-04T15:36:24.090764", "status": "completed"} tags=["parameters"]
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

```python papermill={"duration": 0.009349, "end_time": "2023-08-04T15:36:24.115980", "exception": false, "start_time": "2023-08-04T15:36:24.106631", "status": "completed"} tags=["injected-parameters"]
# Parameters
benchmark_id = "3a.1"
line_plots = [
    {
        "name": "free_energy",
        "layout": {
            "log_y": True,
            "x_label": "Simulated Time, <i>t</i><sub>Sim</sub>&nbsp;[a.u.]",
            "y_label": "Simulated Free Energy, &#8497;&nbsp;[a.u.]",
            "title": "",
            "range_y": [1900000.0, 2200000.0],
        },
    },
    {
        "name": "solid_fraction",
        "layout": {
            "y_label": "Solid Fraction, [a.u.]",
            "x_label": "Simulated Time, <i>t</i><sub>Sim</sub>&nbsp;[a.u.]",
            "title": "",
        },
    },
    {
        "name": "tip_position",
        "layout": {
            "y_label": "Tip Position, [a.u.]",
            "x_label": "Simulated Time, <i>t</i><sub>Sim</sub>&nbsp;[a.u.]",
            "title": "",
        },
    },
    {
        "name": "phase_field_1500",
        "layout": {"title": "Solid / Liquid Boundary at t=1500", "aspect_ratio": 1.0},
    },
]

```

```python papermill={"duration": 0.009369, "end_time": "2023-08-04T15:36:24.127658", "exception": false, "start_time": "2023-08-04T15:36:24.118289", "status": "completed"} tags=[]
from IPython.display import display_markdown

display_markdown(f'''
# Benchmark { benchmark_id } Results

All results for the [{ benchmark_id } benchmark specification](../../benchmarks/benchmark{ benchmark_id }.ipynb/).
''', raw=True)
```

```python papermill={"duration": 0.007604, "end_time": "2023-08-04T15:36:24.137744", "exception": false, "start_time": "2023-08-04T15:36:24.130140", "status": "completed"} tags=[]
# To generate the comparison notebooks use:
#
# papermill template.ipynb benchmark{version}.ipynb -f bm{version}.yaml
#
```

```python papermill={"duration": 0.011226, "end_time": "2023-08-04T15:36:24.151330", "exception": false, "start_time": "2023-08-04T15:36:24.140104", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.601082, "end_time": "2023-08-04T15:36:24.755019", "exception": false, "start_time": "2023-08-04T15:36:24.153937", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.007479, "end_time": "2023-08-04T15:36:24.765391", "exception": false, "start_time": "2023-08-04T15:36:24.757912", "status": "completed"} tags=[]
from pathlib import Path

cwd = Path().resolve()
benchmark_path = f'{cwd}/../_data/simulation_list.yaml'
```

```python papermill={"duration": 6.066676, "end_time": "2023-08-04T15:36:30.834411", "exception": false, "start_time": "2023-08-04T15:36:24.767735", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.184215, "end_time": "2023-08-04T15:36:31.194743", "exception": false, "start_time": "2023-08-04T15:36:31.010528", "status": "completed"} tags=[]
for x in contour_plots:
    data = get_result_data([x['name']], [benchmark_id], x['columns'], benchmark_path=benchmark_path)

    levelset_plot(
        data,
        layout=x['layout'],
        mask_func=lambda df: (x['mask_z'][0] < df.z) & (df.z < x['mask_z'][1]),
        columns=x['columns']
    ).show()
```

```python papermill={"duration": 1.984897, "end_time": "2023-08-04T15:36:33.347815", "exception": false, "start_time": "2023-08-04T15:36:31.362918", "status": "completed"} tags=[]
if efficiency:
    efficiency_plot(benchmark_id, benchmark_path=benchmark_path).show()
    display_markdown("<span class='plotly-footnote' >* Wall time divided by the total simulated time.</span>", raw=True)
```

```python papermill={"duration": 0.183657, "end_time": "2023-08-04T15:36:33.715740", "exception": false, "start_time": "2023-08-04T15:36:33.532083", "status": "completed"} tags=[]
display_markdown(f'''
# Table of Results

Table of { benchmark_id } benchmark result uploads.
''', raw=True)
```

```python papermill={"duration": 0.174948, "end_time": "2023-08-04T15:36:34.069875", "exception": false, "start_time": "2023-08-04T15:36:33.894927", "status": "completed"} tags=[]

```

```python papermill={"duration": 1.206314, "end_time": "2023-08-04T15:36:35.450861", "exception": false, "start_time": "2023-08-04T15:36:34.244547", "status": "completed"} tags=[]
## Currently switching off interactive tables as these are not converted to HTML properly.
## This might improve when jupyter-nbcovert is updated to a later version.

init_notebook_mode(all_interactive=False)
get_table_data_style(benchmark_id, pfhub_path='../..', benchmark_path=benchmark_path)
```

```python papermill={"duration": 0.18856, "end_time": "2023-08-04T15:36:35.844813", "exception": false, "start_time": "2023-08-04T15:36:35.656253", "status": "completed"} tags=[]

```
