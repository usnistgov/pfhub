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

```python papermill={"duration": 0.013456, "end_time": "2023-07-17T20:40:14.524558", "exception": false, "start_time": "2023-07-17T20:40:14.511102", "status": "completed"} tags=["parameters"]
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

```python papermill={"duration": 0.00843, "end_time": "2023-07-17T20:40:14.538712", "exception": false, "start_time": "2023-07-17T20:40:14.530282", "status": "completed"} tags=["injected-parameters"]
# Parameters
benchmark_id = "2b.1"
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

```python papermill={"duration": 0.010602, "end_time": "2023-07-17T20:40:14.553022", "exception": false, "start_time": "2023-07-17T20:40:14.542420", "status": "completed"} tags=[]
from IPython.display import display_markdown

display_markdown(f'''
# Benchmark { benchmark_id } Results

All results for the [{ benchmark_id } benchmark specification](../../benchmarks/benchmark{ benchmark_id }.ipynb/).
''', raw=True)
```

```python papermill={"duration": 0.007536, "end_time": "2023-07-17T20:40:14.562663", "exception": false, "start_time": "2023-07-17T20:40:14.555127", "status": "completed"} tags=[]
# To generate the comparison notebooks use:
# 
# papermill template.ipynb benchmark{version}.ipynb -f bm{version}.yaml
#
```

```python papermill={"duration": 0.017572, "end_time": "2023-07-17T20:40:14.582314", "exception": false, "start_time": "2023-07-17T20:40:14.564742", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.674068, "end_time": "2023-07-17T20:40:15.258911", "exception": false, "start_time": "2023-07-17T20:40:14.584843", "status": "completed"} tags=[]
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

```python papermill={"duration": 3.844435, "end_time": "2023-07-17T20:40:19.111060", "exception": false, "start_time": "2023-07-17T20:40:15.266625", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.07374, "end_time": "2023-07-17T20:40:19.252591", "exception": false, "start_time": "2023-07-17T20:40:19.178851", "status": "completed"} tags=[]
for x in contour_plots:
    data = get_result_data([x['name']], [benchmark_id], x['columns'])

    levelset_plot(
        data,
        layout=x['layout'],
        mask_func=lambda df: (x['mask_z'][0] < df.z) & (df.z < x['mask_z'][1]),
        columns=x['columns']
    ).show()
```

```python papermill={"duration": 2.005167, "end_time": "2023-07-17T20:40:21.323233", "exception": false, "start_time": "2023-07-17T20:40:19.318066", "status": "completed"} tags=[]
if efficiency:
    efficiency_plot(benchmark_id).show()
    display_markdown("<span class='plotly-footnote' >* Wall time divided by the total simulated time.</span>", raw=True)

```

```python papermill={"duration": 0.072643, "end_time": "2023-07-17T20:40:21.459595", "exception": false, "start_time": "2023-07-17T20:40:21.386952", "status": "completed"} tags=[]
display_markdown(f'''
# Table of Results

Table of { benchmark_id } benchmark result uploads.
''', raw=True)
```

```python papermill={"duration": 0.067161, "end_time": "2023-07-17T20:40:21.590841", "exception": false, "start_time": "2023-07-17T20:40:21.523680", "status": "completed"} tags=[]

```

```python papermill={"duration": 1.012487, "end_time": "2023-07-17T20:40:22.671975", "exception": false, "start_time": "2023-07-17T20:40:21.659488", "status": "completed"} tags=[]
## Currently switching off interactive tables as these are not converted to HTML properly.
## This might improve when jupyter-nbcovert is updated to a later version.

init_notebook_mode(all_interactive=False)
get_table_data_style(benchmark_id, pfhub_path='../..')
```

```python papermill={"duration": 0.064453, "end_time": "2023-07-17T20:40:22.800690", "exception": false, "start_time": "2023-07-17T20:40:22.736237", "status": "completed"} tags=[]

```
