"""Usage: preprocess.py [--hexbin] [--codes]

--hexbin        make the hexbin data
--codes         make the code data

"""


import yaml
import json
import io
import urllib
from PIL import Image
import progressbar
from docopt import docopt


def codes_yaml_to_json():
    data = yaml.load(open('_data/codes.yaml', 'r'))
    open('data/codes.json', 'w').write(json.dumps(data))

def hexbin_yaml_to_json(ni, nj):
    data = yaml.load(open('_data/hexbin.yaml', 'r'))['images']

    N = len(data)

    ## resize the yaml file into ni * nj sized json file to be read into
    ## the javascript

    data_resize = (data * (1 + ((ni* nj) // N)))[:ni * nj]
    s = json.dumps(data_resize)
    open('data/hexbin.json', 'w').write(s)
    return data

def thumbnail_image(image_url, size):
    try:
        fd = urllib.urlopen(image_url)
        image_file = io.BytesIO(fd.read())
    except:
        print "image_url:",image_url
        raise
    im = Image.open(image_file)
    im.thumbnail(size, Image.ANTIALIAS)
    im0 = Image.new('RGBA', size, (255, 255, 255, 0))
    im0.paste(im, ((size[0] - im.size[0]) / 2, (size[1] - im.size[1]) / 2))
    return im0

def hexbin_image(data, X, Y, ni, nj):
    widgets = [progressbar.Percentage(),
               ' ',
               progressbar.Bar(marker=progressbar.RotatingMarker()),
               ' ',
               progressbar.ETA()]
    
    pbar = progressbar.ProgressBar(widgets=widgets, maxval=len(data)).start()

    for i, d in enumerate(data):
        image_url = d['image']
        im = thumbnail_image(image_url, (X, Y))  
        d['thumbnail'] = im
        pbar.update(i + 1)

    pbar.finish()

    blank_image = Image.new("RGB", (X * nj, Y * ni), (255, 255, 255, 0))

    for i in range(ni):
        for j in range(nj):
            ii = (i * ni + j) % len(data)
            im = data[ii]['thumbnail']
            blank_image.paste(im, (X * j, Y * i))
    
    blank_image.save('images/hexbin.jpg', 'JPEG')

if __name__ == '__main__':
    arguments = docopt(__doc__, version='0.1dev')
    if arguments['--codes']:
        codes_yaml_to_json()

    if arguments['--hexbin']:
        ## the 10 x 10 image is hardwired into phase_field_hexbin.js right now
        ni, nj = 10, 10
        X, Y = 173, 200 ## thumbnail size
        data = hexbin_yaml_to_json(ni, nj)
        hexbin_image(data, X, Y, ni, nj)



    



