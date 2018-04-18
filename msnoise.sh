set -ex

#:<<COMMENTBLOCK
rm -rf db.ini msnoise.sqlite STACKS allday allstack
printf "1\n\n" | msnoise install

#msnoise admin

./msnoise_config.sh


msnoise populate

msnoise -t 32 scan_archive --init
#msnoise -t 32 scan_archive

# sqlite3 msnoise.sqlite "DELETE FROM jobs"
# sqlite3 msnoise.sqlite "UPDATE data_availability SET flag='N'"
msnoise new_jobs

#COMMENTBLOCK
# filter
sqlite3 msnoise.sqlite "DELETE FROM filters"
sqlite3 msnoise.sqlite "INSERT INTO filters (low, high, used) VALUES (0.1, 0.99, 1)"
sqlite3 msnoise.sqlite "INSERT INTO filters (low, high, used) VALUES (0.1, 0.4, 1)"
sqlite3 msnoise.sqlite "INSERT INTO filters (low, high, used) VALUES (0.1, 0.333, 1)"

#rm -rf STACKS allday allstack
#sqlite3 msnoise.sqlite "DELETE FROM jobs WHERE Jobtype='DTT'"
#sqlite3 msnoise.sqlite "UPDATE jobs SET flag='T'"
msnoise -t 32 compute_cc || true

echo All jobs finished.

#COMMENTBLOCK
#rm -rf allday allstack
#sqlite3 msnoise.sqlite "DELETE FROM jobs WHERE jobtype='DTT'"
#sqlite3 msnoise.sqlite "UPDATE config SET value = 'linear' WHERE name = 'stack_method'"
msnoise stack -r

# loop during pairs!!!!!!
# select daily-ccf to stack according to correlation with all-day-stacked ccf
csh select-days.csh
