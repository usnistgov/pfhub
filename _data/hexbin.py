"""Build the thumbnails for the hexbin
"""

import itertools
from random import shuffle
import sys

import json
import io
import urllib

import yaml
from PIL import Image
import requests


def check_status(datum):
    """Check that both the url and image link are valid URLs and that the
    image link isn't just a redirect.
    """
    if requests.get(datum["url"], verify=False).status_code != 200:
        return False
    get_ = requests.get(datum["image"], verify=False)
    if get_.status_code != 200:
        return False
    if get_.url != datum["image"]:
        return False
    return True


def hexbin_yaml_to_json():
    """Generate JSON image data from the YAML.
    """
    data = yaml.load(open("_data/hexbin.yaml", "r", errors="ignore"))
    data = list(filter(check_status, data))
    shuffle(data)
    data_resize = list(itertools.islice(itertools.cycle(data), 100))
    data_string = json.dumps(data_resize)
    open("_data/hexbin.json", "w").write(data_string)
    return data_resize


def thumbnail_image(image_url, size):
    """Create a thumbnail from an image URL.
    """
    try:
        with urllib.request.urlopen(image_url) as stream:
            image_file = io.BytesIO(stream.read())
    except Exception:
        print("image_url:", image_url)
        raise
    image = Image.open(image_file)
    size = list(size)
    if size[0] is None:
        if image.size[0] > image.size[1]:
            ratio = float(image.size[0]) / float(image.size[1])
            size[0] = int(ratio * size[1])
        else:
            size[0] = size[1]
    image.thumbnail(size, Image.ANTIALIAS)
    im0 = Image.new("RGBA", size, (255, 255, 255, 0))

    im0.paste(image, ((size[0] - image.size[0]) // 2, (size[1] - image.size[1]) // 2))
    return im0


def hexbin_image(data, x_size, y_size, ni_count, nj_count):
    """Build the combined thumbnails
    """
    image_count = len(data)

    for counter, datum in enumerate(data):
        image_url = datum["image"]
        image = thumbnail_image(image_url, (x_size, y_size))
        datum["thumbnail"] = image
        sys.stdout.write(f"\rProgress: {counter} / {image_count}")
        sys.stdout.flush()

    blank_image = Image.new(
        "RGB", (x_size * nj_count, y_size * ni_count), (255, 255, 255, 0)
    )

    for i_count in range(ni_count):
        for j_count in range(nj_count):
            ii_count = (i_count * ni_count + j_count) % len(data)
            image = data[ii_count]["thumbnail"]
            blank_image.paste(image, (x_size * j_count, y_size * i_count))

    blank_image.save("images/hexbin.jpg", "JPEG")


if __name__ == "__main__":
    # the 10 x 10 image is hardwired into phase_field_hexbin.js right now
    NI_SIZE, NJ_SIZE = 10, 10
    X_SIZE, Y_SIZE = 173, 200  # thumbnail size
    DATA = hexbin_yaml_to_json()
    hexbin_image(DATA, X_SIZE, Y_SIZE, NI_SIZE, NJ_SIZE)
