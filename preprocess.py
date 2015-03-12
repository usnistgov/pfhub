import yaml
import json

def codes_yaml_to_json():
    data = yaml.load(open('_data/codes.yaml', 'r'))
    open('data/codes.json', 'w').write(json.dumps(data))
    
if __name__ == '__main__':
    codes_yaml_to_json()





    



