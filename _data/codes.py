import yaml
import json
import requests
import re
import click
import os
import datetime
import dateutil
import dateutil.tz
import dateutil.parser

import hexbin

@click.command()
@click.option('--cache/--no-cache', default=True, help='Whether to cache the GitHub data')
def run(cache):
    codes_yaml = 'codes.yaml'
    codes_json = 'codes.json'
    in_dir = os.path.split(__file__)[0]
    base_dir = os.path.join(in_dir, os.pardir)
    out_dir = os.path.join(base_dir, 'data')
    codes_yaml_path = os.path.join(in_dir, codes_yaml)
    codes_json_path = os.path.join(out_dir, codes_json)
    
    with open(codes_yaml_path, 'r') as f:
        data = yaml.load(f)

    data_out = list()
    for code in data:
        cache_json = '{0}.json'.format(code['name'])
        cache_json_path = os.path.join(os.path.split(__file__)[0], cache_json)
        user = code['github']['user']
        repo = code['github']['repo']
        gh = GitHubAPI(user, repo, cache_file=cache_json_path, cache=cache)

        code_out = code.copy()
        code_out['stats'] = gh.get_stats()
        code_out.update(gh.get_description())
        links = make_links(code_out)
        code_out['links'] = links
        data_out.append(code_out)

        make_logo(code, code_out, base_dir)
        
    with open(codes_json_path, 'w') as f:
        f.write(json.dumps(data_out))

def make_logo(code, code_out, base_dir):
    image_url = code.get('logo', None)
    if image_url:
        im = hexbin.thumbnail_image(image_url, (None, 30))
        jpg_name = '{0}_logo.jpg'.format(code['name'])
        image_path = os.path.join(base_dir, 'images', jpg_name)
        im.save(image_path, 'JPEG')
        code_out['logo'] = image_path

def make_links(code):
    links = [{'name' : 'Home', 'url' : code['home_page']},
             {'name' : 'GitHub', 'url' : code['github_url']}]

    if 'openhub' in code.keys():
        links.append({'name' : 'OpenHub',
                      'url' : 'https://www.openhub.net/p/{0}'.format(code['openhub']['repo'])})

    return links

class GitHubAPI(object):
    def __init__(self, user, repo, cache=True, cache_file='cache.json'):
        self.base_url = 'https://api.github.com/repos/{user}/{repo}'.format(user=user, repo=repo)
        self.cache = cache
        self.cache_file = cache_file

    def read_cache(self):
        if os.path.exists(self.cache_file):
            with open(self.cache_file, 'r') as f:
                return json.load(f)
            return dict()
        else:
            return dict()
        
    def get_cache(self, key):
        data = self.read_cache()
        return data.get(key, None)
    
    def set_cache(self, key, value):
        data = self.read_cache()
        data[key] = value
        with open(self.cache_file, 'w') as f:
            json.dump(data, f)

    def get_request(self, url):
        request = requests.get(url)
        print()
        print('get request')
        print('x-ratelimit-remaining: ',request.headers['x-ratelimit-remaining'])
        print('x-ratelimit-reset: ',datetime.datetime.fromtimestamp(
              int(request.headers['x-ratelimit-reset'])).strftime('%Y-%m-%d %H:%M:%S'))
        print('url: ',request.url)
        print()      
        request.raise_for_status()
        return request

    def paginate(self, ext='', key=None, cache=None):
        if cache is None:
            cache = self.cache

        if key is None:
            key = ext
        if cache:
            value = self.get_cache(key)
        else:
            value = []

        if value:
            return value
        else:
            value = []
            url = self.base_url + ext
            while url:
                request = self.get_request(url)
                v = request.json()
                if type(v) is list:
                    value += v
                else:
                    value.append(v)
                url = self.get_next_page_url(request)

            self.set_cache(key, value)

            return value

    def get_next_page_url(self, request):
        key = 'link'
        if key not in request.headers:
            return None
        else:
            link = request.headers[key].split(',')[0]
            if 'rel="next"' in link:
                link = request.headers[key].split(',')[0]
                return re.findall(r'<(.*?)>', link)[0]
            else:
                return None

    def get_yearly_contributors(self, contributors):
        
        last52 = lambda contributor: [week['c'] for week in contributor['weeks'][-52:]]
        commits_per_contributor =  [sum(last52(contributor)) \
                                    for contributor in contributors]
        yearly_contributors = len([commits for commits in commits_per_contributor if commits > 0])
        return yearly_contributors

    def get_yearly_closed_issues(self, issues):
        yearly_closed_issues = []
        for issue in issues:
            if issue['state'] == 'closed':
                datestring = issue['closed_at']
                tz = dateutil.tz.tzlocal()
                date = dateutil.parser.parse(datestring).astimezone(tz)
                one_year_ago = datetime.datetime.now(tz) - datetime.timedelta(days=365)
                if date > one_year_ago:
                    yearly_closed_issues.append(issue)
        return len(yearly_closed_issues)

    def get_open_issues(self, issues):
        return len([issue for issue in issues if issue['state'] == 'open'])
    
    def get_stats(self):
        open_issues = self.paginate('/issues?state=open')

        # one_year_ago = datetime.datetime.now() - datetime.timedelta(days=365)
        # since = one_year_ago.isoformat()
        # closed_issues = self.paginate('/issues?state=closed&since={0}'.format(since))
        
        contributors = self.paginate('/stats/contributors')
        commit_activity = self.paginate('/stats/commit_activity')

        base_url = 'https://github.com/usnistgov/fipy'

        return [{'name' : 'Total Contributors',
                 'url' : '',
                 'value' : len(contributors)},
                 {'name' : 'Total Commits',
                  'url' : '',
                  'value' : sum([_['total'] for _ in contributors])},
                  {'name' : 'Total Open Issues',
                   'url' : '/'.join([base_url, '?q=is:issue+is:open']),
                   'value' : self.get_open_issues(open_issues)},
                   {'name' : 'Recent Contributors',
                    'url' : '',
                    'value' : self.get_yearly_contributors(contributors)},
                    {'name' : 'Recent Commits',
                     'url' : '',
                     'value' : sum([_['total'] for _ in commit_activity])},
                     # {'name' : 'Recent Closed Issues',
                     #  'url' : '',
                     #  'value' : self.get_yearly_closed_issues(closed_issues)}
                     ]

    def get_description(self):
        description = self.paginate(key='repo_')[0]
        return {'home_page' : description['homepage'],
                'language' : description['language'],
                'github_url' : description['html_url']}

if __name__ == "__main__":
    run()
    


