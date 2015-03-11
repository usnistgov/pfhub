import yaml
import json

data = yaml.load(open('codes.yaml', 'r'))
open('../data/codes.json', 'w').write(json.dumps(data))





    



