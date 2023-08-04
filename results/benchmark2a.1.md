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

```python papermill={"duration": 0.04494, "end_time": "2023-08-04T15:21:53.526580", "exception": false, "start_time": "2023-08-04T15:21:53.481640", "status": "completed"} tags=["parameters"]
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

```python papermill={"duration": 0.018082, "end_time": "2023-08-04T15:21:53.552809", "exception": false, "start_time": "2023-08-04T15:21:53.534727", "status": "completed"} tags=["injected-parameters"]
# Parameters
benchmark_id = "2a.1"
line_plots = [
    {
        "name": "free_energy",
        "layout": {
            "log_y": True,
            "log_x": True,
            "x_label": "Simulated Time, <i>t</i><sub>Sim</sub>&nbsp;[a.u.]",
            "y_label": "Simulated Free Energy, &#8497;&nbsp;[a.u.]",
            "title": "",
        },
    }
]

```

```python papermill={"duration": 0.008146, "end_time": "2023-08-04T15:21:53.564895", "exception": false, "start_time": "2023-08-04T15:21:53.556749", "status": "completed"} tags=[]
from IPython.display import display_markdown

display_markdown(f'''
# Benchmark { benchmark_id } Results

All results for the [{ benchmark_id } benchmark specification](../../benchmarks/benchmark{ benchmark_id }.ipynb/).
''', raw=True)
```

```python papermill={"duration": 0.006868, "end_time": "2023-08-04T15:21:53.573692", "exception": false, "start_time": "2023-08-04T15:21:53.566824", "status": "completed"} tags=[]
# To generate the comparison notebooks use:
#
# papermill template.ipynb benchmark{version}.ipynb -f bm{version}.yaml
#
```

```python papermill={"duration": 0.009717, "end_time": "2023-08-04T15:21:53.585191", "exception": false, "start_time": "2023-08-04T15:21:53.575474", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.57005, "end_time": "2023-08-04T15:21:54.157365", "exception": false, "start_time": "2023-08-04T15:21:53.587315", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.010846, "end_time": "2023-08-04T15:21:54.170543", "exception": false, "start_time": "2023-08-04T15:21:54.159697", "status": "completed"} tags=[]
from pathlib import Path

cwd = Path().resolve()
benchmark_path = f'{cwd}/../_data/simulation_list.yaml'
```

```python papermill={"duration": 4.166758, "end_time": "2023-08-04T15:21:58.339346", "exception": false, "start_time": "2023-08-04T15:21:54.172588", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.068117, "end_time": "2023-08-04T15:21:58.469452", "exception": false, "start_time": "2023-08-04T15:21:58.401335", "status": "completed"} tags=[]
for x in contour_plots:
    data = get_result_data([x['name']], [benchmark_id], x['columns'], benchmark_path=benchmark_path)

    levelset_plot(
        data,
        layout=x['layout'],
        mask_func=lambda df: (x['mask_z'][0] < df.z) & (df.z < x['mask_z'][1]),
        columns=x['columns']
    ).show()
```

```python papermill={"duration": 1.970246, "end_time": "2023-08-04T15:22:00.504861", "exception": false, "start_time": "2023-08-04T15:21:58.534615", "status": "completed"} tags=[]
if efficiency:
    efficiency_plot(benchmark_id, benchmark_path=benchmark_path).show()
    display_markdown("<span class='plotly-footnote' >* Wall time divided by the total simulated time.</span>", raw=True)
```

```python papermill={"duration": 0.074046, "end_time": "2023-08-04T15:22:00.653624", "exception": false, "start_time": "2023-08-04T15:22:00.579578", "status": "completed"} tags=[]
display_markdown(f'''
# Table of Results

Table of { benchmark_id } benchmark result uploads.
''', raw=True)
```

```python papermill={"duration": 0.0683, "end_time": "2023-08-04T15:22:00.791245", "exception": false, "start_time": "2023-08-04T15:22:00.722945", "status": "completed"} tags=[]

```

```python papermill={"duration": 0.956205, "end_time": "2023-08-04T15:22:01.814077", "exception": false, "start_time": "2023-08-04T15:22:00.857872", "status": "completed"} tags=[]
## Currently switching off interactive tables as these are not converted to HTML properly.
## This might improve when jupyter-nbcovert is updated to a later version.

init_notebook_mode(all_interactive=False)
get_table_data_style(benchmark_id, pfhub_path='../..', benchmark_path=benchmark_path)
```

```python papermill={"duration": 0.067229, "end_time": "2023-08-04T15:22:01.950829", "exception": false, "start_time": "2023-08-04T15:22:01.883600", "status": "completed"} tags=[]

```
