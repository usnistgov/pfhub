import urllib2 as urllib
import io
from PIL import Image
import yaml
import progressbar

data = yaml.load(open('codes.yaml', 'r'))

X, Y = 40, 40

N = len(data)

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
    image_url = d['logo_url']
    im = thumbnail_image(image_url, (X, Y))  
    d['thumbnail'] = im
    pbar.update(i + 1)
    im.save('../images/{0}_logo.jpg'.format(d['name']), 'JPEG')
    

pbar.finish()





    



