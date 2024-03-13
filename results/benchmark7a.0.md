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

```python papermill={"duration": 0.014038, "end_time": "2023-08-04T15:24:42.037929", "exception": false, "start_time": "2023-08-04T15:24:42.023891", "status": "completed"} tags=["parameters"]
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

```python papermill={"duration": 0.010864, "end_time": "2023-08-04T15:24:42.051442", "exception": false, "start_time": "2023-08-04T15:24:42.040578", "status": "completed"} tags=["injected-parameters"]
# Parameters
benchmark_id = "7a.0"
efficiency = False
line_plots = [
    {
        "name": "temporal",
        "layout": {
            "x_label": "$\\text{Timestep, }k=\\Delta t$",
            "y_label": "$L^2 \\text{ norm of the error, }e_{L2}$",
            "title": "Temporal Accuracy",
            "log_x": True,
            "log_y": True,
        },
        "extra_lines": [
            {
                "opacity": 0.5,
                "x": [0.001, 0.1],
                "y": [0.0001, "1e-2"],
                "mode": "lines",
                "name": "$\\mathcal{O}(k)$",
                "line_color": "black",
                "line": {"dash": "dash"},
            },
            {
                "opacity": 0.5,
                "x": [0.001, 0.1],
                "y": ["1e-6", "1e-2"],
                "mode": "lines",
                "name": "$\\mathcal{O}(k^2)$",
                "line_color": "black",
                "line": {"dash": "dot"},
            },
        ],
    },
    {
        "name": "spatial",
        "layout": {
            "x_label": "$\\text{Mesh resolution, }h=\\Delta x$",
            "y_label": "$L^2 \\text{ norm of the error, }e_{L2}$",
            "title": "Spatial Accuracy",
            "log_x": True,
            "log_y": True,
        },
        "extra_lines": [
            {
                "opacity": 0.5,
                "x": [0.001, 0.01],
                "y": ["1e-4", "1e-3"],
                "mode": "lines",
                "name": "$\\mathcal{O}(h)$",
                "line_color": "black",
                "line": {"dash": "dash"},
            },
            {
                "opacity": 0.5,
                "x": [0.001, 0.01],
                "y": ["1e-5", "1e-3"],
                "mode": "lines",
                "name": "$\\mathcal{O}(h^2)$",
                "line_color": "black",
                "line": {"dash": "dot"},
            },
            {
                "opacity": 0.5,
                "x": [0.001, 0.01],
                "y": ["1e-7", "1e-3"],
                "mode": "lines",
                "name": "$\\mathcal{O}(h^4)$",
                "line_color": "black",
                "line": {"dash": "dashdot"},
            },
        ],
    },
]

```

```python papermill={"duration": 0.01354, "end_time": "2023-08-04T15:24:42.068970", "exception": false, "start_time": "2023-08-04T15:24:42.055430", "status": "completed"} tags=[]
from IPython.display import display_markdown

display_markdown(f'''
# Benchmark { benchmark_id } Results

All results for the [{ benchmark_id } benchmark specification](../../benchmarks/benchmark{ benchmark_id }.ipynb/).
''', raw=True)
```

```python papermill={"duration": 0.009191, "end_time": "2023-08-04T15:24:42.081575", "exception": false, "start_time": "2023-08-04T15:24:42.072384", "status": "completed"} tags=[]
# To generate the comparison notebooks use:
#
# papermill template.ipynb benchmark{version}.ipynb -f bm{version}.yaml
#
```

```python papermill={"duration": 0.012087, "end_time": "2023-08-04T15:24:42.097048", "exception": false, "start_time": "2023-08-04T15:24:42.084961", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.584391, "end_time": "2023-08-04T15:24:42.684580", "exception": false, "start_time": "2023-08-04T15:24:42.100189", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.009506, "end_time": "2023-08-04T15:24:42.696814", "exception": false, "start_time": "2023-08-04T15:24:42.687308", "status": "completed"} tags=[]
from pathlib import Path

cwd = Path().resolve()
benchmark_path = f'{cwd}/../_data/simulation_list.yaml'
```

```python papermill={"duration": 220.085838, "end_time": "2023-08-04T15:28:22.785232", "exception": false, "start_time": "2023-08-04T15:24:42.699394", "status": "completed"} tags=[]
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

```python papermill={"duration": 0.051954, "end_time": "2023-08-04T15:28:22.882568", "exception": false, "start_time": "2023-08-04T15:28:22.830614", "status": "completed"} tags=[]
for x in contour_plots:
    data = get_result_data([x['name']], [benchmark_id], x['columns'], benchmark_path=benchmark_path)

    levelset_plot(
        data,
        layout=x['layout'],
        mask_func=lambda df: (x['mask_z'][0] < df.z) & (df.z < x['mask_z'][1]),
        columns=x['columns']
    ).show()
```

```python papermill={"duration": 0.047718, "end_time": "2023-08-04T15:28:22.975652", "exception": false, "start_time": "2023-08-04T15:28:22.927934", "status": "completed"} tags=[]
if efficiency:
    efficiency_plot(benchmark_id, benchmark_path=benchmark_path).show()
    display_markdown("<span class='plotly-footnote' >* Wall time divided by the total simulated time.</span>", raw=True)
```

```python papermill={"duration": 0.049093, "end_time": "2023-08-04T15:28:23.068898", "exception": false, "start_time": "2023-08-04T15:28:23.019805", "status": "completed"} tags=[]
display_markdown(f'''
# Table of Results

Table of { benchmark_id } benchmark result uploads.
''', raw=True)
```

```python papermill={"duration": 0.045059, "end_time": "2023-08-04T15:28:23.178042", "exception": false, "start_time": "2023-08-04T15:28:23.132983", "status": "completed"} tags=[]

```

```python papermill={"duration": 0.915896, "end_time": "2023-08-04T15:28:24.139424", "exception": false, "start_time": "2023-08-04T15:28:23.223528", "status": "completed"} tags=[]
## Currently switching off interactive tables as these are not converted to HTML properly.
## This might improve when jupyter-nbcovert is updated to a later version.

init_notebook_mode(all_interactive=False)
get_table_data_style(benchmark_id, pfhub_path='../..', benchmark_path=benchmark_path)
```

```python papermill={"duration": 0.049549, "end_time": "2023-08-04T15:28:24.237555", "exception": false, "start_time": "2023-08-04T15:28:24.188006", "status": "completed"} tags=[]

```
