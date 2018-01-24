"""Generate the doi.csv file for simulation DOIs
"""
# pylint: disable=no-value-for-parameter

import os

import pandas
from toolz.curried import pipe, do, itemmap, curry
from dateutil.parser import parse


from simulations import get_yaml_data


def to_doi_csv(csvfile):
    """Generate DOI csv file from simulation records

    This function reads from the meta.yaml's and writes to doi.csv

    Args:
      csvfile: the CSV file to write to

    Returns:
      a dictionary with file names as keys and values as dictionaries
      of the updated YAML data.
    """
    return pipe(
        get_yaml_data(),
        dict,
        itemmap(mapping_func),
        do(write_csv_data(csvfile))
    )


@curry
def write_csv_data(csvfile, data):
    """Writes data to a CSV file using Pandas

    Args:
      csvfile: the CSV file to write to
      data: the data to write
    """
    pandas.DataFrame(list(data.values())).to_csv(csvfile)


def mapping_func(data):
    """Maps simulation data to DOI data

    Args:
      data: the data to transform
    """
    def meta(data):
        """Return the metadata section
        """
        return data[1]['metadata']

    def keywords():
        """Common keywords for all simulations
        """
        return ["phase-field", "materials-science"]

    def urlbase():
        """The base URL for the simulation links.
        """
        return "https://pages.nist.gov/pfhub/simulations/display/?sim="

    return (
        data[0],
        dict(
            CreatorFN=meta(data)['author']['first'],
            CreatorLN=meta(data)['author']['last'],
            Title=data[0],
            PublicationYear=parse(meta(data)['timestamp']).strftime("%Y"),
            Location=urlbase() + data[0],
            DOI="I WILL PROVIDE",
            ResourceType="Dataset/Benchmark",
            Subject=",".join(
                keywords() + [meta(data)["implementation"]["name"]]
            ),
            date=parse(meta(data)['timestamp']).strftime("%Y/%m/%d"),
            Language="en",
            AlternativeIdentifier=data[1]['benchmark']['id'],
            RelatedIdentifier="https://doi.org/10.18434/M32H3J",
            Format="application/x-yaml",
            Rights="I WILL PROVIDE",
            Summary=meta(data)["summary"]
        )
    )


if __name__ == "__main__":
    to_doi_csv("doi.csv")
