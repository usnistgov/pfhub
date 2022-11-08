#!/usr/bin/env python3

# MIME types:
# <https://www.iana.org/assignments/media-types/media-types.xhtml#application>

# Country Codes:
# <https://en.wikipedia.org/wiki/ISO_3166-1#Current_codes>

# Unit codes:
# <http://wiki.goodrelations-vocabulary.org/Documentation/UN/CEFACT_Common_Codes>
# <http://www.unece.org/fileadmin/DAM/cefact/recommendations/rec20/rec20_Rev9e_2014.xls>
#
# kilobyte: 2P   #         1,000 bytes
# megabyte: 4L   #     1,000,000 bytes
# gigabyte: E34  # 1,000,000,000 bytes
#
# kibibyte: E64  #         1,024 bytes
# mebibyte: E63  #     1,048,576 bytes
# gibibyte: E62  # 1,073,741,824 bytes

from schemaorg.main import Schema
from schemaorg.main.parse import RecipeParser
from schemaorg.templates.google import make_dataset
# from spython.main.parse.parsers import DockerParser

from pygments import highlight
from pygments.lexers import JsonLexer as lexer
from pygments.formatters import TerminalFormatter as formatter

import json

# === load the schema ===

recipe = RecipeParser("upload-recipe.yml")

# === Organization ===

nist = Schema("GovernmentOrganization")
addr = Schema("PostalAddress")
addr.add_property("streetAddress", "100 Bureau Drive")
addr.add_property("addressLocality", "Gaithersburg")
addr.add_property("addressRegion", "Maryland")
addr.add_property("postalCode", "20899")
addr.add_property("addressCountry", "US")

nist.add_property("name", "National Institute of Standards and Technology")
nist.add_property("parentOrganization", "U.S. Department of Commerce")
nist.add_property("address", addr)
nist.add_property("identifier", "NIST")
nist.add_property("url", "https://www.nist.gov")

mml = Schema("GovernmentOrganization")
mml.add_property("name", "Material Measurement Laboratory")
mml.add_property("parentOrganization", nist)

msed = Schema("GovernmentOrganization")
msed.add_property("name", "Materials Science and Engineering Division")
msed.add_property("parentOrganization", mml)

# === Dramatis Personae ===

tkphd = Schema("Person")
tkphd.add_property("givenName", "Trevor")
tkphd.add_property("familyName", "Keller")
tkphd.add_property("affiliation", msed)
tkphd.add_property("email", "trevor.keller@nist.gov")
tkphd.add_property("identifier", "tkphd")
tkphd.add_property("homepage", "https://github.com/tkphd")
tkphd.add_property("sameAs", "https://orcid.org/0000-0002-2920-8302")

wd15 = Schema("Person")
wd15.add_property("givenName", "Daniel")
wd15.add_property("familyName", "Wheeler")
wd15.add_property("affiliation", msed)
wd15.add_property("email", "daniel.wheeler@nist.gov")
wd15.add_property("identifier", "wd15")
wd15.add_property("homepage", "https://github.com/wd15")
wd15.add_property("sameAs", "https://orcid.org/0000-0002-2653-7418")

# === Top-level details ===

catalog = Schema("DataCatalog")
keywords = [
    "phase-field",
    "benchmarks",
    "pfhub",
    "fipy",
    "homogeneous-nucleation"
]

catalog.add_property("author", [tkphd, wd15])
catalog.add_property("title", "fipy_8a_fake_tkphd")
catalog.add_property("description", "A fake dataset for Benchmark 8a unprepared using FiPy by @tkphd & @wd15")
catalog.add_property("programmingLanguage", "Python")
catalog.add_property("license", "https://www.nist.gov/open/license#software")
catalog.add_property("dateCreated", "2022-10-25T19:25:02+00:00")
catalog.add_property("keywords", keywords)

# === Benchmark ===

spec = Schema("Series")  # also consider Action
spec.add_property("name", "Homogeneous Nucleation")
spec.add_property("url", "https://pages.nist.gov/pfhub/benchmarks/benchmark8.ipynb")
spec.add_property("identifier", "8a")
spec.add_property("version", 1)

catalog.add_property("isPartOf", spec)

# === Framework ===

code = Schema("SoftwareApplication")

code.add_property("name", "FiPy")
code.add_property("url", "https://www.ctcms.nist.gov/fipy")
code.add_property("downloadUrl", "https://github.com/usnistgov/fipy")
code.add_property("softwareVersion", "052ede9bfe2a99df6603e1b36ece8a1137889220")

# === Repository ===

repo = Schema("SoftwareSourceCode")

repo.add_property("softwareRequirements", code)

repo.add_property("codeRepository", "https://github.com/tkphd/fake-pfhub-bm8a")
repo.add_property("description", "Fake benchmark 8a upload with FiPy")
repo.add_property("runtimePlatform", "fipy")
repo.add_property("targetProduct", "amd64")
repo.add_property("version", "9df6603e")

catalog.add_property("isBasedOn", repo)

# === Runtime Info ===

info = []

info.append(Schema("PropertyValue"))
info[-1].add_property("name", "parallel_nodes")
info[-1].add_property("value", 1)

info.append(Schema("PropertyValue"))
info[-1].add_property("name", "cpu_architecture")
info[-1].add_property("value", "amd64")

info.append(Schema("PropertyValue"))
info[-1].add_property("name", "parallel_cores")
info[-1].add_property("value", 12)

info.append(Schema("PropertyValue"))
info[-1].add_property("name", "parallel_gpus")
info[-1].add_property("value", 1)

info.append(Schema("PropertyValue"))
info[-1].add_property("name", "gpu_architecture")
info[-1].add_property("value", "nvidia")

info.append(Schema("PropertyValue"))
info[-1].add_property("name", "gpu_cores")
info[-1].add_property("value", 6144)

info.append(Schema("PropertyValue"))
info[-1].add_property("name", "wall_time")
info[-1].add_property("value", 384)
info[-1].add_property("unitCode", "SEC")
info[-1].add_property("unitText", "s")

info.append(Schema("PropertyValue"))
info[-1].add_property("name", "memory_usage")
info[-1].add_property("value", 1835)
info[-1].add_property("unitCode", "E63")
info[-1].add_property("unitText", "mebibyte")

meta = Schema("Dataset")
meta.add_property("name", "irl")
meta.add_property("distribution", info)

# === Output Data ===

files = []

for i in range(3):
    for t in ["free_energy", "solid_fraction"]:
        f = Schema("DataDownload")

        f.add_property("name", t.replace("_", " "))
        f.add_property("contentUrl",
                       "8a/{}_{}.csv".format(t, i+1))
        f.add_property("encodingType", "text/csv")

        files.append(f)

data = Schema("Dataset")

data.add_property("name", "output")
data.add_property("distribution", files)

catalog.add_property("dataset", [meta, data])

# === Validation & Output ===

if recipe.validate(catalog):
    print()

    pfdata = json.loads(catalog.dump_json())
    with open("pfdata.json", "w") as fh:
        json.dump(pfdata, fh,
                  indent=4,
                  separators=(",", ": "),
                  sort_keys=True)
        fh.write("\n")

    # print(highlight(catalog.dump_json(pretty_print=True), lexer(), formatter()))
    # print()

    make_dataset(catalog, "pfdata.html", template="google/visual-dataset.html")
else:
    print("Please try again.")
