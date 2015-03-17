import yaml
import json
import github
import requests
import re

class GitHubStats(object):
    def __init__(self, user, repo):
        github.Github
        self.base_url = 'https://api.github.com/repos/{user}/{repo}'.format(user=user, repo=repo)
        self.issues = self.get_issues()

    def get_issues(self):
        issues = []        
        url = self.base_url + '/issues'
        while url:
            request = requests.get(url)
            issues += request.json()
            url = self.get_next_page(request)
        return issues
    
    def get_next_page(self, request):
        link = request.headers['link'].split(',')[0]
        if 'rel="next"' in link:
            link = request.headers['link'].split(',')[0]
            return re.findall(r'<(.*?)>', link)[0]
        else:
            return False
        
    @property
    def number_of_open_issues(self):
        print self.issues[0]
        return len([issue for issue in self.issues if issue['state'] == 'open'])
            
        
def codes_yaml_to_json():
    data = yaml.load(open('_data/codes.yaml', 'r'))
    open('data/codes.json', 'w').write(json.dumps(data))


if __name__ == '__main__':
    # codes_yaml_to_json()
    stats = GitHubStats('usnistgov', 'fipy')
    print stats.number_of_open_issues

    



