mysql -uroot -e "show databases" | grep -v Database | grep -v mysql| grep -v information_schema| grep -v performance_schema| grep -v sys| gawk '{print "drop database `" $1 "`;select sleep(60);"}' | mysql -uroot