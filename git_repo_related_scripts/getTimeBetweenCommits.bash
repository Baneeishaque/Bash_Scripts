for ix in `git rev-list master`; do 
  thists=`git log $ix -n 1 --format=%ct`; 
  prevts=`git log $ix~1 -n 1 --format=%ct 2>/dev/null`; 
  if [ ! -z "$prevts" ] ; then 
    delta=$(( $thists - $prevts )); 
    echo `date -d @$thists +'%Y-%m-%d %H:%M:%S'` "-->"  \
         `date -d @$prevts +'%Y-%m-%d %H:%M:%S'` " ;= " \
         # `date -d @$delta +'%H:%M:%S'`;
		 `python -c "import datetime as dt; d = dt.timedelta(seconds=$delta); print(d)"`;
  fi; 
done