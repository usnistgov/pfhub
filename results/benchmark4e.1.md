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

```python papermill={"duration": 0.01209, "end_time": "2023-03-15T00:19:46.752161", "exception": false, "start_time": "2023-03-15T00:19:46.740071", "status": "completed"} tags=["parameters"]
benchmark_id = '3a.1'
line_plots = [
    dict(name='free_energy', layout=dict(log_y=True, x_label=r'<i>t</i>', y_label=r'&#8497;', range_y=[1.8e6, 2.4e6], title="Free Energy v Time")),
    dict(name='solid_fraction', layout=dict(log_y=True, x_label=r'<i>t</i>')),
    dict(name='tip_position', layout=dict(log_y=True, x_label=r'<i>t</i>')),
    dict(name='phase_field_1500', layout=dict(aspect_ratio=1.0))
]
```

```python papermill={"duration": 0.013357, "end_time": "2023-03-15T00:19:46.768096", "exception": false, "start_time": "2023-03-15T00:19:46.754739", "status": "completed"} tags=["injected-parameters"]
# Parameters
benchmark_id = "4e.1"
line_plots = [
    {
        "name": "all_data",
        "layout": {
            "x_label": "Fictive Time, <i>t</i><sub>aim</sub>&nbsp;[a.u.]",
            "y_label": "Free Energy, &#8497;&nbsp;[aJ]",
            "title": "",
            "log_x": True,
        },
    },
    {
        "name": "all_data",
        "columns": ["time", "elastic_free_energy"],
        "layout": {
            "x_label": "Fictive Time, <i>t</i><sub>sim</sub>&nbsp;[a.u.]",
            "y_label": "Elastic Free Energy, &#8497;&nbsp;[aJ]",
            "title": "",
            "log_x": True,
        },
    },
    {
        "name": "all_data",
        "columns": ["time", "a_10"],
        "layout": {
            "x_label": "Fictive Time, <i>t</i><sub>sim</sub>&nbsp;[a.u.]",
            "y_label": "Precipitate Length, <i>a</i><sub>10</sub>&nbsp;[nm]",
            "title": "",
            "log_x": True,
        },
    },
    {
        "name": "all_data",
        "columns": ["time", "a_01"],
        "layout": {
            "x_label": "Fictive Time, <i>t</i><sub>sim</sub>&nbsp;[a.u.]",
            "y_label": "Precipitate Length, <i>a</i><sub>01</sub>&nbsp;[nm]",
            "title": "",
            "log_x": True,
        },
    },
    {
        "name": "all_data",
        "columns": ["time", "a_d"],
        "layout": {
            "x_label": "Fictive Time, <i>t</i><sub>sim</sub>&nbsp;[aJ]",
            "y_label": "Precipitate Length, <i>a</i><sub>d</sub>&nbsp;[nm]",
            "title": "",
            "log_x": True,
        },
    },
    {
        "name": "all_data",
        "columns": ["time", "elastic_free_energy"],
        "layout": {
            "x_label": "Fictive Time, <i>t</i><sub>sim</sub>&nbsp;[a.u.]",
            "y_label": "Normalized Elastic Energy, <i>g</i><sub>el</sub><sup>avg</sub>&nbsp;[aJ/nm<sup>2</sup>]",
            "title": "",
            "log_x": True,
        },
    },
    {
        "name": "contour",
        "layout": {
            "title": "Precipitate Boundary at Equilibrium",
            "log_x": True,
            "x_label": "x, [nm]",
            "y_label": "y, [nm]",
            "aspect_ratio": 1.0,
        },
    },
]

```

```python papermill={"duration": 0.010284, "end_time": "2023-03-15T00:19:46.780640", "exception": false, "start_time": "2023-03-15T00:19:46.770356", "status": "completed"} tags=[]
from IPython.display import display_markdown

display_markdown(f'''
# Benchmark { benchmark_id } Results

All results for the [{ benchmark_id } benchmark specification](../../benchmarks/benchmark{ benchmark_id }.ipynb/).
''', raw=True)
```

```python papermill={"duration": 0.008218, "end_time": "2023-03-15T00:19:46.791306", "exception": false, "start_time": "2023-03-15T00:19:46.783088", "status": "completed"} tags=[]
# To generate the comparison notebooks use:
# 
# papermill template.ipynb benchmark{version}.ipynb -f bm{version}.yaml
#
```

```python papermill={"duration": 0.015781, "end_time": "2023-03-15T00:19:46.809710", "exception": false, "start_time": "2023-03-15T00:19:46.793929", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.631071, "end_time": "2023-03-15T00:19:47.443370", "exception": false, "start_time": "2023-03-15T00:19:46.812299", "status": "completed"} tags=[]
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

```python papermill={"duration": 9.339267, "end_time": "2023-03-15T00:19:56.785541", "exception": false, "start_time": "2023-03-15T00:19:47.446274", "status": "completed"} tags=[]
for x in line_plots:
    line_plot(
        data_name=x['name'],
        benchmark_id=benchmark_id,
        layout=x['layout'],
        columns=x.get('columns', ('x', 'y'))
    ).show()
```

```python papermill={"duration": 1.840735, "end_time": "2023-03-15T00:19:58.680011", "exception": false, "start_time": "2023-03-15T00:19:56.839276", "status": "completed"} tags=[]
efficiency_plot(benchmark_id).show()

display_markdown("<span class='plotly-footnote' >* Wall time divided by the total simulated time.</span>", raw=True)

```

```python papermill={"duration": 0.061542, "end_time": "2023-03-15T00:19:58.793663", "exception": false, "start_time": "2023-03-15T00:19:58.732121", "status": "completed"} tags=[]
display_markdown(f'''
# Table of Results

Table of { benchmark_id } benchmark result uploads.
''', raw=True)
```

```python papermill={"duration": 0.051727, "end_time": "2023-03-15T00:19:58.918284", "exception": false, "start_time": "2023-03-15T00:19:58.866557", "status": "completed"} tags=[]

```

```python papermill={"duration": 1.008668, "end_time": "2023-03-15T00:19:59.978460", "exception": false, "start_time": "2023-03-15T00:19:58.969792", "status": "completed"} tags=[]
## Currently switching off interactive tables as these are not converted to HTML properly.
## This might improve when jupyter-nbcovert is updated to a later version.

init_notebook_mode(all_interactive=False)
get_table_data_style(benchmark_id, pfhub_path='../..')
```

```python papermill={"duration": 0.049886, "end_time": "2023-03-15T00:20:00.110228", "exception": false, "start_time": "2023-03-15T00:20:00.060342", "status": "completed"} tags=[]

```
