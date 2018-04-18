set -ex

sqlite3 msnoise.sqlite "UPDATE config SET value = 'HDH' WHERE name = 'channels'"
sqlite3 msnoise.sqlite "UPDATE config SET value = 'HH' WHERE name = 'components_to_compute'"
sqlite3 msnoise.sqlite "UPDATE config SET value = '2015-01-01' WHERE name = 'startdate'"
sqlite3 msnoise.sqlite "UPDATE config SET value = '2018-01-01' WHERE name = 'enddate'"
sqlite3 msnoise.sqlite "UPDATE config SET value = '200' WHERE name = 'maxlag'"
sqlite3 msnoise.sqlite "UPDATE config SET value = '2015-01-01' WHERE name = 'ref_begin'"
sqlite3 msnoise.sqlite "UPDATE config SET value = '2018-01-01' WHERE name = 'ref_end'"
#-------------------------

sqlite3 msnoise.sqlite "UPDATE config SET value = 'data' WHERE name='data_folder'"

# msnoise config --set data_folder=data/

sqlite3 msnoise.sqlite "UPDATE config SET value = 'ccf' WHERE name = 'output_folder'"
sqlite3 msnoise.sqlite "UPDATE config SET value = 'NET/CHAN-STA/STA.YEAR.DAY.CHAN.sac' WHERE name = 'data_structure'"
# msnoise config --set network=""
#msnoise config --set startdate="2014-xx-xx"
#msnoise config --set enddate="2014-xx-xx"

# msnoise config --set analysis_duration=default,86400s
sqlite3 msnoise.sqlite "UPDATE config SET value = '4' WHERE name = 'cc_sampling_rate'"
sqlite3 msnoise.sqlite "UPDATE config SET value = 'Resample' WHERE name = 'resampling_method'"
# msnoise config --set decimation_factor=be ignored if you don't use decimate method # no this parameter in 1.5!!!
sqlite3 msnoise.sqlite "UPDATE config SET value = '2.0' WHERE name = 'preprocess_lowpass'"
sqlite3 msnoise.sqlite "UPDATE config SET value = '0.02' WHERE name = 'preprocess_highpass'"
# 50 s

sqlite3 msnoise.sqlite "UPDATE config SET value = 'N' WHERE name = 'remove_response'"
#msnoise config --set response_format=paz
#msnoise config --set response_path=data_folder/PZs
#msnoise config --set response_prefilt="(0.001,0.002,1.8,2)"
sqlite3 msnoise.sqlite "UPDATE config SET value = '1800' WHERE name = 'corr_duration'"
sqlite3 msnoise.sqlite "UPDATE config SET value = '0' WHERE name = 'overlap'"
# 
sqlite3 msnoise.sqlite "UPDATE config SET value = '3' WHERE name = 'windsorizing'"
sqlite3 msnoise.sqlite "UPDATE config SET value = 'A' WHERE name = 'whitening'"
sqlite3 msnoise.sqlite "UPDATE config SET value = 'pws' WHERE name = 'stack_method'"
sqlite3 msnoise.sqlite "UPDATE config SET value = '10.0' WHERE name = 'pws_timegate'"
sqlite3 msnoise.sqlite "UPDATE config SET value = '2.0' WHERE name = 'pws_power'"

# msnoise config --set crondays=for velocity changes, ignore
sqlite3 msnoise.sqlite "UPDATE config SET value = 'N' WHERE name = 'autocorr'"
sqlite3 msnoise.sqlite "UPDATE config SET value = 'N' WHERE name = 'keep_all'"
sqlite3 msnoise.sqlite "UPDATE config SET value = 'Y' WHERE name = 'keep_days'"
# msnoise config --set mov_stack=for velocity changes, ignore
# 
sqlite3 msnoise.sqlite "UPDATE config SET value = 'SAC' WHERE name = 'export_format'"
# msnoise config --set sac_format= ???

# for velocity changes, ignore
# msnoise config --set dtt_lag=
# msnoise config --set dtt_v=
# msnoise config --set dtt_minlag=
# msnoise config --set dtt_width=
# msnoise config --set dtt_sides=
# msnoise config --set dtt_mincoh=
# msnoise config --set dtt_maxerr=
# msnoise config --set dtt_maxdt=

# msnoise config --set plugins=default

# msnoise 1.5
