# This script shows how to connect to a Jira instance with a
# username and password over HTTP BASIC authentication.

from collections import Counter
from typing import cast

from jira import JIRA
from jira.client import ResultList
from jira.resources import Issue

# By default, the client will connect to a Jira instance started from the Atlassian Plugin SDK.
# See
# https://developer.atlassian.com/display/DOCS/Installing+the+Atlassian+Plugin+SDK
# for details.

# username and password over HTTP BASIC authentication.

from collections import Counter
from typing import cast

from jira import JIRA
from jira.client import ResultList
from jira.resources import Issue

# By default, the client will connect to a Jira instance started from the Atlassian Plugin SDK.
# See
# https://developer.atlassian.com/display/DOCS/Installing+the+Atlassian+Plugin+SDK
# for details.

from argparse import ArgumentParser

class Bunch(dict):
    __getattr__, __setattr__ = dict.get, dict.__setitem__

parser = ArgumentParser()
parser.add_argument("-f", "--file", dest="filename",
                    help="write report to FILE", metavar="FILE")
parser.add_argument("-s", dest="secret",
                    help="token for jira", required=True)
parser.add_argument("-v", dest="version",
                    help="Jira Version Id for release notes", required=True)

args = parser.parse_args()

jira = JIRA(
  basic_auth=("enoceangmbh@gmail.com", args.secret),
  options={
    'server': "https://enocean-cloud.atlassian.net/"
  }
)

ver_id = args.version

jra = jira.project("EIOTC")

#print(jra.name)

heading = jra.name

versions = jira.project_versions(jra)
ver_name = ''
#print(versions)
for ver in versions:

    if ver.id == ver_id:
        ver_name= ver.name
        heading += ' - '+ ver_name
        if ver.released == True:
            heading += ' Released'
        elif ver.released == False:
            heading += ' Not released'

if ver_name=='':
    print("version unknown")
    exit(1)

search = 'fixVersion = \"'+ver_name+'\" AND \"Customer Include[Dropdown]\" = Yes'

issues = jira.search_issues(search)

logs = {}

class Bunch(dict):
    __getattr__, __setattr__ = dict.get, dict.__setitem__

issue_map = {
    "Task":"Features",
    "Story":"Features",
    "Bug":"Bugs",
    "Subtask":"Features"

}

def lookupIssueType(issueType):
    if issueType in issue_map:
        return issue_map[issueType]
    return ""


for issue in issues:

#Init the dictionary
    if issue.fields.customfield_10029==None:
        issue.fields.customfield_10029=Bunch(value="None")
    if issue.fields.customfield_10029.value not in logs:
        logs[issue.fields.customfield_10029.value] = {}
    if lookupIssueType(issue.fields.issuetype.name) not in logs[issue.fields.customfield_10029.value]:
        logs[issue.fields.customfield_10029.value][lookupIssueType(issue.fields.issuetype.name)] = []
#add string
    if issue.fields.customfield_10032 != None:
        issueText= issue.fields.customfield_10032
    else:
        issueText= issue.fields.summary

    logs[issue.fields.customfield_10029.value][lookupIssueType(issue.fields.issuetype.name)].append(issueText)



result=''

result+= "# "+heading+'\n\n'

def write_category(log_entry, name):
    result="## "+name+'\n\n'
    for category in log_entry:
        result+="### "+category+'\n\n'
        for entry in log_entry[category]:
            result+="- "+entry+'\n'
        result+='\n'
    return result

if "None" in logs:
    result+=write_category(logs["None"], "General")
    logs.pop("None")

for log in sorted(logs):
    result+=write_category(logs[log], log+" Container")

print(result)

f = open("notes.md", "w+")
f.write(result)
f.close()
