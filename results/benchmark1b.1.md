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

```python papermill={"duration": 0.026347, "end_time": "2023-03-07T17:19:41.523290", "exception": false, "start_time": "2023-03-07T17:19:41.496943", "status": "completed"} tags=["parameters"]
benchmark_id = '3a.1'
line_plots = [
    dict(name='free_energy', layout=dict(log_y=True, x_label=r'<i>t</i>', y_label=r'&#8497;', range_y=[1.8e6, 2.4e6], title="Free Energy v Time")),
    dict(name='solid_fraction', layout=dict(log_y=True, x_label=r'<i>t</i>')),
    dict(name='tip_position', layout=dict(log_y=True, x_label=r'<i>t</i>')),
    dict(name='phase_field_1500', layout=dict(aspect_ratio=1.0))
]
```

```python papermill={"duration": 0.024728, "end_time": "2023-03-07T17:19:41.556450", "exception": false, "start_time": "2023-03-07T17:19:41.531722", "status": "completed"} tags=["injected-parameters"]
# Parameters
benchmark_id = "1b.1"
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

```python papermill={"duration": 0.010261, "end_time": "2023-03-07T17:19:41.571228", "exception": false, "start_time": "2023-03-07T17:19:41.560967", "status": "completed"} tags=[]
from IPython.display import display_markdown

display_markdown(f'''
# Benchmark { benchmark_id } Results

All results for the [{ benchmark_id } benchmark specification](../../benchmarks/benchmark{ benchmark_id }.ipynb/).
''', raw=True)
```

```python papermill={"duration": 0.007022, "end_time": "2023-03-07T17:19:41.580454", "exception": false, "start_time": "2023-03-07T17:19:41.573432", "status": "completed"} tags=[]
# To generate the comparison notebooks use:
# 
# papermill template.ipynb benchmark{version}.ipynb -f bm{version}.yaml
#
```

```python papermill={"duration": 0.011622, "end_time": "2023-03-07T17:19:41.594010", "exception": false, "start_time": "2023-03-07T17:19:41.582388", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.641714, "end_time": "2023-03-07T17:19:42.237656", "exception": false, "start_time": "2023-03-07T17:19:41.595942", "status": "completed"} tags=[]
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

```python papermill={"duration": 3.277363, "end_time": "2023-03-07T17:19:45.517430", "exception": false, "start_time": "2023-03-07T17:19:42.240067", "status": "completed"} tags=[]
for x in line_plots:
    line_plot(
        data_name=x['name'],
        benchmark_id=benchmark_id,
        layout=x['layout'],
    ).show()
```

```python papermill={"duration": 2.06947, "end_time": "2023-03-07T17:19:47.689863", "exception": false, "start_time": "2023-03-07T17:19:45.620393", "status": "completed"} tags=[]
efficiency_plot(benchmark_id).show()

display_markdown("<span class='plotly-footnote' >* Wall time divided by the total simulated time.</span>", raw=True)

```

```python papermill={"duration": 0.108256, "end_time": "2023-03-07T17:19:47.904188", "exception": false, "start_time": "2023-03-07T17:19:47.795932", "status": "completed"} tags=[]
display_markdown(f'''
# Table of Results

Table of { benchmark_id } benchmark result uploads.
''', raw=True)
```

```python papermill={"duration": 0.112736, "end_time": "2023-03-07T17:19:48.122156", "exception": false, "start_time": "2023-03-07T17:19:48.009420", "status": "completed"} tags=[]

```

```python papermill={"duration": 1.018454, "end_time": "2023-03-07T17:19:49.247771", "exception": false, "start_time": "2023-03-07T17:19:48.229317", "status": "completed"} tags=[]
## Currently switching off interactive tables as these are not converted to HTML properly.
## This might improve when jupyter-nbcovert is updated to a later version.

init_notebook_mode(all_interactive=False)
get_table_data_style(benchmark_id, pfhub_path='../..')
```

```python papermill={"duration": 0.11134, "end_time": "2023-03-07T17:19:49.466684", "exception": false, "start_time": "2023-03-07T17:19:49.355344", "status": "completed"} tags=[]

```
