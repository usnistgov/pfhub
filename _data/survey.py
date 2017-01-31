import os

import pandas
from toolz.curried import pipe, curry, map, groupby, get, valmap, count # pylint: disable=redefined-builtin, no-name-in-module

from data_table import j2_to_json

institute_map = {
    'Oak Ridge National Laboratory' : 'ORNL',
    'University of Connecticut' : 'Connecticut',
    'CHiMaD/NIST' : 'NIST',
    'Lawrence Livermore National Laboratory' : 'LLNL',
    'University of Michigan' : 'Michigan',
    'Northwestern University' : 'Northwestern',
}

def make_barchart():
    return pipe(
        os.path.join(os.path.dirname(__file__),
                     'PF4_Install-a-thon_Responses.csv'),
        pandas.read_csv,
        lambda data: list(data.Affiliation[1:]),
        map(lambda item: institute_map.get(item, item)),
        groupby(lambda item: item),
        valmap(count),
        lambda data: list(data.items()),
        lambda data: sorted(data, key=lambda item: (-item[1], item[0])),
        lambda data: j2_to_json(os.path.join(os.path.dirname(__file__),
                                             'charts',
                                             'survey.yaml.j2'),
                                os.path.join(os.path.dirname(__file__),
                                             '../data/charts/affiliation_barchart.json'),
                                data=data,
                                title='Affiliation')
    )

if __name__ == '__main__':
    make_barchart()
