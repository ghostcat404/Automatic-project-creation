import os
import sys
from pathlib import Path
from github import Github


def create_project(u_name, passwd, folder_name):
    # Create repository on Github
    user = Github(u_name, passwd).get_user()
    repo = user.create_repo(folder_name)
    print("Repository {repo} created Succesfully".format(repo=folder_name))

if __name__ == '__main__':
    create_project(sys.argv[1], sys.argv[2], sys.argv[3])
