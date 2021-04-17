#!/bin/sh

git filter-branch --env-filter '
    export GIT_COMMITTER_NAME="NinjaLikesCheez"
    export GIT_COMMITTER_EMAIL="thomashedderwick@gmail.com"
    export GIT_AUTHOR_NAME="NinjaLikesCheez"
    export GIT_AUTHOR_EMAIL="thomashedderwick@gmail.com"
' --tag-name-filter cat -- --branches --tags
