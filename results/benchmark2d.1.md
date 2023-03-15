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

```python papermill={"duration": 0.012747, "end_time": "2023-03-14T23:15:06.840049", "exception": false, "start_time": "2023-03-14T23:15:06.827302", "status": "completed"} tags=["parameters"]
benchmark_id = '3a.1'
line_plots = [
    dict(name='free_energy', layout=dict(log_y=True, x_label=r'<i>t</i>', y_label=r'&#8497;', range_y=[1.8e6, 2.4e6], title="Free Energy v Time")),
    dict(name='solid_fraction', layout=dict(log_y=True, x_label=r'<i>t</i>')),
    dict(name='tip_position', layout=dict(log_y=True, x_label=r'<i>t</i>')),
    dict(name='phase_field_1500', layout=dict(aspect_ratio=1.0))
]
```

```python papermill={"duration": 0.008141, "end_time": "2023-03-14T23:15:06.850388", "exception": false, "start_time": "2023-03-14T23:15:06.842247", "status": "completed"} tags=["injected-parameters"]
# Parameters
benchmark_id = "2d.1"
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

```python papermill={"duration": 0.00905, "end_time": "2023-03-14T23:15:06.861191", "exception": false, "start_time": "2023-03-14T23:15:06.852141", "status": "completed"} tags=[]
from IPython.display import display_markdown

display_markdown(f'''
# Benchmark { benchmark_id } Results

All results for the [{ benchmark_id } benchmark specification](../../benchmarks/benchmark{ benchmark_id }.ipynb/).
''', raw=True)
```

```python papermill={"duration": 0.007544, "end_time": "2023-03-14T23:15:06.870626", "exception": false, "start_time": "2023-03-14T23:15:06.863082", "status": "completed"} tags=[]
# To generate the comparison notebooks use:
# 
# papermill template.ipynb benchmark{version}.ipynb -f bm{version}.yaml
#
```

```python papermill={"duration": 0.012068, "end_time": "2023-03-14T23:15:06.884523", "exception": false, "start_time": "2023-03-14T23:15:06.872455", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.667509, "end_time": "2023-03-14T23:15:07.554112", "exception": false, "start_time": "2023-03-14T23:15:06.886603", "status": "completed"} tags=[]
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

```python papermill={"duration": 4.450574, "end_time": "2023-03-14T23:15:12.007142", "exception": false, "start_time": "2023-03-14T23:15:07.556568", "status": "completed"} tags=[]
for x in line_plots:
    line_plot(
        data_name=x['name'],
        benchmark_id=benchmark_id,
        layout=x['layout'],
        columns=x.get('columns', ('x', 'y'))
    ).show()
```

```python papermill={"duration": 2.052546, "end_time": "2023-03-14T23:15:14.180570", "exception": false, "start_time": "2023-03-14T23:15:12.128024", "status": "completed"} tags=[]
efficiency_plot(benchmark_id).show()

display_markdown("<span class='plotly-footnote' >* Wall time divided by the total simulated time.</span>", raw=True)

```

```python papermill={"duration": 0.127443, "end_time": "2023-03-14T23:15:14.411988", "exception": false, "start_time": "2023-03-14T23:15:14.284545", "status": "completed"} tags=[]
display_markdown(f'''
# Table of Results

Table of { benchmark_id } benchmark result uploads.
''', raw=True)
```

```python papermill={"duration": 0.103759, "end_time": "2023-03-14T23:15:14.620671", "exception": false, "start_time": "2023-03-14T23:15:14.516912", "status": "completed"} tags=[]

```

```python papermill={"duration": 1.043915, "end_time": "2023-03-14T23:15:15.787082", "exception": false, "start_time": "2023-03-14T23:15:14.743167", "status": "completed"} tags=[]
## Currently switching off interactive tables as these are not converted to HTML properly.
## This might improve when jupyter-nbcovert is updated to a later version.

init_notebook_mode(all_interactive=False)
get_table_data_style(benchmark_id, pfhub_path='../..')
```

```python papermill={"duration": 0.098157, "end_time": "2023-03-14T23:15:15.989006", "exception": false, "start_time": "2023-03-14T23:15:15.890849", "status": "completed"} tags=[]

```
