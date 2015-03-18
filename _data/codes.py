import yaml
import json
import github
import requests
import re

class GitHubStats(object):
    def __init__(self, user, repo):
        github.Github
        self.base_url = 'https://api.github.com/repos/{user}/{repo}'.format(user=user, repo=repo)

    def paginate(self, ext):
        items = []        
        url = self.base_url + ext
        while url:
            request = requests.get(url)
            items += request.json()
            url = self.get_next_page(request)
        return items

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

    def get_stats(self):
        issues = self.paginate('/issue?state=open')
        contributors = self.paginate('/stats/contributors')
        commit_activity = self.paginate('/stats/commit_activity')
        
        return {
            'open_issues' : len(issues),
            'total_contributors' : len(contributors),
            'yearly_commits' : commit_activity['total']
            }
        
def codes_yaml_to_json():
    data = yaml.load(open('_data/codes.yaml', 'r'))
    open('data/codes.json', 'w').write(json.dumps(data))


if __name__ == '__main__':
    # codes_yaml_to_json()
    stats = GitHubStats('usnistgov', 'fipy')
    print get_stats

    



