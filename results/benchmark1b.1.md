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

```python papermill={"duration": 0.0119, "end_time": "2023-03-14T23:15:19.612093", "exception": false, "start_time": "2023-03-14T23:15:19.600193", "status": "completed"} tags=["parameters"]
benchmark_id = '3a.1'
line_plots = [
    dict(name='free_energy', layout=dict(log_y=True, x_label=r'<i>t</i>', y_label=r'&#8497;', range_y=[1.8e6, 2.4e6], title="Free Energy v Time")),
    dict(name='solid_fraction', layout=dict(log_y=True, x_label=r'<i>t</i>')),
    dict(name='tip_position', layout=dict(log_y=True, x_label=r'<i>t</i>')),
    dict(name='phase_field_1500', layout=dict(aspect_ratio=1.0))
]
```

```python papermill={"duration": 0.007376, "end_time": "2023-03-14T23:15:19.621725", "exception": false, "start_time": "2023-03-14T23:15:19.614349", "status": "completed"} tags=["injected-parameters"]
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

```python papermill={"duration": 0.009881, "end_time": "2023-03-14T23:15:19.633337", "exception": false, "start_time": "2023-03-14T23:15:19.623456", "status": "completed"} tags=[]
from IPython.display import display_markdown

display_markdown(f'''
# Benchmark { benchmark_id } Results

All results for the [{ benchmark_id } benchmark specification](../../benchmarks/benchmark{ benchmark_id }.ipynb/).
''', raw=True)
```

```python papermill={"duration": 0.007116, "end_time": "2023-03-14T23:15:19.642400", "exception": false, "start_time": "2023-03-14T23:15:19.635284", "status": "completed"} tags=[]
# To generate the comparison notebooks use:
# 
# papermill template.ipynb benchmark{version}.ipynb -f bm{version}.yaml
#
```

```python papermill={"duration": 0.01249, "end_time": "2023-03-14T23:15:19.656762", "exception": false, "start_time": "2023-03-14T23:15:19.644272", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.618143, "end_time": "2023-03-14T23:15:20.277008", "exception": false, "start_time": "2023-03-14T23:15:19.658865", "status": "completed"} tags=[]
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

```python papermill={"duration": 8.248587, "end_time": "2023-03-14T23:15:28.528025", "exception": false, "start_time": "2023-03-14T23:15:20.279438", "status": "completed"} tags=[]
for x in line_plots:
    line_plot(
        data_name=x['name'],
        benchmark_id=benchmark_id,
        layout=x['layout'],
        columns=x.get('columns', ('x', 'y'))
    ).show()
```

```python papermill={"duration": 2.0242, "end_time": "2023-03-14T23:15:30.657982", "exception": false, "start_time": "2023-03-14T23:15:28.633782", "status": "completed"} tags=[]
efficiency_plot(benchmark_id).show()

display_markdown("<span class='plotly-footnote' >* Wall time divided by the total simulated time.</span>", raw=True)

```

```python papermill={"duration": 0.114061, "end_time": "2023-03-14T23:15:30.882142", "exception": false, "start_time": "2023-03-14T23:15:30.768081", "status": "completed"} tags=[]
display_markdown(f'''
# Table of Results

Table of { benchmark_id } benchmark result uploads.
''', raw=True)
```

```python papermill={"duration": 0.118401, "end_time": "2023-03-14T23:15:31.118926", "exception": false, "start_time": "2023-03-14T23:15:31.000525", "status": "completed"} tags=[]

```

```python papermill={"duration": 1.066946, "end_time": "2023-03-14T23:15:32.307420", "exception": false, "start_time": "2023-03-14T23:15:31.240474", "status": "completed"} tags=[]
## Currently switching off interactive tables as these are not converted to HTML properly.
## This might improve when jupyter-nbcovert is updated to a later version.

init_notebook_mode(all_interactive=False)
get_table_data_style(benchmark_id, pfhub_path='../..')
```

```python papermill={"duration": 0.10677, "end_time": "2023-03-14T23:15:32.523289", "exception": false, "start_time": "2023-03-14T23:15:32.416519", "status": "completed"} tags=[]

```
