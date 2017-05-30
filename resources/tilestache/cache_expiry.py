import psycopg2
import tilestacheseed
import os
import subprocess
import sys
import time

try:
    conn = psycopg2.connect("dbname='maps' user='docker' host='172.17.0.1' password='docker'")
    print "Connected to database"
except Exception,e:
    print e
    print "Exiting..."
    sys.exit()

while (True):
    bound = None
    cur = conn.cursor()
    cur.execute("""select bounds, created_at from tile_cache_expirations where processed_at is null order by created_at desc limit 1""")
    rows = cur.fetchall()
    for row in rows:
        bound = row[0]
        timestamp = row[1]
    if bound is not None:
        print 'Rendering tiles for bounding box ' + str(bound)
        cmd = 'python tilestacheseed.py -c /tilestache.cfg --ignore-cached -b ' + str(bound) + ' -l roadquality -e png 14 15 16 17'
        FNULL = open(os.devnull, 'w')
        subprocess.call(cmd, shell=True, stdout=FNULL, stderr=subprocess.STDOUT, close_fds=True)
        cur.execute("UPDATE tile_cache_expirations SET processed_at = now() where created_at = (%s)", [timestamp])
        conn.commit()
        print '...done'
    # Close communication with the database
    cur.close()
    time.sleep(3)
