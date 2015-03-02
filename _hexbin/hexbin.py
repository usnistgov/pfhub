import urllib2 as urllib
import io
from PIL import Image
import yaml
import json
import progressbar

data = yaml.load(open('hexbin.yaml', 'r'))['images']

X, Y = 173, 200 ## thumbnail size

N = len(data)

## the 10 x 10 image is hardwired into phase_field_hexbin.js right now
ni = 10 ## number of images in X direction
nj = 10 ## number of images in Y direction

## resize the yaml file into ni * nj sized json file to be read into
## the javascript

data_resize = (data * (1 + ((ni* nj) // N)))[:ni * nj]
s = json.dumps(data_resize)
open('../json/hexbin.json', 'w').write(s)

## Populate the canvas

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
    
blank_image.save('../images/hexbin.jpg', 'JPEG')




