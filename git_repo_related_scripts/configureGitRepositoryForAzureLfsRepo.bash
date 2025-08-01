git config http.version HTTP/1.1
git config credential.helper 'cache --timeout=3600'
git config lfs.activitytimeout 1000
git config lfs.$(git remote get-url origin).git/info/lfs.locksverify true