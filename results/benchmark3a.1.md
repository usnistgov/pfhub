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

```python papermill={"duration": 0.016743, "end_time": "2023-03-15T16:05:07.220154", "exception": false, "start_time": "2023-03-15T16:05:07.203411", "status": "completed"} tags=["parameters"]
benchmark_id = '3a.1'
line_plots = [
    dict(name='free_energy', layout=dict(log_y=True, x_label=r'<i>t</i>', y_label=r'&#8497;', range_y=[1.8e6, 2.4e6], title="Free Energy v Time")),
    dict(name='solid_fraction', layout=dict(log_y=True, x_label=r'<i>t</i>')),
    dict(name='tip_position', layout=dict(log_y=True, x_label=r'<i>t</i>')),
    dict(name='phase_field_1500', layout=dict(aspect_ratio=1.0))
]
contour_plots = []
```

```python papermill={"duration": 0.011362, "end_time": "2023-03-15T16:05:07.234680", "exception": false, "start_time": "2023-03-15T16:05:07.223318", "status": "completed"} tags=["injected-parameters"]
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

```python papermill={"duration": 0.011733, "end_time": "2023-03-15T16:05:07.251545", "exception": false, "start_time": "2023-03-15T16:05:07.239812", "status": "completed"} tags=[]
from IPython.display import display_markdown

display_markdown(f'''
# Benchmark { benchmark_id } Results

All results for the [{ benchmark_id } benchmark specification](../../benchmarks/benchmark{ benchmark_id }.ipynb/).
''', raw=True)
```

```python papermill={"duration": 0.008771, "end_time": "2023-03-15T16:05:07.264992", "exception": false, "start_time": "2023-03-15T16:05:07.256221", "status": "completed"} tags=[]
# To generate the comparison notebooks use:
# 
# papermill template.ipynb benchmark{version}.ipynb -f bm{version}.yaml
#
```

```python papermill={"duration": 0.019501, "end_time": "2023-03-15T16:05:07.287411", "exception": false, "start_time": "2023-03-15T16:05:07.267910", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.834673, "end_time": "2023-03-15T16:05:08.125309", "exception": false, "start_time": "2023-03-15T16:05:07.290636", "status": "completed"} tags=[]
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

```python papermill={"duration": 8.908477, "end_time": "2023-03-15T16:05:17.037460", "exception": false, "start_time": "2023-03-15T16:05:08.128983", "status": "completed"} tags=[]
for x in line_plots:
    line_plot(
        data_name=x['name'],
        benchmark_id=benchmark_id,
        layout=x['layout'],
        columns=x.get('columns', ('x', 'y'))
    ).show()
```

```python papermill={"duration": 0.249423, "end_time": "2023-03-15T16:05:17.542104", "exception": false, "start_time": "2023-03-15T16:05:17.292681", "status": "completed"} tags=[]
for x in contour_plots:
    data = get_result_data([x['name']], [benchmark_id], x['columns'])

    levelset_plot(
        data,
        layout=x['layout'],
        mask_func=lambda df: (x['mask_z'][0] < df.z) & (df.z < x['mask_z'][1]),
        columns=x['columns']
    ).show()
```

```python papermill={"duration": 2.885841, "end_time": "2023-03-15T16:05:20.656608", "exception": false, "start_time": "2023-03-15T16:05:17.770767", "status": "completed"} tags=[]
efficiency_plot(benchmark_id).show()

display_markdown("<span class='plotly-footnote' >* Wall time divided by the total simulated time.</span>", raw=True)

```

```python papermill={"duration": 0.246179, "end_time": "2023-03-15T16:05:21.141918", "exception": false, "start_time": "2023-03-15T16:05:20.895739", "status": "completed"} tags=[]
display_markdown(f'''
# Table of Results

Table of { benchmark_id } benchmark result uploads.
''', raw=True)
```

```python papermill={"duration": 0.293609, "end_time": "2023-03-15T16:05:21.701929", "exception": false, "start_time": "2023-03-15T16:05:21.408320", "status": "completed"} tags=[]

```

```python papermill={"duration": 1.570986, "end_time": "2023-03-15T16:05:23.514507", "exception": false, "start_time": "2023-03-15T16:05:21.943521", "status": "completed"} tags=[]
## Currently switching off interactive tables as these are not converted to HTML properly.
## This might improve when jupyter-nbcovert is updated to a later version.

init_notebook_mode(all_interactive=False)
get_table_data_style(benchmark_id, pfhub_path='../..')
```

```python papermill={"duration": 0.267376, "end_time": "2023-03-15T16:05:24.080548", "exception": false, "start_time": "2023-03-15T16:05:23.813172", "status": "completed"} tags=[]

```
